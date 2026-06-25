import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ai_service_exception.dart';
import 'gemini_rest_client.dart';

/// Result from Gemini food photo analysis.
class GeminiFoodItem {
  final String name;
  final double grams;
  final double carbsPer100g;
  final double? kcalPer100g;
  final double? proteinsPer100g;
  final double? fatsPer100g;
  final double? fiberPer100g;
  final String? glycemicIndex;

  const GeminiFoodItem({
    required this.name,
    required this.grams,
    required this.carbsPer100g,
    this.kcalPer100g,
    this.proteinsPer100g,
    this.fatsPer100g,
    this.fiberPer100g,
    this.glycemicIndex,
  });

  factory GeminiFoodItem.fromJson(Map<String, dynamic> json) {
    return GeminiFoodItem(
      name: json['name'] ?? '',
      grams: (json['grams'] as num?)?.toDouble() ?? 100.0,
      carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble() ?? 0.0,
      kcalPer100g: (json['kcalPer100g'] as num?)?.toDouble(),
      proteinsPer100g: (json['proteinsPer100g'] as num?)?.toDouble(),
      fatsPer100g: (json['fatsPer100g'] as num?)?.toDouble(),
      fiberPer100g: (json['fiberPer100g'] as num?)?.toDouble(),
      glycemicIndex: json['glycemicIndex'] as String?,
    );
  }

  /// Validate that this item has reasonable nutritional data.
  bool get isValid =>
      name.isNotEmpty &&
      grams > 0 &&
      grams <= 5000 &&
      carbsPer100g >= 0 &&
      carbsPer100g <= 100;
}

/// Complete analysis result from Gemini.
class GeminiAnalysisResult {
  final String summary;
  final String notes;
  final List<GeminiFoodItem> items;

  const GeminiAnalysisResult({
    required this.summary,
    required this.notes,
    required this.items,
  });
}

/// Service for analyzing food photos using Gemini 2.5 Flash.
class FoodPhotoAnalyzerService {
  /// Storage key for the Gemini API key. Used both as the secure-storage key
  /// and as the legacy `SharedPreferences` key for one-time migration.
  static const _apiKeyPref = 'gemini_api_key';
  static const _privacyAcceptedPref = 'gemini_privacy_accepted';
  static const _photoTipDismissedPref = 'gemini_photo_tip_dismissed';

  /// Encrypted storage for the API key (Android Keystore / iOS Keychain).
  /// The API key is a credential, so it must not live in plaintext
  /// `SharedPreferences`. v10+ encrypts Android data with custom ciphers
  /// backed by the Keystore by default.
  static const _secureStorage = FlutterSecureStorage();

  /// Reactive notifier — `true` when a non-empty API key is configured.
  /// Widgets can use `ValueListenableBuilder` to rebuild automatically
  /// when the key is saved or cleared, without FutureBuilder caching issues.
  static final ValueNotifier<bool> apiKeyConfigured =
      ValueNotifier<bool>(false);

  /// Call once at app start to initialise [apiKeyConfigured] from storage.
  /// Also migrates any key previously stored in plaintext `SharedPreferences`
  /// into encrypted secure storage.
  static Future<void> initApiKeyStatus() async {
    await _migrateLegacyKeyIfNeeded();
    final key = await getApiKey();
    apiKeyConfigured.value = key != null && key.isNotEmpty;
  }

