import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _appVersion = 'v${info.version}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final AuthService authService = AuthService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    if (user == null) {
      return Center(child: Text(l10n.profileNotLoggedIn));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Semantics(
                  label: l10n.profilePhotoAccessibility(user.displayName ?? l10n.profileDefaultName),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: isDark ? Colors.teal.withValues(alpha: 0.1) : Colors.teal.shade100,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null
                        ? const Icon(Icons.person, size: 55, color: Colors.teal)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? l10n.profileDefaultName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.teal.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          const Spacer(),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            elevation: 0,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(Icons.favorite, color: Colors.redAccent, semanticLabel: ''),
              title: Text(
                l10n.profileAboutTitle,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              subtitle: Text(
                l10n.profileAboutSubtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, semanticLabel: ''),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Row(
                      children: [
                        const ExcludeSemantics(child: Icon(Icons.favorite, color: Colors.redAccent)),
                        const SizedBox(width: 8),
                        Text(l10n.profileAboutDialogTitle),
                      ],
                    ),
                    content: Text(
                      l10n.profileAboutDialogText,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 15,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l10n.profileAboutDialogClose, style: const TextStyle(color: Colors.teal)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.profileLogoutDialogTitle),
                    content: Text(l10n.profileLogoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(l10n.profileLogoutCancel, style: const TextStyle(color: Colors.teal)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await authService.signOut();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        child: Text(l10n.profileLogoutButton, style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              label: Text(l10n.profileLogout, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            label: l10n.updateVersion(_appVersion),
            child: Column(
              children: [
                Text(
                  l10n.appTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  ),
                ),
                if (_appVersion.isNotEmpty)
                  Text(
                    _appVersion,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
