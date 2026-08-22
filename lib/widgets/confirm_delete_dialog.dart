import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';

Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  String? title,
  required String content,
}) async {
  final l10n = AppLocalizations.of(context);
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title ?? l10n.confirmDeleteTitle),
      content: Text(content),
      actions: [
        TextButton(
          autofocus: true,
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.confirmDeleteCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error(ctx),
          ),
          child: Text(l10n.confirmDeleteButton),
        ),
      ],
    ),
  );
  return result ?? false;
}
