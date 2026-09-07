import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Thrown when an OpenAI-compatible API returns an error response.
class AiApiException implements Exception {
  /// HTTP status code (e.g. 400, 401, 429, 503), if available.
  final int? statusCode;

  /// Human-readable error message from the API.
  final String message;

  /// OpenAI-style error type string (e.g. "invalid_request_error").
  final String? errorType;

  AiApiException(this.message, {this.statusCode, this.errorType});

  /// Fatal errors: retrying won't help (bad key, invalid request, no
  /// permission). Surface these to the user immediately.
  bool get isFatal {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return true;
    }
    final m = message.toLowerCase();
    return m.contains('api key') ||
        m.contains('api_key') ||
        m.contains('invalid key') ||
        m.contains('permission');
  }

  /// Transient errors worth retrying on the SAME model (short server blips).
  bool get isTransient {
    if (statusCode == 503 || statusCode == 500) return true;
    return false;
  }

  /// Availability errors (overloaded, rate-limited, model not found).
  /// Distinct from [isFatal] — they usually clear up on their own.
  bool get isAvailabilityError {
    if (isFatal) return false;
    if (statusCode == 503 ||
        statusCode == 500 ||
        statusCode == 429 ||
        statusCode == 404) {
      return true;
    }
    return false;
  }

  @override
  String toString() =>
      'AiApiException(status: $statusCode/$errorType): $message';
}

/// Thrown when the response was blocked by content/safety filters.
class AiBlockedException implements Exception {
  final String reason;
  AiBlockedException(this.reason);
  @override
  String toString() => 'AiBlockedException: $reason';
}

/// Client for any OpenAI-compatible chat API (OpenAI, Groq, OpenRouter,
/// Gemini's compat endpoint, Ollama, LM Studio, ...).
///
/// Replaces the former Gemini-native client with a single protocol:
/// `POST {baseUrl}/chat/completions` with `Authorization: Bearer <key>`.
class AiClient {
  /// Model ids that are definitely not chat models, filtered out of
  /// [fetchModels] results (whisper/tts/embedding/image/moderation).
  static const _nonChatPatterns = [
    'whisper',
    'tts',
    'dall-e',
    'embedding',
    'moderation',
    'sora',
    'realtime',
  ];

  /// Calls `chat/completions` and returns the text of the first choice.
  ///
  /// [systemInstruction] becomes the system message; [userText] the user
  /// message. When [imageBase64] is given (raw base64, no data-URL prefix),
  /// the user message switches to multimodal content with an
  /// `image_url` data-URL part — supported by every vision-capable
  /// OpenAI-compatible API including Gemini's compat endpoint.
  ///
  /// Retries automatically on transient errors (503/500) with exponential
  /// backoff, and makes up to one adaptive retry on a 400 that rejects
  /// `response_format` or `max_tokens` (older/local servers and new OpenAI
  /// models). Throws [AiApiException], [AiBlockedException], or
  /// [TimeoutException] on failure.
  static Future<String> chat({
    required String baseUrl,
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String userText,
    String? imageBase64,
    double temperature = 0.2,
    int maxTokens = 2048,
    int maxAttempts = 3,
    Duration timeout = const Duration(seconds: 60),
    Duration baseRetryDelay = const Duration(milliseconds: 800),
    http.Client? httpClient,
  }) async {
    final client = httpClient ?? http.Client();
    final ownsClient = httpClient == null;
    try {
      return await _chatWithRetries(
        client: client,
        baseUrl: baseUrl,
        apiKey: apiKey,
        model: model,
        systemInstruction: systemInstruction,
        userText: userText,
        imageBase64: imageBase64,
        temperature: temperature,
        maxTokens: maxTokens,
        maxAttempts: maxAttempts,
        timeout: timeout,
        baseRetryDelay: baseRetryDelay,
        useResponseFormat: true,
        useMaxCompletionTokens: false,
      );
    } finally {
      if (ownsClient) client.close();
    }
  }

  static Future<String> _chatWithRetries({
    required http.Client client,
    required String baseUrl,
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String userText,
    required String? imageBase64,
    required double temperature,
    required int maxTokens,
    required int maxAttempts,
    required Duration timeout,
    required Duration baseRetryDelay,
    required bool useResponseFormat,
    required bool useMaxCompletionTokens,
  }) async {
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': systemInstruction},
      if (imageBase64 == null)
        {'role': 'user', 'content': userText}
      else
        {
          'role': 'user',
          'content': [
            {'type': 'text', 'text': userText},
            {
              'type': 'image_url',
              'image_url': {'url': 'data:image/jpeg;base64,$imageBase64'},
            },
          ],
        },
    ];

    final body = <String, dynamic>{
      'model': model,
      'messages': messages,
      'temperature': temperature,
      if (useMaxCompletionTokens)
        'max_completion_tokens': maxTokens
      else
        'max_tokens': maxTokens,
      if (useResponseFormat) 'response_format': {'type': 'json_object'},
    };
    final encodedBody = jsonEncode(body);

    AiApiException? lastError;
    var transientAttempt = 0;
    // Total request budget: maxAttempts transient retries + 2 adaptive
    // parameter retries (drop response_format, then switch max_tokens
    // parameter name) — each adaptive retry is a fresh request.
    var requestCount = 0;

