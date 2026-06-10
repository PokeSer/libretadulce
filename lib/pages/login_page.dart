import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    final authService = AuthService();
    try {
      await authService.signInWithGoogle();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.error(context),
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.serviceError),
            backgroundColor: AppColors.error(context),
            duration: const Duration(seconds: 8),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final primary = AppColors.primary(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExcludeSemantics(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 100,
                    color: primary,
                  ),
                ),
              ),

              Text(
                l10n.loginTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  color: AppColors.primaryDark(context),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                l10n.loginSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppColors.textSecondary(context),
                ),
              ),

              const SizedBox(height: 60),

              _isLoading
                  ? Center(
                      child: Semantics(
                        label: l10n.loginIniciandoSesion,
                        child: CircularProgressIndicator(color: primary),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: AppColors.onPrimary(context),
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.person,
                          color: primary,
                          size: 24,
                        ),
                      ),
                      label: Text(
                        l10n.loginButtonGoogle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: AppColors.onPrimary(context),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusRound),
                        ),
                        elevation: 2,
                      ),
                    ),

              const SizedBox(height: 32),

              Text(
                l10n.loginPrivacyText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors.textMuted(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
