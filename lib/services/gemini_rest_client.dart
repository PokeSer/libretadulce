import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Thrown when the Gemini REST API returns an error response.
class GeminiApiException implements Exception {
  /// HTTP status code (e.g. 400, 429, 503), if available.
  final int? statusCode;

  /// Google API status string (e.g. "UNAVAILABLE", "RESOURCE_EXHAUSTED").
  final String? status;

  /// Human-readable error message from the API.
  final String message;

  GeminiApiException(this.message, {this.statusCode, this.status});

  /// Fatal errors: retrying or trying another model won't help (bad key,
  /// invalid request, no permission). Surface these to the user immediately.
  bool get isFatal {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return true;
    }
    final s = status?.toUpperCase();
    if (s == 'INVALID_ARGUMENT' ||
        s == 'UNAUTHENTICATED' ||
        s == 'PERMISSION_DENIED') {
      return true;
    }
    final m = message.toLowerCase();
    return m.contains('api key') ||
        m.contains('api_key') ||
        m.contains('permission');
  }

  /// Transient errors worth retrying on the SAME model (short server blips).
  bool get isTransient {
    if (statusCode == 503 || statusCode == 500) return true;
    final s = status?.toUpperCase();
    return s == 'UNAVAILABLE' || s == 'INTERNAL' || s == 'DEADLINE_EXCEEDED';
  }

  /// Availability errors that should trigger a fallback to another model
  /// (overloaded, rate-limited, or model not found). Distinct from [isFatal].
  bool get isAvailabilityError {
    if (isFatal) return false;
    if (statusCode == 503 ||
        statusCode == 500 ||
        statusCode == 429 ||
        statusCode == 404) {
      return true;
    }
    final s = status?.toUpperCase();
    return s == 'UNAVAILABLE' ||
        s == 'INTERNAL' ||
        s == 'RESOURCE_EXHAUSTED' ||
        s == 'NOT_FOUND';
  }

  @override
  String toString() =>
      'GeminiApiException(status: $statusCode/$status): $message';
}

/// Thrown when the response was blocked by safety filters.
class GeminiBlockedException implements Exception {
  final String reason;
  GeminiBlockedException(this.reason);
  @override
  String toString() => 'GeminiBlockedException: $reason';
}

/// Minimal REST client for the Gemini Developer API.
///
/// Uses a per-user API key (from AI Studio) and the stable public endpoint
/// `generativelanguage.googleapis.com`, so it does not depend on the
/// deprecated `google_generative_ai` package.
class GeminiRestClient {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Calls `generateContent` and returns the text of the first candidate.
  ///
  /// [models] is an ordered preference list. The first model is tried first;
  /// if it is unavailable (overloaded/rate-limited/not-found), the client
  /// automatically falls back to the next model in the list. This lets the
  /// app prefer a newer model while staying reliable when it is saturated on
  /// the free tier.
  ///
  /// [parts] is the list of request parts, e.g.:
  ///   [{'text': '...'}, {'inlineData': {'mimeType': 'image/jpeg', 'data': b64}}]
  ///
  /// Retries automatically on transient errors (503/500) with exponential
  /// backoff. Throws [GeminiApiException], [GeminiBlockedException], or
  /// [TimeoutException] on failure.
  static Future<String> generateContent({
    required String apiKey,
    required List<String> models,
    required List<Map<String, dynamic>> parts,
    String? systemInstruction,
    double temperature = 0.2,
    int maxOutputTokens = 2048,
    String responseMimeType = 'application/json',
    int maxAttempts = 3,
    Duration timeout = const Duration(seconds: 60),
    Duration baseRetryDelay = const Duration(milliseconds: 800),
    http.Client? httpClient,
  }) async {
    assert(models.isNotEmpty, 'At least one model is required.');

    final body = <String, dynamic>{
      'contents': [
        {'role': 'user', 'parts': parts},
      ],
      'generationConfig': {
        'temperature': temperature,
        'maxOutputTokens': maxOutputTokens,
        'responseMimeType': responseMimeType,
      },
    };
    if (systemInstruction != null && systemInstruction.isNotEmpty) {
      body['systemInstruction'] = {
        'parts': [
          {'text': systemInstruction},
        ],
      };
    }
    final encodedBody = jsonEncode(body);

    final client = httpClient ?? http.Client();
    final ownsClient = httpClient == null;
    try {
      GeminiApiException? lastError;
      for (var i = 0; i < models.length; i++) {
        final model = models[i];
        final isLastModel = i == models.length - 1;
        // Only spend retry budget on the last (most reliable) model; fall back
        // quickly from unavailable preferred models.
        final attemptsForModel = isLastModel ? maxAttempts : 1;
        try {
          return await _generateOnce(
            client: client,
            apiKey: apiKey,
            model: model,
            encodedBody: encodedBody,
            maxAttempts: attemptsForModel,
            timeout: timeout,
            baseRetryDelay: baseRetryDelay,
          );
        } on GeminiApiException catch (e) {
          lastError = e;
          // Bad key / invalid request: no point trying other models.
          if (e.isFatal) rethrow;
          // Unavailable model: fall back to the next one if there is any.
          if (e.isAvailabilityError && !isLastModel) {
            debugPrint(
              '[GeminiRestClient] Model "$model" unavailable ($e). '
              'Falling back to "${models[i + 1]}".',
            );
            continue;
          }
          rethrow;
        }
      }
      throw lastError ?? GeminiApiException('Unknown error.');
    } finally {
      if (ownsClient) client.close();
    }
  }

