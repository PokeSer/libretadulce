import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../core/services/app_settings.dart';
import '../core/services/app_settings_scope.dart';
import '../l10n/app_localizations.dart';
import '../services/ai_client.dart';
import '../services/ai_config.dart';
import '../services/food_photo_analyzer_service.dart';
import '../widgets/app_card.dart';
import 'insulin_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _manualModelController = TextEditingController();
  final TextEditingController _customUrlController = TextEditingController();
  bool _modelsLoading = false;
  List<String> _availableModels = [];
  String? _modelError;

  @override
  void initState() {
    super.initState();
    FoodPhotoAnalyzerService.getApiKey().then((key) {
      if (mounted) {
        _apiKeyController.text = key ?? '';
      }
    });
    AiConfig.customBaseUrl.addListener(_syncCustomUrlField);
  }

  void _syncCustomUrlField() {
    if (AiConfig.provider.id == 'custom' &&
        _customUrlController.text != AiConfig.customBaseUrl.value) {
      _customUrlController.text = AiConfig.customBaseUrl.value;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _manualModelController.dispose();
    _customUrlController.dispose();
    AiConfig.customBaseUrl.removeListener(_syncCustomUrlField);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appSettings = AppSettingsScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileSettings, style: AppTextStyles.appBarTitle),
      ),
      body: SingleChildScrollView(
        padding: AppDimens.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(
              context,
              l10n.profileSettingsSectionApp,
              Icons.settings,
            ),
            const SizedBox(height: 12),
            // Listen to AiConfig so the provider/model labels update without a
            // manual setState when they change via the pickers.
            ListenableBuilder(
              listenable: Listenable.merge([
                AiConfig.providerId,
                AiConfig.modelId,
              ]),
              builder: (context, _) => _buildAiCard(context, l10n),
            ),
            const SizedBox(height: 16),
            _buildThemeCard(context, l10n, appSettings),
            const SizedBox(height: 32),
            _buildSectionLabel(
              context,
              l10n.profileSettingsSectionHealth,
              Icons.monitor_heart_outlined,
            ),
            const SizedBox(height: 12),
            _buildHealthCard(context, l10n),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(icon, size: 18, color: AppColors.accentText(context)),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.accentText(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiCard(BuildContext context, AppLocalizations l10n) {
    final primary = AppColors.primary(context);
    final provider = AiConfig.provider;
    final currentModel = AiConfig.currentModelId.isEmpty
        ? provider.defaultModel
        : AiConfig.currentModelId;
    final showModelPicker =
        provider.id != 'custom' || AiConfig.baseUrl.isNotEmpty;

    return AppCard(
      borderRadius: 14,
      child: Padding(
        padding: AppDimens.listTileContent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Provider picker ---
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ExcludeSemantics(
                child: Icon(Icons.smart_toy, color: primary, size: 20),
              ),
              title: Text(
                _providerDisplayName(provider.id, l10n),
                style: AppTextStyles.cardTitle,
              ),
              subtitle: Text(
                provider.keyPortal.isEmpty
                    ? l10n.profileAiProviderCustomDesc
                    : l10n.profileAiProviderAt(provider.keyPortal),
                style: AppTextStyles.cardSubtitle(context),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _showProviderPicker,
            ),
            const SizedBox(height: 8),

            // --- Model picker ---
            if (showModelPicker)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ExcludeSemantics(
                  child: Icon(Icons.tune, color: primary, size: 20),
                ),
                title: Text(
                  currentModel.isEmpty ? l10n.profileAiModelNone : currentModel,
                  style: TextStyle(
                    fontSize: 14,
                    color: currentModel.isEmpty
                        ? AppColors.textMuted(context)
                        : AppColors.textBody(context),
                  ),
                ),
                subtitle: _modelsLoading
                    ? Text(
                        l10n.profileAiModelFetching,
                        style: AppTextStyles.cardSubtitle(context),
                      )
                    : (_modelError != null
                          ? Text(
                              _modelError!,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.error(context),
                              ),
                            )
                          : null),
                trailing: _modelsLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: _modelsLoading ? null : _loadAndShowModels,
              ),
            if (showModelPicker)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  l10n.profileAiModelVisionHint,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted(context),
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // --- API Key field ---
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.profileAiKeyLabel,
                hintText: provider.keyPortal.isEmpty
                    ? l10n.profileAiKeyHintCustom
                    : l10n.profileAiKeyHint(provider.keyPortal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _saveApiKey,
                child: Text(
                  MaterialLocalizations.of(context).saveButtonLabel,
                  style: TextStyle(color: primary),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // --- Custom base URL (only for custom provider) ---
            if (provider.id == 'custom')
              TextField(
                controller: _customUrlController,
                decoration: InputDecoration(
                  labelText: l10n.profileAiCustomUrlLabel,
                  hintText: l10n.profileAiCustomUrlHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  ),
                  isDense: true,
                ),
                onChanged: (v) => AiConfig.setCustomBaseUrl(v),
              ),
          ],
        ),
      ),
    );
  }

  void _showProviderPicker() {
    final l10n = AppLocalizations.of(context);
    final currentId = AiConfig.providerId.value;
    showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileAiProviderPickerTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: RadioGroup<String>(
            groupValue: currentId,
            onChanged: (value) => Navigator.pop(ctx, value),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: kAiProviders.length,
              itemBuilder: (context, index) {
                final p = kAiProviders[index];
                return RadioListTile<String>(
                  value: p.id,
                  title: Text(_providerDisplayName(p.id, l10n)),
                  subtitle: Text(
                    p.keyPortal.isEmpty
                        ? l10n.profileAiProviderCustomDesc
                        : l10n.profileAiProviderAt(p.keyPortal),
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
        ],
      ),
    ).then((selectedId) async {
      if (selectedId != null && selectedId != currentId) {
        await AiConfig.setProvider(selectedId);
        _customUrlController.clear();
        if (mounted) setState(() {});
      }
    });
  }

  Future<void> _loadAndShowModels() async {
    final l10n = AppLocalizations.of(context);
    final baseUrl = AiConfig.baseUrl;
    final apiKey = await FoodPhotoAnalyzerService.getApiKey();

    if (baseUrl.isEmpty) {
      setState(() => _modelError = l10n.profileAiModelFetchError);
      return;
    }
    if (apiKey == null || apiKey.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.aiErrorNoApiKey)));
      }
      return;
    }

    setState(() {
      _modelsLoading = true;
      _modelError = null;
    });

    try {
      final models = await AiClient.fetchModels(
        baseUrl: baseUrl,
        apiKey: apiKey,
        timeout: const Duration(seconds: 10),
      );
      setState(() {
        _availableModels = models;
      });
      await _showModelPicker(l10n);
    } catch (e) {
      debugPrint('[Settings] Error fetching models: $e');
      setState(() => _modelError = l10n.profileAiModelFetchError);
    } finally {
      if (mounted) {
        setState(() => _modelsLoading = false);
      }
    }
  }

  Future<void> _showModelPicker(AppLocalizations l10n) async {
    final currentId = AiConfig.currentModelId;
    await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.profileAiModelPickerTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: _availableModels.isEmpty
              ? Text(l10n.profileAiModelFetchError)
              : Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _availableModels.length,
                    itemBuilder: (context, index) {
                      final m = _availableModels[index];
                      return ListTile(
                        title: Text(m),
                        trailing: currentId == m
                            ? const Icon(Icons.check)
                            : null,
                        onTap: () => Navigator.pop(ctx, m),
                      );
                    },
                  ),
                ),
        ),
        actions: [
          // Manual entry fallback (for servers whose /models isn't available)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: _manualModelController,
                decoration: InputDecoration(
                  labelText: l10n.profileAiModelManualLabel,
                  hintText: l10n.profileAiModelManualHint,
                ),
                onSubmitted: (_) {
                  final v = _manualModelController.text.trim();
                  if (v.isNotEmpty) Navigator.pop(ctx, v);
                },
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
        ],
      ),
    ).then((selectedId) {
      _manualModelController.clear();
      if (selectedId != null && selectedId.isNotEmpty) {
        AiConfig.setModel(selectedId);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.profileAiModelSaved)));
        }
      }
    });
  }

  Future<void> _saveApiKey() async {
    final l10n = AppLocalizations.of(context);
    await FoodPhotoAnalyzerService.saveApiKey(_apiKeyController.text);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileAiKeySaved)));
    }
  }

  String _providerDisplayName(String id, AppLocalizations l10n) {
    switch (id) {
      case 'gemini':
        return l10n.profileAiProviderGemini;
      case 'groq':
        return l10n.profileAiProviderGroq;
      case 'openrouter':
        return l10n.profileAiProviderOpenRouter;
      case 'openai':
        return l10n.profileAiProviderOpenAI;
      case 'custom':
        return l10n.profileAiProviderCustom;
      default:
        return id;
    }
  }

  Widget _buildThemeCard(
    BuildContext context,
    AppLocalizations l10n,
    AppSettings appSettings,
  ) {
    final currentTheme = appSettings.themeMode;
    final primary = AppColors.primary(context);

    return AppCard(
      borderRadius: 14,
      child: Padding(
        padding: AppDimens.listTileContent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ExcludeSemantics(
                child: Icon(_themeIcon(currentTheme), color: primary),
              ),
              title: Text(
                l10n.profileThemeLabel,
                style: AppTextStyles.cardTitle,
              ),
              subtitle: Text(
                _themeLabel(currentTheme, l10n),
                style: AppTextStyles.cardSubtitle(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SegmentedButton<ThemeMode>(
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: AppColors.primaryLight(context),
                  selectedForegroundColor: primary,
                  visualDensity: VisualDensity.standard,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
                segments: [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    icon: const ExcludeSemantics(
                      child: Icon(Icons.phone_android, size: 18),
                    ),
                    label: Text(
                      l10n.profileThemeSystem,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    icon: const ExcludeSemantics(
                      child: Icon(Icons.light_mode, size: 18),
                    ),
                    label: Text(
                      l10n.profileThemeLight,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    icon: const ExcludeSemantics(
                      child: Icon(Icons.dark_mode, size: 18),
                    ),
                    label: Text(
                      l10n.profileThemeDark,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
                selected: {currentTheme},
                onSelectionChanged: (selection) {
                  appSettings.setThemeMode(selection.first);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(BuildContext context, AppLocalizations l10n) {
    final primary = AppColors.primary(context);
    return AppCard(
      borderRadius: 14,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: ExcludeSemantics(
          child: Icon(Icons.water_drop, color: primary),
        ),
        title: Text(
          l10n.profileInsulinSettings,
          style: AppTextStyles.cardTitle,
        ),
        subtitle: Text(
          l10n.profileInsulinSettingsDesc,
          style: AppTextStyles.cardSubtitle(context),
        ),
        trailing: ExcludeSemantics(
          child: Icon(Icons.chevron_right, color: AppColors.textMuted(context)),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusCardLg),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InsulinSettingsPage()),
          );
        },
      ),
    );
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      default:
        return Icons.phone_android;
    }
  }

  String _themeLabel(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.profileThemeLight;
      case ThemeMode.dark:
        return l10n.profileThemeDark;
      default:
        return l10n.profileThemeSystem;
    }
  }
}