    while (true) {
      requestCount++;
      http.Response response;
      try {
        response = await client
            .post(
              Uri.parse('$baseUrl/chat/completions'),
              headers: {
                'Content-Type': 'application/json',
                // The key travels in the Authorization header, the standard
                // for every OpenAI-compatible provider.
                'Authorization': 'Bearer $apiKey',
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

      // ── Adaptive retry: some servers reject parameters they don't know ──
      if (error.statusCode == 400 && requestCount <= maxAttempts + 2) {
        final lower = error.message.toLowerCase();
        if (useResponseFormat &&
            (lower.contains('response_format') ||
                lower.contains('response format'))) {
          debugPrint(
            '[AiClient] Server rejected response_format, retrying without it.',
          );
          return await _chatWithRetries(
            client: client,
            baseUrl: baseUrl,
            apiKey: apiKey,
            model: model,
            systemInstruction: systemInstruction,
            userText: userText,
            imageBase64: imageBase64,
            temperature: temperature,
            maxTokens: maxTokens,
            maxAttempts: maxAttempts,
            timeout: timeout,
            baseRetryDelay: baseRetryDelay,
            useResponseFormat: false,
            useMaxCompletionTokens: useMaxCompletionTokens,
          );
        }
        if (!useMaxCompletionTokens &&
            (lower.contains('max_tokens') ||
                lower.contains('max completion tokens'))) {
          debugPrint(
            '[AiClient] Server rejected max_tokens, retrying with '
            'max_completion_tokens.',
          );
          return await _chatWithRetries(
            client: client,
            baseUrl: baseUrl,
            apiKey: apiKey,
            model: model,
            systemInstruction: systemInstruction,
            userText: userText,
            imageBase64: imageBase64,
            temperature: temperature,
            maxTokens: maxTokens,
            maxAttempts: maxAttempts,
            timeout: timeout,
            baseRetryDelay: baseRetryDelay,
            useResponseFormat: useResponseFormat,
            useMaxCompletionTokens: true,
          );
        }
      }

      // ── Transient retry with exponential backoff ──
      if (error.isTransient && transientAttempt < maxAttempts - 1) {
        transientAttempt++;
        final delay = baseRetryDelay * (1 << (transientAttempt - 1));
        debugPrint(
          '[AiClient] Transient error (attempt $transientAttempt/'
          '$maxAttempts), retrying in ${delay.inMilliseconds}ms: $error',
        );
        await Future<void>.delayed(delay);
        continue;
      }

      throw lastError;
    }
  }

  /// Fetches the list of chat model ids from `GET {baseUrl}/models`.
  ///
  /// Returns sorted ids with obvious non-chat models (whisper, tts,
  /// embedding, image generation, ...) filtered out. Some local servers
  /// (older Ollama builds) don't expose this endpoint — they throw, and the
  /// UI offers manual model entry instead.
  static Future<List<String>> fetchModels({
    required String baseUrl,
    required String apiKey,
    Duration timeout = const Duration(seconds: 15),
    http.Client? httpClient,
  }) async {
    final client = httpClient ?? http.Client();
    final ownsClient = httpClient == null;
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl/models'),
            headers: {'Authorization': 'Bearer $apiKey'},
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        throw _parseError(response);
      }

      final decoded = jsonDecode(response.body);
      final data = decoded is Map ? decoded['data'] : null;
      if (data is! List) {
        throw AiApiException('Malformed models response.');
      }

      final ids =
          data
              .map((m) => m is Map ? m['id'] : null)
              .whereType<String>()
              .where((id) => !_isNonChatModel(id))
              .toSet()
              .toList()
            ..sort();
      return ids;
    } finally {
      if (ownsClient) client.close();
    }
  }

  /// True when a model id is clearly not a chat model.
  static bool _isNonChatModel(String id) {
    final lower = id.toLowerCase();
    return _nonChatPatterns.any(lower.contains);
  }

  /// Parse a non-200 response body into an [AiApiException].
  ///
  /// Understands the standard OpenAI error envelope
  /// `{error: {message, type, code}}` and falls back to the raw body.
  static AiApiException _parseError(http.Response response) {
    String message = 'HTTP ${response.statusCode}';
    String? errorType;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['error'] is Map) {
        final err = decoded['error'] as Map;
        message = (err['message'] as String?) ?? message;
        errorType = err['type'] as String?;
      }
    } catch (_) {
      // Body wasn't JSON; keep the generic message.
    }
    return AiApiException(
      message,
      statusCode: response.statusCode,
      errorType: errorType,
    );
  }

  /// Extract the text from a successful chat/completions response.
  static String _extractText(String responseBody) {
    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    } catch (e) {
      throw AiApiException('Malformed response from the AI provider.');
    }

    final choices = decoded['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw AiApiException('Empty response from the AI provider.');
    }

    final first = choices.first as Map<String, dynamic>;

    // Content-filtered response: surface as blocked, not as a generic error.
    final finishReason = first['finish_reason'] as String?;
    if (finishReason == 'content_filter') {
      throw AiBlockedException(finishReason ?? 'content_filter');
    }

    final message = first['message'] as Map<String, dynamic>?;
    final content = message?['content'];
    if (content is String) return content;
    if (content is List) {
      // Multimodal-style content array: concatenate the text parts.
      final buffer = StringBuffer();
      for (final part in content) {
        if (part is Map && part['text'] is String) {
          buffer.write(part['text'] as String);
        }
      }
      return buffer.toString();
    }
    throw AiApiException('No content returned by the AI provider.');
  }
}
