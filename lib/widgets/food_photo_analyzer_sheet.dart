import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';
import '../models/insulin_settings.dart';
import '../pages/settings_page.dart';
import '../services/food_photo_analyzer_service.dart';
import '../services/insulin_settings_service.dart';

/// Result returned when the user confirms a food item from photo analysis.
class PhotoAnalysisResult {
  final String name;
  final double grams;
  final double carbsPer100g;
  final double? fatsPer100g;
  final double? proteinsPer100g;
  final double? fiberPer100g;
  final double? kcalPer100g;
  final String? glycemicIndex;

  const PhotoAnalysisResult({
    required this.name,
    required this.grams,
    required this.carbsPer100g,
    this.fatsPer100g,
    this.proteinsPer100g,
    this.fiberPer100g,
    this.kcalPer100g,
    this.glycemicIndex,
  });
}

/// Callback invoked when user adds a food item to their plate.
/// Does NOT close the sheet — the sheet stays open for multiple additions.
typedef OnAddFoodToPlate = void Function(PhotoAnalysisResult result);

/// Bottom sheet: take photo → Gemini analyzes → professional result table.
class FoodPhotoAnalyzerSheet extends StatefulWidget {
  /// Optional callback: when provided, tapping "Add to plate" calls this
  /// instead of popping the sheet, allowing the user to add multiple foods.
  final OnAddFoodToPlate? onAddToPlate;

  const FoodPhotoAnalyzerSheet({super.key, this.onAddToPlate});

  @override
  State<FoodPhotoAnalyzerSheet> createState() => _FoodPhotoAnalyzerSheetState();
}

class _FoodPhotoAnalyzerSheetState extends State<FoodPhotoAnalyzerSheet> {
  final ImagePicker _picker = ImagePicker();
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isAnalyzing = false;
  bool _needsApiKey = false;
  String? _errorMessage;
  GeminiAnalysisResult? _analysis;
  InsulinSettings? _insulinSettings;
  final Set<String> _addedItems = {};

  @override
  void initState() {
    super.initState();
    _checkApiKey();
    _loadInsulinSettings();
  }

  Future<void> _loadInsulinSettings() async {
    if (_user == null) return;
    final settings = await InsulinSettingsService.getSettings(_user.uid);
    if (mounted) {
      setState(() {
        _insulinSettings = settings;
      });
    }
  }

  Future<void> _checkApiKey() async {
    final key = await FoodPhotoAnalyzerService.getApiKey();
    if (mounted) {
      setState(() => _needsApiKey = key == null || key.isEmpty);
    }
  }

