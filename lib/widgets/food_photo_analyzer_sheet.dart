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

  const PhotoAnalysisResult({
    required this.name,
    required this.grams,
    required this.carbsPer100g,
    this.fatsPer100g,
    this.proteinsPer100g,
  });
}

/// Bottom sheet: take photo → Gemini analyzes → professional result table.
class FoodPhotoAnalyzerSheet extends StatefulWidget {
  const FoodPhotoAnalyzerSheet({super.key});

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
    Navigator.pop(
      context,
      PhotoAnalysisResult(
        name: item.name,
        grams: item.grams,
        carbsPer100g: item.carbsPer100g,
        fatsPer100g: item.fatsPer100g,
        proteinsPer100g: item.proteinsPer100g,
      ),
    );
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

          // --- Nutritional table ---
          _buildTableHeader(l10n, isDark),
          const SizedBox(height: 8),
          ...items.asMap().entries.map(
            (e) => _buildTableRow(e.value, l10n, isDark),
          ),
          const Divider(height: 24),
          _buildTableTotal(totalCarbs, totalRations, totalKcal, l10n, isDark),

          if (_insulinSettings != null) ...[
            const SizedBox(height: 16),
            _buildBolusCard(totalCarbs, l10n, isDark),
          ],

          const SizedBox(height: 16),

          // --- Notes / disclaimer ---
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
                if (analysis.notes.isNotEmpty)
                  Text(
                    analysis.notes,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                  ),
                const SizedBox(height: 4),
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

          // --- Action buttons: add individual foods ---
          Text(
            l10n.photoAddFoodsTitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Semantics(
                button: true,
                label: l10n.photoAddToPlate(item.name),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _addToPlate(item),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.teal,
                      size: 20,
                    ),
                    label: Text(
                      '${item.name} (${item.grams.toStringAsFixed(0)}g)',
                      style: const TextStyle(color: Colors.teal),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.teal.withValues(alpha: 0.4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusCard,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

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

  Widget _buildTableHeader(AppLocalizations l10n, bool isDark) {
    final textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade700;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(
              l10n.photoTableFood,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: textColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.photoTableGrams,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.photoTableCarbs,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.photoTableRations,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              l10n.photoTableGI,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    GeminiFoodItem item,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final carbs = item.grams * item.carbsPer100g / 100;
    final rations = carbs / 10.0;
    final gi = item.glycemicIndex;
    final textColor = isDark ? Colors.grey.shade200 : Colors.grey.shade900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${item.grams.toStringAsFixed(0)}g',
              style: TextStyle(fontSize: 13, color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${carbs.toStringAsFixed(1)}g',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              rations.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.amber.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: gi != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: _giColor(gi).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      gi,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: _giColor(gi),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const Text(
                    '–',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                    textAlign: TextAlign.center,
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

  Widget _buildTableTotal(
    double totalCarbs,
    double totalRations,
    double totalKcal,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final textColor = isDark ? Colors.grey.shade100 : Colors.grey.shade900;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(
              l10n.photoTableTotal,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: textColor,
              ),
            ),
          ),
          Expanded(flex: 2, child: const SizedBox()),
          Expanded(
            flex: 2,
            child: Text(
              '${totalCarbs.toStringAsFixed(1)}g',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              totalRations.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.amber.shade800,
              ),
              textAlign: TextAlign.center,
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
