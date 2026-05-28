import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    await authService.signInWithGoogle();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    // Una vez autenticado, la navegación se gestionará en main.dart
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Usamos colores de salud: azul claro, verde azulado, blancos
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icono / Logo principal
              ExcludeSemantics(
                child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_rounded,
                  size: 100,
                  color: Colors.teal.shade600,
                ),
              ),
              ),
              
              // Título
              Text(
                l10n.loginTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  color: Colors.teal.shade900,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtítulo
              Text(
                l10n.loginSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 60),

              // Botón de Inicio de sesión
              _isLoading
                  ? Center(
                      child: Semantics(
                        label: l10n.loginIniciandoSesion,
                        child: const CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.person,
                          color: Colors.teal,
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
                        backgroundColor: Colors.teal.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                      ),
                    ),

              const SizedBox(height: 32),

              // Texto de privacidad o garantía de salud
              Text(
                l10n.loginPrivacyText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
