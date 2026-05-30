import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../main.dart' show appSettings;
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: appSettings,
        builder: (context, _) {
          final dark = Theme.of(context).brightness == Brightness.dark;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel(l10n.profileSettingsSectionApp, Icons.settings, dark),
                const SizedBox(height: 12),
                _buildThemeCard(dark, l10n),
                const SizedBox(height: 32),
                _buildSectionLabel(l10n.profileSettingsSectionHealth, Icons.monitor_heart_outlined, dark),
                const SizedBox(height: 12),
                _buildHealthCard(dark, l10n, context),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String title, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(icon, size: 18, color: isDark ? Colors.teal.shade300 : Colors.teal.shade700),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: isDark ? Colors.teal.shade300 : Colors.teal.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(bool isDark, AppLocalizations l10n) {
    final currentTheme = appSettings.themeMode;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              subtitle: Text(
                _themeLabel(currentTheme, l10n),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
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

  Widget _buildHealthCard(bool isDark, AppLocalizations l10n, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: const Icon(Icons.water_drop, color: Colors.teal, semanticLabel: ''),
            title: Text(
              l10n.profileInsulinSettings,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            subtitle: Text(
              l10n.profileInsulinSettingsDesc,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, semanticLabel: ''),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InsulinSettingsPage()),
              );
            },
          ),
        ],
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
