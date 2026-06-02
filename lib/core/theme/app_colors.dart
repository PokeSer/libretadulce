import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // ── Primary palette ──────────────────────────────────────────────
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;

  static Color primaryLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A3A36)
          : const Color(0xFFE0F2F1);

  static Color primaryDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF4DB6AC)
          : const Color(0xFF00695C);

  // ── Semantic colors ──────────────────────────────────────────────
  static Color error(BuildContext context) =>
      Theme.of(context).colorScheme.error;

  static Color onError(BuildContext context) =>
      Theme.of(context).colorScheme.onError;

  static Color warning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFFB74D)
          : const Color(0xFFE65100);

  static Color warningLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3A2A00)
          : const Color(0xFFFFF3E0);

  static Color success(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF81C784)
          : const Color(0xFF2E7D32);

  static Color insulinGreen(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF8BC34A)
          : const Color(0xFF689F38);

  // ── Surfaces ─────────────────────────────────────────────────────
  static Color scaffoldBg(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color cardBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  static Color surfaceBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHigh;

  static Color surfaceAlt(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  static Color headerBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;

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

  // ── Borders ──────────────────────────────────────────────────────
  static Color borderSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  // ── Accent ───────────────────────────────────────────────────────
  static Color accentFavorite(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;
}
