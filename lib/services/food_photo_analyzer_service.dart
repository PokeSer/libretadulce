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
  final String? glycemicIndex;

  const GeminiFoodItem({
    required this.name,
    required this.grams,
    required this.carbsPer100g,
    this.kcalPer100g,
    this.proteinsPer100g,
    this.fatsPer100g,
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

  /// Get the configured API key.
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyPref);
  }

  /// Save an API key.
  static Future<void> saveApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPref, key.trim());
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
    final langName = languageNames[locale] ?? 'Spanish';

    final model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 2048,
        responseMimeType: 'application/json',
      ),
      systemInstruction: Content.text(
        'You are a professional nutritionist AI specialized in food analysis for diabetes management. '
        'When shown a photo of a meal, you must identify each food item and estimate its nutritional values. '
        'ALWAYS respond in $langName language. '
        'Respond with a JSON object containing 3 fields:\n'
        '1. "summary": A friendly, natural-language description of what you see on the plate. '
        'Mention each food and its estimated portion. Use everyday language. '
        'Example: "En este plato veo aproximadamente 180g de arroz blanco, 120g de pechuga de pollo a la plancha y una ensalada verde de unos 80g."\n'
        '2. "notes": IMPORTANT: Always state clearly that these values are AI-generated estimates, '
        'not laboratory measurements. The user should verify portions with a kitchen scale for accurate carb counting. '
        'Mention that actual carbs depend on cooking method, brand, and specific ingredients. '
        'Be helpful but emphasize the limitations.\n'
        '3. "items": A JSON array. Each object must have: '
        '"name" (string), "grams" (number, your best estimate of the portion in grams), '
        '"carbsPer100g" (number, grams of carbohydrates per 100g of this food - use standard nutritional databases), '
        '"kcalPer100g" (optional number), "proteinsPer100g" (optional number), "fatsPer100g" (optional number), '
        '"glycemicIndex" (optional string, one of: "Alto", "Medio", "Bajo", or null if unknown).\n'
        'CRITICAL RULES:\n'
        '- Be conservative with carb estimates. For a diabetes app, underestimating carbs is dangerous.\n'
        '- If uncertain about an ingredient, round carb values UP.\n'
        '- Use standard nutritional reference values (USDA, BEDCA, CREA).\n'
        '- For mixed dishes (e.g. paella, lasagna), break down into main components.\n'
        '- If you cannot identify a food with confidence, omit it rather than guessing.\n'
        '- grams must be between 1 and 5000.\n'
        '- carbsPer100g must be between 0 and 100.\n'
        '- Do NOT include any text outside the JSON object.',
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
