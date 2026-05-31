import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../l10n/app_localizations.dart';
import '../main.dart' show appSettings;
import '../widgets/app_card.dart';
import 'insulin_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profileSettings,
          style: AppTextStyles.appBarTitle,
        ),
      ),
      body: ListenableBuilder(
        listenable: appSettings,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: AppDimens.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(context, l10n.profileSettingsSectionApp, Icons.settings),
                const SizedBox(height: 12),
                _buildThemeCard(context, l10n),
                const SizedBox(height: 32),
                _buildSectionLabel(context, l10n.profileSettingsSectionHealth, Icons.monitor_heart_outlined),
                const SizedBox(height: 12),
                _buildHealthCard(context, l10n),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
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

  Widget _buildThemeCard(BuildContext context, AppLocalizations l10n) {
    final currentTheme = appSettings.themeMode;

    return AppCard(
      borderRadius: 14,
      child: Padding(
        padding: AppDimens.listTileContent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _themeIcon(currentTheme),
                color: Colors.teal,
                semanticLabel: '',
              ),
              title: Text(
                l10n.profileThemeLabel,
                style: AppTextStyles.cardTitle,
              ),
              subtitle: Text(
                _themeLabel(currentTheme, l10n),
                style: AppTextStyles.cardSubtitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SegmentedButton<ThemeMode>(
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: Colors.teal.withValues(alpha: 0.15),
                  selectedForegroundColor: Colors.teal,
                ),
                segments: [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.system,
                    icon: const ExcludeSemantics(child: Icon(Icons.phone_android, size: 18)),
                    label: Text(l10n.profileThemeSystem, style: const TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    icon: const ExcludeSemantics(child: Icon(Icons.light_mode, size: 18)),
                    label: Text(l10n.profileThemeLight, style: const TextStyle(fontSize: 12)),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    icon: const ExcludeSemantics(child: Icon(Icons.dark_mode, size: 18)),
                    label: Text(l10n.profileThemeDark, style: const TextStyle(fontSize: 12)),
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
    return AppCard(
      borderRadius: 14,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: const Icon(Icons.water_drop, color: Colors.teal, semanticLabel: ''),
        title: Text(
          l10n.profileInsulinSettings,
          style: AppTextStyles.cardTitle,
        ),
        subtitle: Text(
          l10n.profileInsulinSettingsDesc,
          style: AppTextStyles.cardSubtitle,
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, semanticLabel: ''),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusCardLg)),
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
