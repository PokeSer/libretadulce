import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../models/food.dart';

/// Alert dialog showing nutrition details for a food.
class FoodDetailDialog extends StatelessWidget {
  final Food food;
  const FoodDetailDialog({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusDialog)),
      title: Row(children: [
        ExcludeSemantics(child: Container(padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AppColors.primary(context).withValues(alpha: isDark ? 0.15 : 0.1), shape: BoxShape.circle),
          child: Icon(Icons.restaurant, color: AppColors.primary(context), size: 22))),
        const SizedBox(width: 12),
        Expanded(child: Text(food.displayName, style: const TextStyle(fontSize: 18))),
      ]),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Nutrition', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textSecondary(context), letterSpacing: 0.5)),
        const SizedBox(height: 16),
        _nutritionRow(Icons.grain, AppColors.primary(context), '${food.carbsPer100g}g carbs / 100g', isDark),
        if (food.kcalPer100g != null) ...[const SizedBox(height: 10), _nutritionRow(Icons.local_fire_department, Colors.deepOrange, '${food.kcalPer100g} kcal', isDark)],
        if (food.proteinsPer100g != null) ...[const SizedBox(height: 10), _nutritionRow(Icons.fitness_center, Colors.indigo, '${food.proteinsPer100g}g protein', isDark)],
        if (food.fatsPer100g != null) ...[const SizedBox(height: 10), _nutritionRow(Icons.water_drop, Colors.amber.shade700, '${food.fatsPer100g}g fat', isDark)],
      ]),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Close', style: TextStyle(color: AppColors.primary(context))))],
    );
  }

  static Widget _nutritionRow(IconData icon, Color color, String label, bool isDark) {
    return Semantics(label: label, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: color.withValues(alpha: isDark ? 0.12 : 0.07), borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
      child: Row(children: [
        ExcludeSemantics(child: Icon(icon, color: color, size: 20)), const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDark ? color.withValues(alpha: 0.9) : color.withValues(alpha: 0.85)))),
      ]),
    ));
  }
}
