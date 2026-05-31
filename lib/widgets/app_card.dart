import 'package:flutter/material.dart';
import '../core/theme/app_dimens.dart';

/// Card con elevation 0 y color adaptativo dark/light.
///
/// ANTES:
/// ```dart
/// Card(
///   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
///   color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
///   elevation: 0,
///   child: ...
/// )
/// ```
///
/// AHORA:
/// ```dart
/// AppCard(child: ...)
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.borderRadius = AppDimens.radiusCard,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: child,
    );
  }
}
