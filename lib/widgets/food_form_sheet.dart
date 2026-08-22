import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/utils/formatters.dart';
import '../l10n/app_localizations.dart';
import '../models/food.dart';
import '../services/food_photo_service.dart';

/// Bottom sheet for adding or editing a food.
/// [initial] is null for add mode, non-null for edit mode.
///
/// Photos stay on the device: [onSave] returns the saved document id and the
/// sheet stores the picked image locally under it (see [FoodPhotoService]).
class FoodFormSheet extends StatefulWidget {
  final Food? initial;
  final String uid;
  final Future<String?> Function(Food food) onSave;
  final Future<void> Function(
    TextEditingController nameCtrl,
    TextEditingController brandCtrl,
    TextEditingController carbsCtrl,
    TextEditingController kcalCtrl,
    TextEditingController proteinsCtrl,
    TextEditingController fatsCtrl,
  )? onScanTap;

  const FoodFormSheet({
    super.key,
    this.initial,
    required this.uid,
    required this.onSave,
    this.onScanTap,
  });

  @override
  State<FoodFormSheet> createState() => _FoodFormSheetState();
}

class _FoodFormSheetState extends State<FoodFormSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _carbsController;
  late final TextEditingController _kcalController;
  late final TextEditingController _proteinsController;
  late final TextEditingController _fatsController;

  XFile? _pickedPhoto;
  File? _existingPhoto;
  bool _photoRemoved = false;
  bool _isSaving = false;

  bool get _isEditMode => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final food = widget.initial;
    _nameController = TextEditingController(text: food?.name ?? '');
    _brandController = TextEditingController(text: food?.brand ?? '');
    _carbsController = TextEditingController(
      text: food != null ? food.carbsPer100g.toStringAsFixed(1) : '',
    );
    _kcalController = TextEditingController(
      text: food?.kcalPer100g?.toStringAsFixed(0) ?? '',
    );
    _proteinsController = TextEditingController(
      text: food?.proteinsPer100g?.toStringAsFixed(1) ?? '',
    );
    _fatsController = TextEditingController(
      text: food?.fatsPer100g?.toStringAsFixed(1) ?? '',
    );
    if (food != null) {
      FoodPhotoService.getPhoto(food.id)
          .then((file) => mounted ? setState(() => _existingPhoto = file) : null);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _carbsController.dispose();
    _kcalController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final l10n = AppLocalizations.of(context);
    try {
      final picked = await FoodPhotoService.picker.pickImage(
        source: source,
        imageQuality: FoodPhotoService.pickImageQuality,
        maxWidth: FoodPhotoService.pickMaxDimension,
      );
      if (picked == null) return;
      setState(() {
        _pickedPhoto = picked;
        _existingPhoto = null;
        _photoRemoved = false;
      });
    } catch (e) {
      debugPrint('[FoodFormSheet._pickPhoto] Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.serviceError)),
        );
      }
    }
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.foodsNameRequired)),
      );
      return;
    }
    if (_carbsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.foodsCarbsRequired)),
      );
      return;
    }

    final carbs = parseSpanishDecimal(_carbsController.text);
    final kcal = parseSpanishDecimal(_kcalController.text);
    final proteins = parseSpanishDecimal(_proteinsController.text);
    final fats = parseSpanishDecimal(_fatsController.text);

    if (carbs == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.foodsCarbsInvalid)),
      );
      return;
    }

    final food = Food(
      id: widget.initial?.id ?? '',
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      carbsPer100g: carbs,
      kcalPer100g: kcal,
      proteinsPer100g: proteins,
      fatsPer100g: fats,
    );

    setState(() => _isSaving = true);
    String? savedId;
    try {
      savedId = await widget.onSave(food);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }

    if (savedId == null || savedId.isEmpty) return;

    if (_photoRemoved) {
      await FoodPhotoService.deleteAll(widget.uid, savedId);
      return;
    }

    final picked = _pickedPhoto;
    if (picked != null) {
      final savedFile = await FoodPhotoService.savePhoto(savedId, picked);
      if (savedFile != null) {
        // Mirror a tiny thumb so other devices see the photo too. A failed
        // mirror never fails the save: the full photo is already local.
        final thumbBytes = await FoodPhotoService.generateThumbBytes(savedFile);
        if (thumbBytes != null) {
          await FoodPhotoService.saveLocalThumb(savedId, thumbBytes);
          if (await FoodPhotoService.uploadThumb(widget.uid, savedId, thumbBytes)) {
            await FoodPhotoService.markSynced(savedId);
          }
        }
      }
      FoodPhotoService.forget(widget.uid, savedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isEditMode ? l10n.foodsDetailTitle : l10n.foodsAddTitle,
            style: TextStyle(color: AppColors.primary(context)),
          ),
          if (widget.onScanTap != null)
            IconButton(
              icon: Icon(Icons.qr_code_scanner, color: AppColors.primary(context)),
              tooltip: l10n.foodsScanTooltip,
              onPressed: () => widget.onScanTap?.call(
                _nameController,
                _brandController,
                _carbsController,
                _kcalController,
                _proteinsController,
                _fatsController,
              ),
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPhotoSection(l10n),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(
                labelText: l10n.foodsNameLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.apple),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _brandController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: l10n.foodsBrandLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.storefront),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _carbsController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.foodsCarbsLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.scale),
                suffixText: l10n.foodsCarbsSuffix,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _kcalController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.foodsKcalLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _proteinsController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.foodsProteinLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _fatsController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: l10n.foodsFatLabel,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.foodsCancel,
            style: TextStyle(color: AppColors.textMuted(context)),
          ),
        ),
        FilledButton(
          onPressed: _isSaving ? null : () async {
            await _handleSave();
            if (context.mounted) Navigator.pop(context);
          },
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  l10n.foodsSave,
                  style: TextStyle(color: AppColors.onPrimary(context)),
                ),
        ),
      ],
    );
  }

  /// Photo section: preview + camera/gallery actions, all ≥48 dp targets
  /// with labels announced to screen readers.
  Widget _buildPhotoSection(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    final hasPhoto = _pickedPhoto != null || _existingPhoto != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Semantics(
          label: hasPhoto ? l10n.foodsPhotoRemove : l10n.foodsPhotoAdd,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppDimens.radiusInput),
              border: Border.all(color: AppColors.hairline(context)),
            ),
            child: _buildPreview(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pickPhoto(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_outlined, size: 20),
                label: Text(l10n.foodsPhotoCamera),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  foregroundColor: AppColors.primary(context),
                  side: BorderSide(
                    color: AppColors.primary(context).withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _pickPhoto(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined, size: 20),
                label: Text(l10n.foodsPhotoGallery),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  foregroundColor: AppColors.primary(context),
                  side: BorderSide(
                    color: AppColors.primary(context).withValues(alpha: 0.5),
                  ),
                ),
              ),
              if (hasPhoto) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => setState(() {
                    _pickedPhoto = null;
                    _existingPhoto = null;
                    _photoRemoved = true;
                  }),
                  icon: Icon(Icons.delete_outline,
                      size: 18, color: AppColors.error(context)),
                  label: Text(
                    l10n.foodsPhotoRemove,
                    style: TextStyle(color: AppColors.error(context)),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(36),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    if (_pickedPhoto != null) {
      return ExcludeSemantics(
        child: Image.file(
          File(_pickedPhoto!.path),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          gaplessPlayback: true,
        ),
      );
    }
    if (_existingPhoto != null) {
      return ExcludeSemantics(
        child: Image.file(
          _existingPhoto!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          gaplessPlayback: true,
        ),
      );
    }
    return ExcludeSemantics(
      child: Icon(
        Icons.add_a_photo_outlined,
        size: 30,
        color: AppColors.textMuted(context),
      ),
    );
  }
}
