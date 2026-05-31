import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  static const insulinGreen = Color(0xFF689F38);

  static Color cardBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  static Color surfaceBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHigh;

  static Color surfaceAlt(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

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

  static Color borderSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.outline;

  static Color hintColor(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color accentFavorite(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;

  static Color scaffoldBg(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color headerBg(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;
}