  Future<void> _takePhoto() async {
    await _pickImage(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    // Show photo tip on first use (unless permanently dismissed)
    if (mounted) {
      final dismissed = await FoodPhotoAnalyzerService.isPhotoTipDismissed();
      if (!dismissed) {
        final proceed = await _showPhotoTip();
        if (!proceed) return;
      }
    }

    // Check privacy
    final privacyAccepted = await FoodPhotoAnalyzerService.hasAcceptedPrivacy();
    if (!privacyAccepted && mounted) {
      final accepted = await _showPrivacyDialog();
      if (!accepted) return;
      await FoodPhotoAnalyzerService.acceptPrivacy();
    }

    if (!mounted) return;
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (photo == null || !mounted) return;

      setState(() {
        _isAnalyzing = true;
        _errorMessage = null;
        _analysis = null;
      });

      final result = await FoodPhotoAnalyzerService.analyze(
        File(photo.path),
        locale: Localizations.localeOf(context).languageCode,
      );

      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _analysis = result;
      });
    } catch (e) {
      debugPrint('[FoodPhotoAnalyzerSheet] Error: $e');
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    }
  }

  Future<bool> _showPhotoTip() async {
    final l10n = AppLocalizations.of(context);
    var dontShow = false;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const ExcludeSemantics(
                child: Icon(Icons.tips_and_updates, color: Colors.teal),
              ),
              const SizedBox(width: 8),
              Flexible(child: Text(l10n.photoTipTitle)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.photoTipBody, style: const TextStyle(height: 1.4)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.checklist, color: Colors.teal, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.photoTipChecklist,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: dontShow,
                      onChanged: (v) =>
                          setDialogState(() => dontShow = v ?? false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: MergeSemantics(
                      child: InkWell(
                        onTap: () => setDialogState(() => dontShow = !dontShow),
                        borderRadius: BorderRadius.circular(4),
                        child: Text(
                          l10n.photoTipDontShowAgain,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              autofocus: true,
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.photoTipCancel),
            ),
            FilledButton(
              onPressed: () {
                if (dontShow) {
                  FoodPhotoAnalyzerService.dismissPhotoTip();
                }
                Navigator.pop(ctx, true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.teal),
              child: Text(l10n.photoTipContinue),
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  Future<bool> _showPrivacyDialog() async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.photoPrivacyTitle),
        content: Text(l10n.photoPrivacyText),
        actions: [
          TextButton(
            autofocus: true,
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.photoPrivacyCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.teal),
            child: Text(l10n.photoPrivacyAccept),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _addToPlate(GeminiFoodItem item) {
    final result = PhotoAnalysisResult(
      name: item.name,
      grams: item.grams,
      carbsPer100g: item.carbsPer100g,
      fatsPer100g: item.fatsPer100g,
      proteinsPer100g: item.proteinsPer100g,
      fiberPer100g: item.fiberPer100g,
      kcalPer100g: item.kcalPer100g,
      glycemicIndex: item.glycemicIndex,
    );

    if (widget.onAddToPlate != null) {
      // Callback mode: stay open so user can add multiple foods
      widget.onAddToPlate!(result);
      setState(() => _addedItems.add(item.name));
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.globalAddedToMyFoods(item.name)),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Legacy mode: pop with single result (backwards compatible)
      Navigator.pop(context, result);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 8,
                top: 16,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.photoTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(child: _buildContent(l10n, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n, bool isDark) {
    if (_needsApiKey) return _buildApiKeyMissing(l10n, isDark);
    if (_isAnalyzing) return _buildAnalyzing(l10n, isDark);
    if (_errorMessage != null) return _buildError(l10n, isDark);
    if (_analysis != null) return _buildResults(l10n, isDark);
    return _buildEmpty(l10n, isDark);
  }

  Widget _buildApiKeyMissing(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(
              child: Icon(Icons.key, size: 64, color: Colors.orange),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.photoApiKeyMissing,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
              icon: const Icon(Icons.settings),
              label: Text(l10n.photoConfigureKey),
              style: FilledButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzing(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Semantics(
            label: l10n.photoAnalyzing,
            child: const CircularProgressIndicator(color: Colors.teal),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.photoAnalyzing,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.photoAnalyzingHint,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ExcludeSemantics(
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: Text(l10n.photoRetry),
              style: FilledButton.styleFrom(backgroundColor: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations l10n, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ExcludeSemantics(
            child: Icon(Icons.restaurant, size: 64, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.photoEmptyHint,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.photoEmptySubtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Semantics(
            button: true,
            label: l10n.photoTakeButton,
            child: FilledButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: Text(l10n.photoTakeButton),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Semantics(
            button: true,
            label: l10n.photoGalleryButton,
            child: OutlinedButton.icon(
              onPressed: _pickFromGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(l10n.photoGalleryButton),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.teal,
                side: const BorderSide(color: Colors.teal),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(AppLocalizations l10n, bool isDark) {
    final analysis = _analysis!;
    final items = analysis.items;

    // Calculate totals
    double totalCarbs = 0;
    double totalKcal = 0;
    double totalRations = 0;
    for (final item in items) {
      final carbs = item.grams * item.carbsPer100g / 100;
      totalCarbs += carbs;
      totalRations += carbs / 10.0;
      if (item.kcalPer100g != null) {
        totalKcal += item.grams * item.kcalPer100g! / 100;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          // --- Summary card ---
          if (analysis.summary.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.teal,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      analysis.summary,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark
                            ? Colors.grey.shade200
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // --- Food cards ---
          Text(
            l10n.photoResultsTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 10),
          ...items.asMap().entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildFoodCard(e.value, l10n, isDark),
            ),
          ),

          // --- Totals row ---
          const SizedBox(height: 4),
          _buildTotalsRow(totalCarbs, totalRations, totalKcal, l10n, isDark),

          // --- AI Notes (separate from disclaimer) ---
          if (analysis.notes.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildAiNotesCard(analysis.notes, l10n, isDark),
          ],

          if (_insulinSettings != null) ...[
            const SizedBox(height: 16),
            _buildBolusCard(totalCarbs, l10n, isDark),
          ],

          const SizedBox(height: 16),

          // --- Disclaimer (no notes here anymore) ---
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: isDark ? 0.08 : 0.06),
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.photoDisclaimerTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.photoDisclaimerText,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- Add all button ---
          if (items.length > 1 && widget.onAddToPlate != null) ...[
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final allAdded = items.every(
                  (i) => _addedItems.contains(i.name),
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Semantics(
                    button: true,
                    label: l10n.photoAddAllToPlate,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: allAdded
                            ? null
                            : () {
                                for (final item in items) {
                                  if (!_addedItems.contains(item.name)) {
                                    _addToPlate(item);
                                  }
                                }
                              },
                        icon: Icon(
                          allAdded ? Icons.check_circle : Icons.playlist_add,
                          size: 20,
                        ),
                        label: Text(
                          allAdded
                              ? l10n.photoAllAdded
                              : l10n.photoAddAllToPlate,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.teal,
                          disabledBackgroundColor: Colors.green.withValues(
                            alpha: 0.15,
                          ),
                          disabledForegroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusCard,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.photoRetry),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Builds a professional food card with macro grid & glycemic index badge.
  Widget _buildFoodCard(
    GeminiFoodItem item,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final cardBg = isDark ? Colors.grey.shade900 : Colors.grey.shade50;
    final textColor = isDark ? Colors.grey.shade200 : Colors.grey.shade900;
    final mutedColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;
    final gi = item.glycemicIndex;

    final carbsServing = item.grams * item.carbsPer100g / 100;
    final rations = carbsServing / 10.0;
    final proteinsServing = item.proteinsPer100g != null
        ? item.grams * item.proteinsPer100g! / 100
        : null;
    final fatsServing = item.fatsPer100g != null
        ? item.grams * item.fatsPer100g! / 100
        : null;
    final fiberServing = item.fiberPer100g != null
        ? item.grams * item.fiberPer100g! / 100
        : null;
    final kcalServing = item.kcalPer100g != null
        ? item.grams * item.kcalPer100g! / 100
        : null;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Card header: name + GI badge + grams ---
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${l10n.photoTableGrams}: ${item.grams.toStringAsFixed(0)}g',
                        style: TextStyle(fontSize: 12, color: mutedColor),
                      ),
                    ],
                  ),
                ),
                if (gi != null) _buildGiBadge(gi),
              ],
            ),
          ),

          // --- Divider ---
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),

          // --- Macro grid ---
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carbs row (always shown, most important for diabetes)
                _buildMacroRow(
                  l10n.photoTableCarbs,
                  '${carbsServing.toStringAsFixed(1)}g',
                  Icons.grain,
                  Colors.teal,
                  subtitle:
                      '${rations.toStringAsFixed(1)} ${l10n.photoTableRations}',
                  isDark: isDark,
                ),
                const SizedBox(height: 10),
                // Second row: macros grid — always 4 equal columns
                Row(
                  children: [
                    Expanded(
                      child: _buildMacroChip(
                        l10n.photoTableProtein,
                        proteinsServing != null
                            ? '${proteinsServing.toStringAsFixed(0)}g'
                            : '–',
                        Colors.blue,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildMacroChip(
                        l10n.photoTableFat,
                        fatsServing != null
                            ? '${fatsServing.toStringAsFixed(0)}g'
                            : '–',
                        Colors.amber,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildMacroChip(
                        l10n.photoTableFiber,
                        fiberServing != null
                            ? '${fiberServing.toStringAsFixed(0)}g'
                            : '–',
                        Colors.green,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildMacroChip(
                        l10n.foodsKcalLabel,
                        kcalServing != null
                            ? kcalServing.toStringAsFixed(0)
                            : '–',
                        Colors.deepOrange,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Add to plate button ---
          Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
          if (_addedItems.contains(item.name))
            // Already added — show checkmark
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    l10n.photoAddedToPlate,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            Semantics(
              button: true,
              label: l10n.photoAddToPlate(item.name),
              child: InkWell(
                onTap: () => _addToPlate(item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: Colors.teal,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.photoAddToPlate(item.name),
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Compact macro chip (used inside the food card).
  Widget _buildMacroChip(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Carbs macro row (larger, with rations subtitle).
  Widget _buildMacroRow(
    String label,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: color,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Builds a colored glycemic index badge.
  Widget _buildGiBadge(String gi) {
    final color = _giColor(gi);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            gi == 'Alto'
                ? Icons.trending_up
                : gi == 'Medio'
                ? Icons.trending_flat
                : Icons.trending_down,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            'IG $gi',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _giColor(String gi) {
    switch (gi.toLowerCase()) {
      case 'bajo':
      case 'low':
        return Colors.green;
      case 'medio':
      case 'medium':
        return Colors.orange;
      case 'alto':
      case 'high':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  /// Totals summary row.
  Widget _buildTotalsRow(
    double totalCarbs,
    double totalRations,
    double totalKcal,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.grey.shade200 : Colors.grey.shade800;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: isDark ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: Colors.teal.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.summarize, color: Colors.teal, size: 18),
          const SizedBox(width: 10),
          Text(
            l10n.photoTableTotal,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${totalCarbs.toStringAsFixed(1)}g HC',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.teal,
                ),
              ),
              Text(
                '${totalRations.toStringAsFixed(1)} ${l10n.photoTableRations}',
                style: TextStyle(fontSize: 12, color: Colors.teal.shade700),
              ),
              if (totalKcal > 0)
                Text(
                  '${totalKcal.toStringAsFixed(0)} kcal',
                  style: TextStyle(fontSize: 11, color: Colors.teal.shade600),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// AI-generated notes box — professional, not a warning.
  Widget _buildAiNotesCard(String notes, AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: isDark ? 0.08 : 0.04),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Colors.indigo,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.photoAiNotesTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notes,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBolusCard(
    double totalCarbs,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final settings = _insulinSettings!;
    final bolus = settings.calculateMealBolus(totalCarbs);
    final rounded = settings.roundBolus(bolus);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.water_drop, color: Colors.redAccent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.photoBolusTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.photoBolusEstimation(
                    settings.formatBolus(rounded),
                    totalCarbs.toStringAsFixed(1),
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? Colors.grey.shade200 : Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.photoBolusReminder,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
