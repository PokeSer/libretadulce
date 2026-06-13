import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import 'calculator_page.dart';
import 'foods_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'admin_page.dart';
import 'history_page.dart';
import '../l10n/app_localizations.dart';
import '../services/update_service.dart';
import '../services/user_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _checkForUpdates();
  }

  Future<void> _checkAdminStatus() async {
    if (user != null) {
      try {
        final role = await UserRepository.ensureUserDoc(
          uid: user!.uid,
          email: user!.email ?? '',
        );
        if (role == 'admin' && mounted) {
          setState(() => _isAdmin = true);
        }
      } catch (e) {
        debugPrint('[HomePage._checkAdminStatus] Error: $e');
      }
    }
  }

  Future<void> _checkForUpdates() async {
    final update = await UpdateService.checkForUpdate();
    if (update != null && mounted) {
      _showUpdateDialog(update);
    }
  }

  void _showUpdateDialog(UpdateInfo update) {
    final l10n = AppLocalizations.of(context);
    final isDark = context.isDarkMode;
    final primary = AppColors.primary(context);
    final tag = 'v${update.version}';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusPill)),
        child: Padding(
          padding: AppDimens.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: AppDimens.cardPadding,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isDark ? 0.15 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: ExcludeSemantics(
                  child: Icon(Icons.system_update_rounded,
                      color: primary, size: 40),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.updateAvailable,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: AppDimens.cardMargin,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                ),
                child: Text(
                  l10n.updateVersion(tag),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primary,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              if (update.releaseNotes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.updateWhatIsNew,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt(context),
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  ),
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: SingleChildScrollView(
                    child: Text(
                      update.releaseNotes,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textMuted(context),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      autofocus: true,
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: AppDimens.buttonPaddingV,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
                      ),
                      child: Text(l10n.updateLater),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _downloadUpdate(update);
                      },
                      icon: const Icon(Icons.download, size: 18),
                      label: Text(l10n.updateDownload),
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        padding: AppDimens.buttonPaddingV,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimens.radiusCard)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _downloadUpdate(UpdateInfo update) async {
    final l10n = AppLocalizations.of(context);
    final primary = AppColors.primary(context);
    double progress = 0;

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          content: Semantics(
            liveRegion: true,
            label: l10n.updateDownloading,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Icon(Icons.download_rounded, color: primary, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.updateDownloading,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress > 0 ? progress : null,
                  backgroundColor: AppColors.textMuted(context),
                  color: primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  progress > 0
                      ? '${(progress * 100).toStringAsFixed(0)}%'
                      : l10n.updateDownloading,
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final success = await UpdateService.downloadAndInstall(
      update.downloadUrl,
      onProgress: (p) {
        progress = p;
        if (mounted) {
          (context as Element).markNeedsBuild();
        }
      },
    );

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.updateError)),
        );
      }
    }
  }

  List<Widget> get _pages => const [
    CalculatorPage(),
    FoodsPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final int safeIndex = _currentIndex >= _pages.length ? 0 : _currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusInput),
                child: Image.asset(
                  'assets/icon.png',
                  height: 36,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.favorite, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.appTitle,
              style: AppTextStyles.appBarTitle,
            ),
          ],
        ),
        actions: [
          if (safeIndex == 3)
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: l10n.profileSettings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          if (_isAdmin)
            IconButton(
              icon: Icon(
                Icons.admin_panel_settings,
                color: AppColors.accentFavorite(context),
              ),
              tooltip: l10n.navAdminTooltip,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                );
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: safeIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: l10n.navCalculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fastfood_outlined),
            selectedIcon: const Icon(Icons.fastfood),
            label: l10n.navFoods,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.navHistory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
