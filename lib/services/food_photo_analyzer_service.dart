import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  static const _apiKeyPref = 'gemini_api_key';
  static const _privacyAcceptedPref = 'gemini_privacy_accepted';
  static const _photoTipDismissedPref = 'gemini_photo_tip_dismissed';

  /// Reactive notifier — `true` when a non-empty API key is configured.
  /// Widgets can use `ValueListenableBuilder` to rebuild automatically
  /// when the key is saved or cleared, without FutureBuilder caching issues.
  static final ValueNotifier<bool> apiKeyConfigured =
      ValueNotifier<bool>(false);

  /// Call once at app start to initialise [apiKeyConfigured] from storage.
  static Future<void> initApiKeyStatus() async {
    final key = await getApiKey();
    apiKeyConfigured.value = key != null && key.isNotEmpty;
  }

  /// Get the configured API key.
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPref);
  }

  /// Save an API key and immediately update [apiKeyConfigured].
  static Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, key.trim());
    apiKeyConfigured.value = key.trim().isNotEmpty;
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
      throw Exception('No Gemini API key configured.');
    }

    // Safety: validate file size (max 5 MB)
    final fileSize = await imageFile.length();
    if (fileSize > 5 * 1024 * 1024) {
      throw Exception('Image too large. Please use a smaller photo.');
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

    final model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 2048,
        responseMimeType: 'application/json',
      ),
      systemInstruction: Content.text(
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
        '- Do NOT include any text, explanation, or markdown outside the JSON object.',
      ),
    );

    final imageBytes = await imageFile.readAsBytes();
    final content = Content.multi([
      TextPart(
        'Analyze this food plate photo. '
        'Respond ONLY with a JSON object (not an array). '
        'Write everything in $langName language.',
      ),
      DataPart('image/jpeg', imageBytes),
    ]);

    final GenerateContentResponse response;
    try {
      response = await model.generateContent([content]);
    } on GenerativeAIException catch (e) {
      debugPrint('[FoodPhotoAnalyzerService] Gemini API error: $e');
      throw Exception(_userFriendlyGeminiError(e.message));
    } catch (e) {
      debugPrint('[FoodPhotoAnalyzerService] Error: $e');
      if (e.toString().contains('Timeout')) {
        throw Exception('The analysis is taking too long. Please try again.');
      }
      throw Exception('Network error. Check your connection and try again.');
    }

    final text = response.text;

    if (text == null || text.isEmpty) {
      // Check if blocked/filtered
      final candidates = response.candidates;
      if (candidates.isNotEmpty &&
          candidates.first.finishReason == FinishReason.safety) {
        throw Exception(
          'The photo could not be analyzed. Make sure it shows food, not people or sensitive content.',
        );
      }
      throw Exception('No response from Gemini. Please try again.');
    }

    // Detect Gemini error messages in the text (API overload, quota, etc.)
    if (_isGeminiErrorText(text)) {
      throw Exception(
        'The AI service is currently overloaded. Please wait a moment and try again.',
      );
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
      // If text looks like an error message, pass it through
      if (text.length < 500 &&
          (text.contains('error') ||
              text.contains('sorry') ||
              text.contains('unable') ||
              text.contains('cannot'))) {
        throw Exception(text.trim());
      }
      throw Exception(
        'Could not process the analysis result. Please take another photo with better lighting and a clear view of the plate.',
      );
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
      throw Exception(
        'No food items could be detected. Try a clearer photo showing the full plate from above.',
      );
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

  /// Translate technical Gemini errors into user-friendly messages.
  static String _userFriendlyGeminiError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('quota') || lower.contains('rate limit')) {
      return 'Daily request limit reached. Please try again tomorrow.';
    }
    if (lower.contains('invalid') || lower.contains('api key')) {
      return 'Invalid API key. Please check your key in Settings.';
    }
    if (lower.contains('permission') || lower.contains('access')) {
      return 'Your API key does not have access to this model. Check aistudio.google.com.';
    }
    return 'Service temporarily unavailable. Please try again in a moment.';
  }
}
