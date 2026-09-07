import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An AI provider preset with everything the app needs to talk to it.
///
/// All presets speak the OpenAI-compatible protocol, so the same
/// [AiClient] works for every one of them.
class AiProvider {
  /// Registry id, also the value persisted in `SharedPreferences`.
  final String id;

  /// OpenAI-compatible base URL (already includes `/v1`-style path).
  /// Empty for `custom` — the user enters their own.
  final String baseUrl;

  /// Model id pre-selected when switching to this provider, until the user
  /// picks one from the live `/models` list. Empty for `custom`.
  final String defaultModel;

  /// Where the user can create an API key for this provider.
  /// Empty for `custom` (no single portal to point to).
  final String keyPortal;

  const AiProvider({
    required this.id,
    required this.baseUrl,
    required this.defaultModel,
    required this.keyPortal,
  });
}

/// Known provider presets. Order is the order shown in the picker.
const kAiProviders = [
  AiProvider(
    id: 'gemini',
    baseUrl: 'https://generativelanguage.googleapis.com/v1beta/openai/',
    defaultModel: 'gemini-2.5-flash',
    keyPortal: 'aistudio.google.com',
  ),
  AiProvider(
    id: 'groq',
    baseUrl: 'https://api.groq.com/openai/v1',
    defaultModel: 'llama-3.3-70b-versatile',
    keyPortal: 'console.groq.com/keys',
  ),
  AiProvider(
    id: 'openrouter',
    baseUrl: 'https://openrouter.ai/api/v1',
    defaultModel: 'meta-llama/llama-3.3-70b-instruct:free',
    keyPortal: 'openrouter.ai/keys',
  ),
  AiProvider(
    id: 'openai',
    baseUrl: 'https://api.openai.com/v1',
    defaultModel: 'gpt-4o-mini',
    keyPortal: 'platform.openai.com',
  ),
  AiProvider(id: 'custom', baseUrl: '', defaultModel: '', keyPortal: ''),
];

/// Device-local AI configuration: selected provider, selected model and
/// custom base URL (for the `custom` provider).
///
/// Static service with reactive [ValueNotifier]s, following the pattern of
/// [FoodPhotoAnalyzerService] — the AI services need to read this without a
/// `BuildContext`, so it must not live on the `AppSettings` instance.
class AiConfig {
  static const _providerPref = 'ai_provider';
  static const _modelPref = 'ai_model';
  static const _customUrlPref = 'ai_custom_base_url';

  /// Reactive — the currently selected provider id (a `kAiProviders` id).
  static final ValueNotifier<String> providerId = ValueNotifier('gemini');

  /// Reactive — the currently selected model id, or '' if none.
  static final ValueNotifier<String> modelId = ValueNotifier('');

  /// Reactive — user-entered base URL, only used when provider is `custom`.
  static final ValueNotifier<String> customBaseUrl = ValueNotifier('');

  /// Call once at app start to load the persisted values.
  ///
  /// When nothing is configured yet (fresh install or an update from a
  /// Gemini-only version), defaults to Gemini + `gemini-2.5-flash`, so
  /// existing Gemini users keep working without re-configuring anything.
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProvider = prefs.getString(_providerPref);
      if (savedProvider != null &&
          kAiProviders.any((p) => p.id == savedProvider)) {
        providerId.value = savedProvider;
      }
      final model = prefs.getString(_modelPref);
      if (model != null && model.isNotEmpty) {
        modelId.value = model;
      } else {
        modelId.value = provider.defaultModel;
      }
      final customUrl = prefs.getString(_customUrlPref);
      if (customUrl != null) {
        customBaseUrl.value = customUrl;
      }
    } catch (e) {
      debugPrint('[AiConfig.init] Error loading config: $e');
      providerId.value = 'gemini';
      modelId.value = kAiProviders.first.defaultModel;
    }
  }

  /// Switch the active provider. The model resets to the new provider's
  /// default until the user picks one from its live list.
  static Future<void> setProvider(String id) async {
    assert(kAiProviders.any((p) => p.id == id), 'Unknown provider id: $id');
    providerId.value = id;
    modelId.value = provider.defaultModel;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_providerPref, id);
      await prefs.setString(_modelPref, modelId.value);
    } catch (e) {
      debugPrint('[AiConfig.setProvider] Error saving provider: $e');
    }
  }

  /// Save the selected model id (optimistic update, like `setThemeMode`).
  static Future<void> setModel(String model) async {
    final trimmed = model.trim();
    if (trimmed.isEmpty) return;
    modelId.value = trimmed;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_modelPref, trimmed);
    } catch (e) {
      debugPrint('[AiConfig.setModel] Error saving model: $e');
    }
  }

  /// Save the custom base URL (only meaningful for the `custom` provider).
  static Future<void> setCustomBaseUrl(String url) async {
    final trimmed = url.trim();
    customBaseUrl.value = trimmed;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_customUrlPref, trimmed);
    } catch (e) {
      debugPrint('[AiConfig.setCustomBaseUrl] Error saving URL: $e');
    }
  }

  /// The currently selected provider preset.
  static AiProvider get provider => kAiProviders.firstWhere(
    (p) => p.id == providerId.value,
    orElse: () => kAiProviders.first,
  );

  /// Effective base URL for the active provider: the preset's URL, or the
  /// user's custom URL. Normalized without a trailing slash so callers can
  /// append `/chat/completions` and `/models` directly.
  static String get baseUrl {
    final raw = provider.id == 'custom'
        ? customBaseUrl.value
        : provider.baseUrl;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.endsWith('/')
        ? trimmed.substring(0, trimmed.length - 1)
        : trimmed;
  }

  /// The currently selected model id ('' if none, e.g. custom not set up).
  static String get currentModelId => modelId.value;
}