  /// Moves an API key stored by older app versions in plaintext
  /// `SharedPreferences` into encrypted secure storage, then removes the
  /// plaintext copy. Runs at most once (no-op afterwards).
  static Future<void> _migrateLegacyKeyIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final legacyKey = prefs.getString(_apiKeyPref);
      if (legacyKey == null) return; // nothing to migrate
      if (legacyKey.isNotEmpty) {
        final existing = await _secureStorage.read(key: _apiKeyPref);
        if (existing == null || existing.isEmpty) {
          await _secureStorage.write(key: _apiKeyPref, value: legacyKey);
        }
      }
      // Remove the plaintext copy regardless, so it never lingers.
      await prefs.remove(_apiKeyPref);
    } catch (e) {
      debugPrint('[FoodPhotoAnalyzerService] Key migration skipped: $e');
    }
  }

  /// Get the configured API key from encrypted storage.
  static Future<String?> getApiKey() async {
    return _secureStorage.read(key: _apiKeyPref);
  }

  /// Save an API key (or clear it when empty) and update [apiKeyConfigured].
  static Future<void> saveApiKey(String key) async {
    final trimmed = key.trim();
    if (trimmed.isEmpty) {
      await _secureStorage.delete(key: _apiKeyPref);
    } else {
      await _secureStorage.write(key: _apiKeyPref, value: trimmed);
    }
    apiKeyConfigured.value = trimmed.isNotEmpty;
  }

  /// Check if user has accepted privacy notice.
  static Future<bool> hasAcceptedPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_privacyAcceptedPref) ?? false;
  }

  /// Mark privacy notice as accepted.
  static Future<void> acceptPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_privacyAcceptedPref, true);
  }

  /// Check if the photo tip has been permanently dismissed.
  static Future<bool> isPhotoTipDismissed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_photoTipDismissedPref) ?? false;
  }

  /// Permanently dismiss the photo tip dialog.
  static Future<void> dismissPhotoTip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_photoTipDismissedPref, true);
  }

  /// Analyze a food photo with Gemini 2.5 Flash.
  /// [locale] is the user's app language (e.g. "es", "en", "cs").
  /// Returns structured result with summary, notes, and items.
  static Future<GeminiAnalysisResult> analyze(
    File imageFile, {
    required String locale,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiServiceException(AiErrorType.noApiKey);
    }

    // Safety: validate file size (max 5 MB)
    final fileSize = await imageFile.length();
    if (fileSize > 5 * 1024 * 1024) {
      throw const AiServiceException(AiErrorType.imageTooLarge);
    }

    final languageNames = {
      'cs': 'Czech',
      'de': 'German',
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'it': 'Italian',
      'pl': 'Polish',
      'pt': 'Portuguese',
    };
    final langName = languageNames[locale] ?? 'English';

    const giLabels = {
      'en': (low: 'Low',     mid: 'Medium',  high: 'High'),
      'es': (low: 'Bajo',    mid: 'Medio',   high: 'Alto'),
      'fr': (low: 'Faible',  mid: 'Moyen',   high: 'Élevé'),
      'it': (low: 'Basso',   mid: 'Medio',   high: 'Alto'),
      'de': (low: 'Niedrig', mid: 'Mittel',  high: 'Hoch'),
      'pt': (low: 'Baixo',   mid: 'Médio',   high: 'Alto'),
      'pl': (low: 'Niski',   mid: 'Średni',  high: 'Wysoki'),
      'cs': (low: 'Nízký',   mid: 'Střední', high: 'Vysoký'),
    };
    final gi = giLabels[locale] ?? giLabels['en']!;

    final systemInstruction =
        'You are a professional clinical nutritionist AI specialized in diabetes management and glycemic control. '
        'You analyze food photos to help people with diabetes make informed dietary decisions.\n\n'
        'LANGUAGE: You MUST write ALL response text (summary, notes, food names, glycemic index labels) '
        'in $langName language. Only JSON field names must remain in English.\n\n'
        'RESPONSE FORMAT: A single JSON object with exactly 3 fields:\n'
        '1. "summary": A concise, professional description of the plate contents. '
        'List each food with its estimated portion in grams. '
        'Example for Spanish: "He identificado aproximadamente 180g de arroz blanco, '
        '120g de pechuga de pollo a la plancha y una ensalada verde de unos 80g."\n\n'
        '2. "notes": Provide 2-3 sentences covering:\n'
        '   a) A clear disclaimer that values are AI estimates, not lab measurements.\n'
        '   b) One practical, diabetes-specific tip about this meal (e.g., high-GI warning, '
        'fiber benefit, suggested portion adjustment, or insulin timing consideration).\n'
        '   c) Recommend verifying portions with a kitchen scale for accurate insulin dosing.\n'
        'Keep the tone helpful and empathetic, not alarming.\n\n'
        '3. "items": A JSON array — one object per identified food/dish component. Each object must have:\n'
        '   - "name" (string): Food name in $langName.\n'
        '   - "grams" (number): Estimated portion in grams (1-5000).\n'
        '   - "carbsPer100g" (number): Carbs per 100g from nutritional databases (0-100).\n'
        '   - "kcalPer100g" (optional number): Calories per 100g.\n'
        '   - "proteinsPer100g" (optional number): Protein per 100g.\n'
        '   - "fatsPer100g" (optional number): Fat per 100g.\n'
        '   - "fiberPer100g" (optional number): Fiber per 100g.\n'
        '   - "glycemicIndex" (optional string): MUST be one of "${gi.high}", "${gi.mid}", "${gi.low}" '
        '(in $langName language), or omit if unknown.\n\n'
        'CRITICAL RULES:\n'
        '- Be conservative: when uncertain, round carb values UP — underestimating carbs '
        'can lead to insulin dosing errors in diabetes management.\n'
        '- Use authoritative nutritional databases (USDA, BEDCA for Spain, CREA for Italy, CIQUAL for France).\n'
        '- For composite dishes (paella, lasagna, stews), break them into main components with individual estimates.\n'
        '- If you cannot confidently identify an item, OMIT it rather than guessing.\n'
        '- Take into account visible cooking methods: fried foods have more fat, boiled/steamed foods retain more water weight.\n'
        '- For the glycemicIndex field: "${gi.low}" = GI ≤55, "${gi.mid}" = GI 56-69, "${gi.high}" = GI ≥70.\n'
        '- Do NOT include any text, explanation, or markdown outside the JSON object.';

    final imageBytes = await imageFile.readAsBytes();

    final String text;
    try {
      text = await GeminiRestClient.generateContent(
        apiKey: apiKey,
        models: const ['gemini-3.5-flash', 'gemini-2.5-flash'],
        systemInstruction: systemInstruction,
        temperature: 0.1,
        maxOutputTokens: 2048,
        parts: [
          {
            'text': 'Analyze this food plate photo. '
                'Respond ONLY with a JSON object (not an array). '
                'Write everything in $langName language.',
          },
          {
            'inlineData': {
              'mimeType': 'image/jpeg',
              'data': base64Encode(imageBytes),
            },
          },
        ],
      );
    } on GeminiBlockedException catch (e) {
      debugPrint('[FoodPhotoAnalyzerService] Blocked: $e');
      throw const AiServiceException(AiErrorType.blockedContent);
    } on GeminiApiException catch (e) {
      debugPrint('[FoodPhotoAnalyzerService] Gemini API error: $e');
      throw AiServiceException(_geminiErrorType(e));
    } on TimeoutException {
      throw const AiServiceException(AiErrorType.timeout);
    } catch (e) {
      debugPrint('[FoodPhotoAnalyzerService] Error: $e');
      throw const AiServiceException(AiErrorType.network);
    }

    if (text.isEmpty) {
      throw const AiServiceException(AiErrorType.emptyResponse);
    }

    // Detect Gemini error messages in the text (API overload, quota, etc.)
    if (_isGeminiErrorText(text)) {
      throw const AiServiceException(AiErrorType.serviceUnavailable);
    }

    // Parse the JSON response
    final Map<String, dynamic> json;
    try {
      var cleaned = text.trim();
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.replaceFirst(RegExp(r'```(?:json)?\s*'), '');
        cleaned = cleaned.replaceFirst(RegExp(r'```\s*$'), '');
      }
      json = jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[FoodPhotoAnalyzerService] JSON parse error: $e\nRaw: $text');
      throw const AiServiceException(AiErrorType.couldNotProcess);
    }

    // Parse items
    final rawItems = json['items'] as List<dynamic>?;
    final items =
        rawItems
            ?.map((i) => GeminiFoodItem.fromJson(i as Map<String, dynamic>))
            .where((item) => item.isValid)
            .toList() ??
        [];

    // Parse summary and notes, with fallbacks
    final summary = json['summary'] as String? ?? '';
    final notes = json['notes'] as String? ?? '';

    // Safety: ensure we got at least 1 valid item
    if (items.isEmpty) {
      throw const AiServiceException(AiErrorType.noFood);
    }

    return GeminiAnalysisResult(summary: summary, notes: notes, items: items);
  }

  /// Check if the text is actually a Gemini error message, not JSON.
  static bool _isGeminiErrorText(String text) {
    final lower = text.toLowerCase().trim();
    // Patterns that indicate an API error rather than a valid response
    final errorPatterns = [
      'overloaded',
      'rate limit',
      'quota exceeded',
      'resource exhausted',
      'internal server error',
      'service unavailable',
      'model is overloaded',
      'try again later',
      'currently unavailable',
    ];
    return errorPatterns.any((p) => lower.contains(p));
  }

  /// Map a Gemini API error to a localizable [AiErrorType].
  static AiErrorType _geminiErrorType(GeminiApiException e) {
    final lower = e.message.toLowerCase();
    if (lower.contains('quota') || lower.contains('rate limit')) {
      return AiErrorType.quotaExceeded;
    }
    if (lower.contains('invalid') || lower.contains('api key')) {
      return AiErrorType.invalidApiKey;
    }
    if (lower.contains('permission') || lower.contains('access')) {
      return AiErrorType.noModelAccess;
    }
    return AiErrorType.serviceUnavailable;
  }
}
