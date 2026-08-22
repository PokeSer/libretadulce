import 'package:flutter/material.dart';

/// El paisaje de la glucemia — token system.
///
/// The ink canvas carries the surface; the curve green is the working color;
/// every glucose hue means something measurable: in-range green, low amber,
/// high red. Neutral grays are tinted toward the curve hue, never pure gray.
abstract final class AppColors {
  AppColors._();

  // ── Primary palette ──────────────────────────────────────────────
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;

  static Color primaryLight(BuildContext context) =>
      Theme.of(context).colorScheme.primaryContainer;

  static Color primaryDark(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  /// The continuous stroke that draws the glucose landscape.
  static Color curveStroke(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF43CE85)
          : const Color(0xFF177A45);

  /// Translucent wash for range bands and chart backdrops.
  static Color curveWash(BuildContext context) => curveStroke(
      context,
    ).withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.14 : 0.10);

  // ── Glucose semantics (clinical coding, kept from product truth) ──
  /// Reading below 70 mg/dL — caution.
  static Color glucoseLow(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFF2B33D)
          : const Color(0xFF9A6500);

  /// Reading above 180 mg/dL — attention.
  static Color glucoseHigh(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFF8A84)
          : const Color(0xFFBF3B32);

  /// Reading between 70–180 mg/dL.
  static Color glucoseInRange(BuildContext context) => curveStroke(context);

  /// Resolves a stored mg/dL reading into its range hue.
  static Color glucoseRange(BuildContext context, double mgdl) {
    if (mgdl < 70) return glucoseLow(context);
    if (mgdl > 180) return glucoseHigh(context);
    return glucoseInRange(context);
  }

  // ── Semantic colors ──────────────────────────────────────────────
  static Color error(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  static Color onError(BuildContext context) =>
      Theme.of(context).colorScheme.onError;

  static Color warning(BuildContext context) => glucoseLow(context);

  static Color warningLight(BuildContext context) => glucoseLow(
    context,
  ).withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.16 : 0.12);

  static Color success(BuildContext context) => glucoseInRange(context);

  static Color insulinGreen(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF9CC5B0)
          : const Color(0xFF4C6357);

  // ── Surfaces ─────────────────────────────────────────────────────
  static Color scaffoldBg(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color cardBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLow;

  static Color surfaceBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;

  static Color surfaceAlt(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHigh;

  static Color headerBg(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  // ── Text ─────────────────────────────────────────────────────────
  static Color textBody(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color textHeading(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color textMuted(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color accentText(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color hintColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  // ── Borders & hairlines ──────────────────────────────────────────
  static Color borderSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  /// The quiet hairline that separates panels on the ink canvas.
  static Color hairline(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;

  // ── Accent ───────────────────────────────────────────────────────
  static Color accentFavorite(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;
}
