import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:libretadulce/services/ai_client.dart';

/// Build a successful chat/completions response body.
String _okBody(String text, {String finishReason = 'stop'}) => jsonEncode({
  'choices': [
    {
      'message': {'role': 'assistant', 'content': text},
      'finish_reason': finishReason,
    },
  ],
});

/// Build an OpenAI-style error envelope body.
String _errBody(int code, String message, {String? type}) => jsonEncode({
  'error': {'code': code, 'message': message, 'type': ?type},
});

/// Extract the request body (JSON-decoded) sent to the mock server.
Map<String, dynamic> _sentBody(http.BaseRequest request) {
  final req = request as http.Request;
  return jsonDecode(req.body) as Map<String, dynamic>;
}

const _noRetry = Duration.zero;

void main() {
  group('AiClient.chat', () {
    test('returns text on a successful response', () async {
      final client = MockClient(
        (req) async => http.Response(_okBody('HELLO'), 200),
      );

      final result = await AiClient.chat(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'k',
        model: 'llama-3.3-70b-versatile',
        systemInstruction: 'You are helpful.',
        userText: 'hello',
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(result, 'HELLO');
    });

    test('sends the API key in the Authorization header (not the URL) and '
        'the system+user messages in the body', () async {
      String? sentAuth;
      Uri? sentUri;
      Map<String, dynamic>? sentBody;
      final client = MockClient((req) async {
        sentAuth = req.headers['authorization'];
        sentUri = req.url;
        sentBody = _sentBody(req);
        return http.Response(_okBody('OK'), 200);
      });

      await AiClient.chat(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'secret-key',
        model: 'some-model',
        systemInstruction: 'SYS',
        userText: 'USER',
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(sentAuth, 'Bearer secret-key');
      expect(sentUri.toString(), 'https://api.example.com/v1/chat/completions');
      expect(sentUri!.query, isEmpty);
      expect(sentBody!['model'], 'some-model');
      final messages = sentBody!['messages'] as List<dynamic>;
      expect(messages.length, 2);
      expect(messages[0]['role'], 'system');
      expect(messages[0]['content'], 'SYS');
      expect(messages[1]['role'], 'user');
      expect(messages[1]['content'], 'USER');
    });

    test(
      'sends an image_url data-URL part when imageBase64 is given',
      () async {
        Map<String, dynamic>? sentBody;
        final client = MockClient((req) async {
          sentBody = _sentBody(req);
          return http.Response(_okBody('OK'), 200);
        });

        await AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'USER',
          imageBase64: 'QUJD',
          httpClient: client,
          baseRetryDelay: _noRetry,
        );

        final messages = sentBody!['messages'] as List<dynamic>;
        final content = messages[1]['content'] as List<dynamic>;
        expect(content.length, 2);
        expect(content[0]['type'], 'text');
        expect(content[0]['text'], 'USER');
        expect(content[1]['type'], 'image_url');
        expect(content[1]['image_url']['url'], 'data:image/jpeg;base64,QUJD');
      },
    );

    test('surfaces a 429 without retrying', () async {
      var calls = 0;
      final client = MockClient((req) async {
        calls++;
        return http.Response(_errBody(429, 'Rate limit reached'), 429);
      });

      await expectLater(
        AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'U',
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(
          isA<AiApiException>().having((e) => e.statusCode, 'status', 429),
        ),
      );
      expect(calls, 1);
    });

    test(
      'retries a 503 with backoff and succeeds on a later attempt',
      () async {
        var calls = 0;
        final client = MockClient((req) async {
          calls++;
          if (calls < 3) {
            return http.Response(_errBody(503, 'Service unavailable'), 503);
          }
          return http.Response(_okBody('RECOVERED'), 200);
        });

        final result = await AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'U',
          maxAttempts: 3,
          httpClient: client,
          baseRetryDelay: _noRetry,
        );

        expect(result, 'RECOVERED');
        expect(calls, 3);
      },
    );

    test('gives up after maxAttempts transient errors', () async {
      var calls = 0;
      final client = MockClient((req) async {
        calls++;
        return http.Response(_errBody(503, 'Service unavailable'), 503);
      });

      await expectLater(
        AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'U',
          maxAttempts: 3,
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(
          isA<AiApiException>().having((e) => e.statusCode, 'status', 503),
        ),
      );
      expect(calls, 3);
    });

    test('does not retry a fatal 401', () async {
      var calls = 0;
      final client = MockClient((req) async {
        calls++;
        return http.Response(_errBody(401, 'Invalid API key'), 401);
      });

      await expectLater(
        AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'bad',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'U',
          maxAttempts: 3,
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(
          isA<AiApiException>().having((e) => e.statusCode, 'status', 401),
        ),
      );
      expect(calls, 1);
    });

    test('throws AiBlockedException on finish_reason content_filter', () async {
      final client = MockClient(
        (req) async =>
            http.Response(_okBody('x', finishReason: 'content_filter'), 200),
      );

      await expectLater(
        AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'U',
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(isA<AiBlockedException>()),
      );
    });

    test('throws when choices is empty', () async {
      final client = MockClient(
        (req) async => http.Response(jsonEncode({'choices': []}), 200),
      );

      await expectLater(
        AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'U',
          httpClient: client,
          baseRetryDelay: _noRetry,
        ),
        throwsA(isA<AiApiException>()),
      );
    });

    test('concatates text parts of a multimodal-style content array', () async {
      final body = jsonEncode({
        'choices': [
          {
            'message': {
              'role': 'assistant',
              'content': [
                {'type': 'text', 'text': 'part-'},
                {'type': 'text', 'text': 'two'},
              ],
            },
            'finish_reason': 'stop',
          },
        ],
      });
      final client = MockClient((req) async => http.Response(body, 200));

      final result = await AiClient.chat(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'k',
        model: 'm',
        systemInstruction: 'SYS',
        userText: 'U',
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(result, 'part-two');
    });

    test('retries without response_format when a 400 mentions it', () async {
      final bodies = <Map<String, dynamic>>[];
      var calls = 0;
      final client = MockClient((req) async {
        calls++;
        bodies.add(_sentBody(req));
        if (calls == 1) {
          return http.Response(
            _errBody(400, "Unrecognized request argument: 'response_format'"),
            400,
          );
        }
        return http.Response(_okBody('OK'), 200);
      });

      final result = await AiClient.chat(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'k',
        model: 'm',
        systemInstruction: 'SYS',
        userText: 'U',
        httpClient: client,
        baseRetryDelay: _noRetry,
      );

      expect(result, 'OK');
      expect(calls, 2);
      expect(bodies[0].containsKey('response_format'), isTrue);
      expect(bodies[1].containsKey('response_format'), isFalse);
    });

    test(
      'retries with max_completion_tokens when a 400 mentions max_tokens',
      () async {
        final bodies = <Map<String, dynamic>>[];
        var calls = 0;
        final client = MockClient((req) async {
          calls++;
          bodies.add(_sentBody(req));
          if (calls == 1) {
            return http.Response(
              _errBody(400, "Unsupported parameter: 'max_tokens'"),
              400,
            );
          }
          return http.Response(_okBody('OK'), 200);
        });

        final result = await AiClient.chat(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          model: 'm',
          systemInstruction: 'SYS',
          userText: 'U',
          maxTokens: 512,
          httpClient: client,
          baseRetryDelay: _noRetry,
        );

        expect(result, 'OK');
        expect(calls, 2);
        expect(bodies[0].containsKey('max_tokens'), isTrue);
        expect(bodies[1].containsKey('max_completion_tokens'), isTrue);
        expect(bodies[1]['max_completion_tokens'], 512);
      },
    );
  });

  group('AiClient.fetchModels', () {
    test('parses and sorts ids, filtering non-chat models', () async {
      final body = jsonEncode({
        'data': [
          {'id': 'llama-3.3-70b-versatile'},
          {'id': 'whisper-large-v3'},
          {'id': 'text-embedding-ada-002'},
          {'id': 'gpt-4o-mini'},
          {'id': 'llama-3.3-70b-versatile'}, // duplicate
        ],
      });
      final client = MockClient((req) async => http.Response(body, 200));

      final models = await AiClient.fetchModels(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'k',
        httpClient: client,
      );

      expect(models, ['gpt-4o-mini', 'llama-3.3-70b-versatile']);
    });

    test('sends the API key in the Authorization header', () async {
      String? sentAuth;
      Uri? sentUri;
      final client = MockClient((req) async {
        sentAuth = req.headers['authorization'];
        sentUri = req.url;
        return http.Response(jsonEncode({'data': []}), 200);
      });

      await AiClient.fetchModels(
        baseUrl: 'https://api.example.com/v1',
        apiKey: 'secret',
        httpClient: client,
      );

      expect(sentAuth, 'Bearer secret');
      expect(sentUri.toString(), 'https://api.example.com/v1/models');
    });

    test('throws AiApiException on a non-200 status', () async {
      final client = MockClient(
        (req) async => http.Response(_errBody(404, 'not found'), 404),
      );

      await expectLater(
        AiClient.fetchModels(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          httpClient: client,
        ),
        throwsA(
          isA<AiApiException>().having((e) => e.statusCode, 'status', 404),
        ),
      );
    });

    test('throws when the response is not the expected shape', () async {
      final client = MockClient(
        (req) async => http.Response(jsonEncode({'unexpected': true}), 200),
      );

      await expectLater(
        AiClient.fetchModels(
          baseUrl: 'https://api.example.com/v1',
          apiKey: 'k',
          httpClient: client,
        ),
        throwsA(isA<AiApiException>()),
      );
    });
  });

  group('AiApiException classification', () {
    test('isFatal for auth/permission errors', () {
      expect(
        AiApiException('Invalid API key', statusCode: 401).isFatal,
        isTrue,
      );
      expect(
        AiApiException('Forbidden: permission denied', statusCode: 403).isFatal,
        isTrue,
      );
      expect(AiApiException('bad request', statusCode: 400).isFatal, isTrue);
    });

    test('isTransient for 5xx server errors only', () {
      expect(AiApiException('x', statusCode: 500).isTransient, isTrue);
      expect(AiApiException('x', statusCode: 503).isTransient, isTrue);
      expect(AiApiException('x', statusCode: 429).isTransient, isFalse);
      expect(AiApiException('x', statusCode: 401).isTransient, isFalse);
    });

    test('isAvailabilityError for rate limit and model-not-found', () {
      expect(
        AiApiException('rate limit', statusCode: 429).isAvailabilityError,
        isTrue,
      );
      expect(
        AiApiException('no such model', statusCode: 404).isAvailabilityError,
        isTrue,
      );
      expect(
        AiApiException('invalid key', statusCode: 401).isAvailabilityError,
        isFalse,
      );
    });
  });
}
