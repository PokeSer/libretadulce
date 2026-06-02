import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  static const cardTitle = TextStyle(fontWeight: FontWeight.w600, fontSize: 15);
  static const appBarTitle = TextStyle(fontWeight: FontWeight.bold);
  static const sectionTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  static TextStyle cardSubtitle(BuildContext context) =>
      TextStyle(fontSize: 13, color: AppColors.textSecondary(context));

  static TextStyle bodyText(BuildContext context) =>
      TextStyle(color: AppColors.textSecondary(context), fontSize: 16);
}
