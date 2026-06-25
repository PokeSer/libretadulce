import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:libretadulce/services/gemini_rest_client.dart';

/// Build a successful generateContent response body.
String _okBody(String text, {String finishReason = 'STOP'}) => jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': text},
            ],
          },
          'finishReason': finishReason,
        },
      ],
    });

/// Build an error envelope body.
String _errBody(int code, String status, String message) => jsonEncode({
      'error': {'code': code, 'status': status, 'message': message},
    });

/// Extract the model name from a generateContent request URL.
String _modelOf(http.BaseRequest request) {
  final segment = request.url.pathSegments.last; // e.g. "gemini-3.5-flash:generateContent"
  return segment.split(':').first;
}

const _noRetry = Duration.zero;
const _parts = [
  {'text': 'hello'},
];

void main() {
  group('GeminiRestClient.generateContent', () {
    test('returns text on a successful response', () async {
      final client = MockClient((req) async => http.Response(_okBody('HELLO'), 200));

      final result = await GeminiRestClient.generateContent(
        apiKey: 'k',
        models: const ['gemini-2.5-flash'],
        parts: _parts,
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(result, 'HELLO');
    });

    test('sends the API key in the x-goog-api-key header (not the URL)', () async {
      String? sentKey;
      Uri? sentUri;
      final client = MockClient((req) async {
        sentKey = req.headers['x-goog-api-key'];
        sentUri = req.url;
        return http.Response(_okBody('OK'), 200);
      });

      await GeminiRestClient.generateContent(
        apiKey: 'secret-key',
        models: const ['gemini-2.5-flash'],
        parts: _parts,
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(sentKey, 'secret-key');
      expect(sentUri.toString(), isNot(contains('secret-key')));
    });

    test('falls back to the next model on 503', () async {
      final calledModels = <String>[];
      final client = MockClient((req) async {
        final model = _modelOf(req);
        calledModels.add(model);
        if (model == 'gemini-3.5-flash') {
          return http.Response(_errBody(503, 'UNAVAILABLE', 'overloaded'), 503);
        }
        return http.Response(_okBody('FROM_FALLBACK'), 200);
      });

      final result = await GeminiRestClient.generateContent(
        apiKey: 'k',
        models: const ['gemini-3.5-flash', 'gemini-2.5-flash'],
        parts: _parts,
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(result, 'FROM_FALLBACK');
      expect(calledModels, ['gemini-3.5-flash', 'gemini-2.5-flash']);
    });

    test('falls back to the next model on 429 (rate limited)', () async {
      final client = MockClient((req) async {
        if (_modelOf(req) == 'gemini-3.5-flash') {
          return http.Response(
              _errBody(429, 'RESOURCE_EXHAUSTED', 'Too Many Requests'), 429);
        }
        return http.Response(_okBody('OK2'), 200);
      });

      final result = await GeminiRestClient.generateContent(
        apiKey: 'k',
        models: const ['gemini-3.5-flash', 'gemini-2.5-flash'],
        parts: _parts,
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(result, 'OK2');
    });

    test('does NOT fall back on a fatal error (invalid API key)', () async {
      var requestCount = 0;
      final client = MockClient((req) async {
        requestCount++;
        return http.Response(
            _errBody(400, 'INVALID_ARGUMENT', 'API key not valid'), 400);
      });

      await expectLater(
        GeminiRestClient.generateContent(
          apiKey: 'bad',
          models: const ['gemini-3.5-flash', 'gemini-2.5-flash'],
          parts: _parts,
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(isA<GeminiApiException>()),
      );
      expect(requestCount, 1, reason: 'must not try the fallback model');
    });

    test('retries the same model on transient 503 then succeeds', () async {
      var attempts = 0;
      final client = MockClient((req) async {
        attempts++;
        if (attempts < 3) {
          return http.Response(_errBody(503, 'UNAVAILABLE', 'overloaded'), 503);
        }
        return http.Response(_okBody('RECOVERED'), 200);
      });

      final result = await GeminiRestClient.generateContent(
        apiKey: 'k',
        models: const ['gemini-2.5-flash'],
        parts: _parts,
        httpClient: client,
        maxAttempts: 3,
        baseRetryDelay: _noRetry,
      );

      expect(result, 'RECOVERED');
      expect(attempts, 3);
    });

    test('throws GeminiBlockedException when blocked by safety', () async {
      final client = MockClient(
        (req) async => http.Response(_okBody('', finishReason: 'SAFETY'), 200),
      );

      await expectLater(
        GeminiRestClient.generateContent(
          apiKey: 'k',
          models: const ['gemini-2.5-flash'],
          parts: _parts,
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(isA<GeminiBlockedException>()),
      );
    });

    test('throws GeminiApiException when there are no candidates', () async {
      final client = MockClient(
        (req) async => http.Response(jsonEncode({'candidates': []}), 200),
      );

      await expectLater(
        GeminiRestClient.generateContent(
          apiKey: 'k',
          models: const ['gemini-2.5-flash'],
          parts: _parts,
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(isA<GeminiApiException>()),
      );
    });

    test('surfaces the final error after all models are exhausted', () async {
      final client = MockClient(
        (req) async =>
            http.Response(_errBody(503, 'UNAVAILABLE', 'overloaded'), 503),
      );

      await expectLater(
        GeminiRestClient.generateContent(
          apiKey: 'k',
          models: const ['gemini-3.5-flash', 'gemini-2.5-flash'],
          parts: _parts,
          httpClient: client,
          maxAttempts: 1,
          baseRetryDelay: _noRetry,
        ),
        throwsA(isA<GeminiApiException>()),
      );
    });
  });

  group('GeminiApiException classification', () {
    test('400/401/403 are fatal', () {
      for (final code in [400, 401, 403]) {
        expect(GeminiApiException('x', statusCode: code).isFatal, isTrue);
      }
    });

    test('invalid-key message is fatal regardless of code', () {
      expect(GeminiApiException('API key not valid').isFatal, isTrue);
    });

    test('503/500 are transient and retryable', () {
      expect(GeminiApiException('x', statusCode: 503).isTransient, isTrue);
      expect(GeminiApiException('x', statusCode: 500).isTransient, isTrue);
    });

    test('429 is an availability error but not transient (no same-model retry)',
        () {
      final e = GeminiApiException('Too Many Requests',
          statusCode: 429, status: 'RESOURCE_EXHAUSTED');
      expect(e.isAvailabilityError, isTrue);
      expect(e.isTransient, isFalse);
      expect(e.isFatal, isFalse);
    });

    test('404 NOT_FOUND triggers fallback but is not fatal', () {
      final e =
          GeminiApiException('not found', statusCode: 404, status: 'NOT_FOUND');
      expect(e.isAvailabilityError, isTrue);
      expect(e.isFatal, isFalse);
    });
  });
}
