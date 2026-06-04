import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String label;

  const AppLoadingIndicator({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: label,
        child: CircularProgressIndicator(color: AppColors.primary(context)),
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(
              child: Icon(icon, size: 64, color: AppColors.hintColor(context))),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyText(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final bool isDark;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimens.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surfaceBg(context),
        borderRadius: BorderRadius.circular(AppDimens.radiusDialog),
        border:
            Border.all(color: color.withValues(alpha: isDark ? 0.3 : 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Semantics(
        label: '$title: $value',
        child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary(context),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      ),
    );
  }
}