  /// Performs the actual HTTP call for a single model, retrying transient
  /// (503/500) failures with exponential backoff.
  static Future<String> _generateOnce({
    required http.Client client,
    required String apiKey,
    required String model,
    required String encodedBody,
    required int maxAttempts,
    required Duration timeout,
    required Duration baseRetryDelay,
  }) async {
    final uri = Uri.parse('$_baseUrl/$model:generateContent');
    GeminiApiException? lastError;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      http.Response response;
      try {
        response = await client
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                // The key travels in a header instead of the URL so it does
                // not leak into logs/proxies.
                'x-goog-api-key': apiKey,
              },
              body: encodedBody,
            )
            .timeout(timeout);
      } on TimeoutException {
        rethrow;
      }

      if (response.statusCode == 200) {
        return _extractText(response.body);
      }

      final error = _parseError(response);
      lastError = error;

      // Only retry the same model on short transient blips.
      if (!error.isTransient || attempt == maxAttempts) {
        throw error;
      }

      final delay = baseRetryDelay * (1 << (attempt - 1));
      debugPrint(
        '[GeminiRestClient] Transient error on "$model" (attempt $attempt/'
        '$maxAttempts), retrying in ${delay.inMilliseconds}ms: $error',
      );
      await Future<void>.delayed(delay);
    }

    throw lastError ?? GeminiApiException('Unknown error.');
  }

  /// Parse a non-200 response body into a [GeminiApiException].
  static GeminiApiException _parseError(http.Response response) {
    String message = 'HTTP ${response.statusCode}';
    String? status;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['error'] is Map) {
        final err = decoded['error'] as Map;
        message = (err['message'] as String?) ?? message;
        status = err['status'] as String?;
      }
    } catch (_) {
      // Body wasn't JSON; keep the generic message.
    }
    return GeminiApiException(
      message,
      statusCode: response.statusCode,
      status: status,
    );
  }

  /// Extract the text from a successful generateContent response.
  static String _extractText(String responseBody) {
    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      throw GeminiApiException('Malformed response from Gemini.');
    }

    // Top-level promptFeedback block (whole prompt rejected).
    final promptFeedback = decoded['promptFeedback'] as Map<String, dynamic>?;
    if (promptFeedback != null && promptFeedback['blockReason'] != null) {
      throw GeminiBlockedException(promptFeedback['blockReason'].toString());
    }

    final candidates = decoded['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw GeminiApiException('Empty response from Gemini.');
    }

    final first = candidates.first as Map<String, dynamic>;
    final finishReason = first['finishReason'] as String?;
    if (finishReason == 'SAFETY' || finishReason == 'PROHIBITED_CONTENT') {
      throw GeminiBlockedException(finishReason ?? 'SAFETY');
    }

    final content = first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw GeminiApiException('No content returned by Gemini.');
    }

    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map && part['text'] is String) {
        buffer.write(part['text'] as String);
      }
    }
    return buffer.toString();
  }
}
