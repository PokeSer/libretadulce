import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:libretadulce/services/meal_ai_advisor_service.dart';

void main() {
  group('MealAiAnalysis', () {
    test('fromJson parses correctly with standard fields', () {
      final jsonMap = {
        'glycemicProfile': 'HIGH',
        'glycemicSummary': 'High glycemic impact.',
        'insulinTiming': 'Inject 15 minutes before.',
        'insulinTimingMinutes': -15,
        'tips': ['Tip 1', 'Tip 2'],
        'postMealAdvice': 'Check glucose in 2h.'
      };

      final analysis = MealAiAnalysis.fromJson(jsonMap);

      expect(analysis.glycemicProfile, GlycemicProfile.high);
      expect(analysis.glycemicSummary, 'High glycemic impact.');
      expect(analysis.insulinTiming, 'Inject 15 minutes before.');
      expect(analysis.insulinTimingMinutes, -15);
      expect(analysis.tips, ['Tip 1', 'Tip 2']);
      expect(analysis.postMealAdvice, 'Check glucose in 2h.');
    });

    test('fromJson handles different glycemic profile strings case insensitively', () {
      final lowMap = {'glycemicProfile': 'bajo'};
      final mediumMap = {'glycemicProfile': 'Medium'};
      final unknownMap = {'glycemicProfile': 'UNKNOWN_TYPE'};

      expect(MealAiAnalysis.fromJson(lowMap).glycemicProfile, GlycemicProfile.low);
      expect(MealAiAnalysis.fromJson(mediumMap).glycemicProfile, GlycemicProfile.medium);
      expect(MealAiAnalysis.fromJson(unknownMap).glycemicProfile, GlycemicProfile.medium);
    });

    test('toJson and toJsonString round-trip successfully', () {
      const original = MealAiAnalysis(
        glycemicProfile: GlycemicProfile.low,
        glycemicSummary: 'Low impact.',
        insulinTiming: 'Inject at meal start.',
        insulinTimingMinutes: 0,
        tips: ['Eat fiber first.'],
        postMealAdvice: 'Walk for 15 mins.'
      );

      final jsonStr = original.toJsonString();
      final parsed = MealAiAnalysis.tryParseJsonString(jsonStr);

      expect(parsed, isNotNull);
      expect(parsed!.glycemicProfile, original.glycemicProfile);
      expect(parsed.glycemicSummary, original.glycemicSummary);
      expect(parsed.insulinTiming, original.insulinTiming);
      expect(parsed.insulinTimingMinutes, original.insulinTimingMinutes);
      expect(parsed.tips, original.tips);
      expect(parsed.postMealAdvice, original.postMealAdvice);
    });
  });

  group('MealAiAdvisorService JSON Sanitization', () {
    test('sanitizeJsonString replaces literal newlines inside double quotes', () {
      const rawInput = '''{
  "glycemicProfile": "HIGH",
  "glycemicSummary": "Esta comida tiene un impacto glucémico alto debido
a los carbohidratos de rápida absorción.",
  "insulinTiming": "Inject 15 minutes
before eating."
}''';

      final sanitized = MealAiAdvisorService.sanitizeJsonString(rawInput);
      
      // Let's decode it to ensure it is valid JSON now.
      final parsed = jsonDecode(sanitized) as Map<String, dynamic>;
      
      expect(parsed['glycemicProfile'], 'HIGH');
      expect(parsed['glycemicSummary'], 'Esta comida tiene un impacto glucémico alto debido a los carbohidratos de rápida absorción.');
      expect(parsed['insulinTiming'], 'Inject 15 minutes before eating.');
    });

    test('sanitizeJsonString preserves escaped newlines', () {
      // In JSON, an escaped newline is \n (two characters: backslash + n).
      // In Dart, we write this as \\n.
      const rawInput = '{\n'
          '  "glycemicSummary": "Line 1\\nLine 2"\n'
          '}';

      final sanitized = MealAiAdvisorService.sanitizeJsonString(rawInput);
      final parsed = jsonDecode(sanitized) as Map<String, dynamic>;
      expect(parsed['glycemicSummary'], 'Line 1\nLine 2');
    });
  });
}
