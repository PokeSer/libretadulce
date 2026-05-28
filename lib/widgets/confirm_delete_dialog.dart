import 'package:flutter/material.dart';
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
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.confirmDeleteCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
          child: Text(l10n.confirmDeleteButton),
        ),
      ],
    ),
  );
  return result ?? false;
}
