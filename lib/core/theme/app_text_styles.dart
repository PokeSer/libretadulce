import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// El paisaje de la glucemia — type system.
///
/// Schibsted Grotesk carries UI and headings; Spline Sans Mono carries every
/// measured value: grams, rations, units, timestamps, mg/dL. The mono is the
/// instrument voice; it is never a costume for prose.
abstract final class AppTextStyles {
  AppTextStyles._();

  static const cardTitle = TextStyle(fontWeight: FontWeight.w600, fontSize: 15);
  static const appBarTitle = TextStyle(fontWeight: FontWeight.w700);
  static const sectionTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  /// Small tracked label above instrument readouts.
  static TextStyle readoutLabel(BuildContext context) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.textSecondary(context),
  );

  /// Large magnified value inside a dose window or stat panel.
  static TextStyle readoutValue(BuildContext context, {Color? color}) =>
      GoogleFonts.splineSansMono(
        fontSize: 30,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color ?? AppColors.textBody(context),
      );

  /// Hero-scale numeric moment (calculator result, bolus total).
  static TextStyle doseValue(BuildContext context, {Color? color}) =>
      GoogleFonts.splineSansMono(
        fontSize: 52,
        height: 1.05,
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color ?? AppColors.textHeading(context),
      );

  /// Any inline measured value: grams in a row, mg/dL badge, unit totals.
  static TextStyle metric(BuildContext context, {Color? color, double size = 15}) =>
      GoogleFonts.splineSansMono(
        fontSize: size,
        fontWeight: FontWeight.w500,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color ?? AppColors.textBody(context),
      );

  static TextStyle cardSubtitle(BuildContext context) =>
      TextStyle(fontSize: 13, color: AppColors.textSecondary(context));

  static TextStyle bodyText(BuildContext context) =>
      TextStyle(color: AppColors.textSecondary(context), fontSize: 16);
}
