import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'insulin_settings_page.dart';
import '../l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Semantics(
            label: l10n.profilePhotoAccessibility(user.displayName ?? l10n.profileDefaultName),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: isDark ? Colors.teal.withValues(alpha: 0.1) : Colors.teal.shade100,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : null,
              child: user.photoURL == null
                  ? const Icon(Icons.person, size: 60, color: Colors.teal)
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            user.displayName ?? l10n.profileDefaultName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.teal.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.email ?? '',
            style: TextStyle(fontSize: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
          ),

          const Spacer(),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isDark ? const Color(0xFF333333) : Colors.white,
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.redAccent),
              title: Text(
                l10n.profileAboutTitle, 
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
              subtitle: Text(l10n.profileAboutSubtitle),
              trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white54 : Colors.grey),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.redAccent),
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
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.profileAboutDialogClose, style: const TextStyle(color: Colors.teal)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isDark ? const Color(0xFF333333) : Colors.white,
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.water_drop, color: Colors.teal),
              title: Text(
                l10n.profileInsulinSettings,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(l10n.profileInsulinSettingsDesc),
              trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white54 : Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InsulinSettingsPage()),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.profileLogoutDialogTitle),
                    content: Text(l10n.profileLogoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          l10n.profileLogoutCancel,
                          style: const TextStyle(color: Colors.teal),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await authService.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: Text(
                          l10n.profileLogoutButton,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: Text(
                l10n.profileLogout,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
