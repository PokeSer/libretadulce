import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/food.dart';
import 'ai_service_exception.dart';
import 'food_photo_analyzer_service.dart';
import 'gemini_rest_client.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

/// Glycemic profile level of a meal.
enum GlycemicProfile { low, medium, high, unknown }

/// Result from the AI meal advisor.
class MealAiAnalysis {
  final GlycemicProfile glycemicProfile;
  final String glycemicSummary;
  final String insulinTiming;
  /// Negative = minutes BEFORE eating, positive = minutes AFTER.
  final int insulinTimingMinutes;
  final List<String> tips;
  final String postMealAdvice;

  const MealAiAnalysis({
    required this.glycemicProfile,
    required this.glycemicSummary,
    required this.insulinTiming,
    required this.insulinTimingMinutes,
    required this.tips,
    required this.postMealAdvice,
  });

  factory MealAiAnalysis.fromJson(Map<String, dynamic> json) {
    final profileStr = (json['glycemicProfile'] as String? ?? '').toUpperCase();
    GlycemicProfile profile;
    if (profileStr.contains('HIGH') || profileStr.contains('ALTO') ||
        profileStr.contains('HAUT') || profileStr.contains('HOCH') ||
        profileStr.contains('ALTO') || profileStr.contains('WYSOKI') ||
        profileStr.contains('VYSOKÝ')) {
      profile = GlycemicProfile.high;
    } else if (profileStr.contains('LOW') || profileStr.contains('BAJO') ||
        profileStr.contains('FAIBLE') || profileStr.contains('NIEDRIG') ||
        profileStr.contains('BASSO') || profileStr.contains('BAIXO') ||
        profileStr.contains('NISKI') || profileStr.contains('NÍZKÝ')) {
      profile = GlycemicProfile.low;
    } else if (profileStr.isNotEmpty) {
      profile = GlycemicProfile.medium;
    } else {
      profile = GlycemicProfile.unknown;
    }

    final rawTips = json['tips'];
    final tips = rawTips is List
        ? rawTips.map((t) => t.toString()).toList()
        : <String>[];

    return MealAiAnalysis(
      glycemicProfile: profile,
      glycemicSummary: json['glycemicSummary'] as String? ?? '',
      insulinTiming: json['insulinTiming'] as String? ?? '',
      insulinTimingMinutes: (json['insulinTimingMinutes'] as num?)?.toInt() ?? 0,
      tips: tips,
      postMealAdvice: json['postMealAdvice'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'glycemicProfile': glycemicProfile.name,
        'glycemicSummary': glycemicSummary,
        'insulinTiming': insulinTiming,
        'insulinTimingMinutes': insulinTimingMinutes,
        'tips': tips,
        'postMealAdvice': postMealAdvice,
      };

  String toJsonString() => jsonEncode(toJson());

  static MealAiAnalysis? tryParseJsonString(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return MealAiAnalysis.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (e) {
      debugPrint('[MealAiAdvisorService] Failed to parse cached analysis: $e');
      return null;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────

/// Analyzes a saved meal entry using Gemini (text only, no image)
/// and returns diabetes-specific dietary advice.
class MealAiAdvisorService {
  static const _languageNames = {
    'cs': 'Czech',
    'de': 'German',
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'it': 'Italian',
    'pl': 'Polish',
    'pt': 'Portuguese',
  };

  /// Call Gemini with the meal data and return structured advice.
  ///
  /// [entry]  The meal entry to analyze.
  /// [locale] Two-letter locale code of the app (e.g. "es", "en").
  static Future<MealAiAnalysis> analyzeMeal(
    MealEntry entry, {
    required String locale,
  }) async {
    final apiKey = await FoodPhotoAnalyzerService.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw const AiServiceException(AiErrorType.noApiKey);
    }

    final langName = _languageNames[locale] ?? 'English';

    // ── Build a readable meal description for the prompt ──
    final mealDesc = _buildMealDescription(entry);

    final systemInstruction =
        'You are a professional clinical dietitian and diabetes educator. '
        'Your role is to analyze the nutritional content of meals logged by people with type 1 or type 2 diabetes '
        'and provide practical, evidence-based dietary advice tailored to glycemic control.\n\n'
        'LANGUAGE: You MUST write ALL response text in $langName. '
        'Only JSON field names remain in English.\n\n'
        'RESPONSE FORMAT: A single JSON object with exactly these fields:\n'
        '1. "glycemicProfile": One of "HIGH", "MEDIUM", or "LOW" — the overall glycemic impact of the meal.\n'
        '2. "glycemicSummary": 1-2 sentences describing the glycemic impact of the meal '
        'based on the carbohydrate content, food types, and glycemic index. '
        'Be specific about which foods contribute the most to the glycemic load.\n'
        '3. "insulinTiming": A clear, practical sentence recommending when to inject rapid-acting insulin '
        'relative to this specific meal (e.g. "Inject 15 minutes before eating" for high-GI meals, '
        '"Inject immediately before or even split the dose" for mixed/uncertain meals). '
        'Consider that high-GI foods require earlier pre-bolus, high-fat meals may need a split or extended bolus.\n'
        '4. "insulinTimingMinutes": An integer. Negative = minutes BEFORE eating (e.g. -15), '
        'positive = minutes AFTER (e.g. 15 for a low-GI meal or fat-heavy meal where you split the dose), '
        '0 = immediately before/at eating time.\n'
        '5. "tips": A JSON array of 2-4 short, actionable tips specific to this meal. '
        'Each tip should be a single sentence. Focus on: glycemic index, fiber impact, '
        'fat/protein effect on glucose absorption, portion adjustments, food combinations that '
        'slow glucose absorption, or practical alternatives.\n'
        '6. "postMealAdvice": One sentence recommending a post-meal action, '
        'such as when to check blood glucose, light physical activity, or a specific monitoring note.\n\n'
        'IMPORTANT RULES:\n'
        '- Base your advice on the actual logged carbohydrate amounts and food items provided.\n'
        '- If insulin was already dosed (bolus data provided), acknowledge it but still give timing advice for future reference.\n'
        '- Keep all tips concise, practical, and encouraging — never alarmist.\n'
        '- Do NOT include any markdown, explanation, or text outside the JSON object.\n'
        '- JSON VALIDITY: The output must be strictly valid JSON. String values (like glycemicSummary) must NOT contain raw, literal line breaks or newlines. If you must use multiple sentences, keep them on a single line separated by spaces. Absolutely no literal newlines inside double quotes.';

    final String text;
    try {
      text = await GeminiRestClient.generateContent(
        apiKey: apiKey,
        models: const ['gemini-2.5-flash'],
        systemInstruction: systemInstruction,
        temperature: 0.2,
        maxOutputTokens: 2048,
        parts: [
          {
            'text': 'Analyze this diabetes meal log and provide dietary advice. '
                'Respond ONLY in $langName with the JSON format specified.\n\n'
                '$mealDesc',
          },
        ],
      );
    } on GeminiBlockedException catch (e) {
      debugPrint('[MealAiAdvisorService] Blocked: $e');
      throw const AiServiceException(AiErrorType.couldNotProcess);
    } on GeminiApiException catch (e) {
      debugPrint('[MealAiAdvisorService] Gemini API error: $e');
      throw AiServiceException(_geminiErrorType(e));
    } on TimeoutException {
      throw const AiServiceException(AiErrorType.timeout);
    } catch (e) {
      debugPrint('[MealAiAdvisorService] Error: $e');
      throw const AiServiceException(AiErrorType.network);
    }

    if (text.isEmpty) {
      throw const AiServiceException(AiErrorType.emptyResponse);
    }

    // Parse JSON
    try {
      var cleaned = text.trim();
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.replaceFirst(RegExp(r'```(?:json)?\s*'), '');
        cleaned = cleaned.replaceFirst(RegExp(r'```\s*$'), '');
      }
      cleaned = sanitizeJsonString(cleaned);
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return MealAiAnalysis.fromJson(json);
    } catch (e) {
      debugPrint('[MealAiAdvisorService] JSON parse error: $e\nRaw: $text');
      throw const AiServiceException(AiErrorType.couldNotProcess);
    }
  }

  /// Build a readable text description of the meal for the prompt.
  static String _buildMealDescription(MealEntry entry) {
    final buf = StringBuffer();
    buf.writeln('Meal type: ${entry.mealType.rawValue}');
    buf.writeln(
        'Timestamp: ${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}');
    buf.writeln('Total carbohydrates: ${entry.totalCarbs.toStringAsFixed(1)}g');
    buf.writeln(
        'Total rations (1 ration = 10g carbs): ${entry.totalRations.toStringAsFixed(1)}');
    if (entry.totalFats != null && entry.totalFats! > 0) {
      buf.writeln('Total fat: ${entry.totalFats!.toStringAsFixed(1)}g');
    }
    if (entry.totalProteins != null && entry.totalProteins! > 0) {
      buf.writeln(
          'Total protein: ${entry.totalProteins!.toStringAsFixed(1)}g');
    }
    if (entry.glucose != null) {
      buf.writeln(
          'Pre-meal blood glucose: ${entry.glucose!.toStringAsFixed(0)} mg/dL');
    }
    if (entry.totalBolus != null) {
      buf.writeln(
          'Insulin bolus administered: ${entry.totalBolus!.toStringAsFixed(1)} units');
    }

    if (entry.items.isNotEmpty) {
      buf.writeln('\nFood items:');
      for (final item in entry.items) {
        buf.write('  - ${item.name}: ${item.grams.toStringAsFixed(0)}g');
        buf.write(' (${item.carbs.toStringAsFixed(1)}g carbs');
        if (item.fats != null && item.fats! > 0) {
          buf.write(', ${item.fats!.toStringAsFixed(1)}g fat');
        }
        if (item.proteins != null && item.proteins! > 0) {
          buf.write(', ${item.proteins!.toStringAsFixed(1)}g protein');
        }
        buf.writeln(')');
      }
    } else {
      buf.writeln('\nNo individual food items logged (totals only).');
    }

    return buf.toString();
  }

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

  /// Replaces raw unescaped newlines inside JSON string fields with spaces.
  /// This prevents FormatException (Unterminated string) when parsing.
  static String sanitizeJsonString(String rawJson) {
    final buffer = StringBuffer();
    bool inString = false;
    bool escaped = false;

    for (int i = 0; i < rawJson.length; i++) {
      final char = rawJson[i];

      if (escaped) {
        buffer.write(char);
        escaped = false;
        continue;
      }

      if (char == '\\') {
        buffer.write(char);
        escaped = true;
        continue;
      }

      if (char == '"') {
        inString = !inString;
        buffer.write(char);
        continue;
      }

      if (inString && (char == '\n' || char == '\r')) {
        // If we see \r followed by \n, skip the \n to avoid double space
        if (char == '\r' && i + 1 < rawJson.length && rawJson[i + 1] == '\n') {
          i++;
        }
        buffer.write(' ');
        continue;
      }

      buffer.write(char);
    }
    return buffer.toString();
  }
}
