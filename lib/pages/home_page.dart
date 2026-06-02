import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/extensions/context_extensions.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import 'calculator_page.dart';
import 'foods_page.dart';
import 'global_foods_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'admin_page.dart';
import 'history_page.dart';
import '../l10n/app_localizations.dart';
import '../services/update_service.dart';

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
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      
      // Si el usuario no tiene documento aún, se lo creamos por defecto como "user" (no admin)
      if (!userDoc.exists) {
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'email': user!.email,
          'role': 'user', // user o admin
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Leemos su rol de Firestore
        if (userDoc.data()?['role'] == 'admin') {
          if (mounted) setState(() => _isAdmin = true);
        }
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
                  color: Colors.teal.withValues(alpha: isDark ? 0.15 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: ExcludeSemantics(
                  child: const Icon(Icons.system_update_rounded,
                      color: Colors.teal, size: 40),
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
                padding:
                    AppDimens.cardMargin,
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                ),
                child: Text(
                  l10n.updateVersion(tag),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
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
                    color: isDark
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(AppDimens.radiusCard),
                  ),
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: SingleChildScrollView(
                    child: Text(
                      update.releaseNotes,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color:
                            AppColors.textMuted(context),
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
                        backgroundColor: Colors.teal,
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
    double progress = 0;

    if (!mounted) return;

    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.download_rounded, color: Colors.teal, size: 40),
              const SizedBox(height: 16),
              Text(
                l10n.updateDownloading,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress > 0 ? progress : null,
                backgroundColor: Colors.grey.shade300,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                progress > 0
                    ? '${(progress * 100).toStringAsFixed(0)}%'
                    : l10n.updateDownloading,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );

    final success = await UpdateService.downloadAndInstall(
      update.downloadUrl,
      onProgress: (p) {
        progress = p;
        if (mounted) {
          // Rebuild dialog with new progress
          (context as Element).markNeedsBuild();
        }
      },
    );

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // Close progress dialog
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
    GlobalFoodsPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Por si al cambiar de modo el índice se queda fuera de rango
    final int safeIndex = _currentIndex >= _pages.length ? 0 : _currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Icono en el header
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
          if (safeIndex == 4)
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
          // Botón de Admin en la barra superior (solo si el rol en BD es admin)
          if (_isAdmin)
            IconButton(
              icon: const Icon(
                Icons.admin_panel_settings,
                color: Colors.amberAccent,
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
            icon: const Icon(Icons.public_outlined),
            selectedIcon: const Icon(Icons.public),
            label: l10n.navGlobal,
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
