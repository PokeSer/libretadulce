import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';

/// Login — the first viewport of the world: the glucose landscape already
/// lives behind the brand, calm and in range.
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final landscapeHeight = constraints.maxHeight * 0.38;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The landscape: one calm day of readings, drawn once.
                    ExcludeSemantics(
                      child: SizedBox(
                        height: landscapeHeight,
                        width: double.infinity,
                        child: const GlucoseLandscape(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        32,
                        constraints.maxHeight > 640 ? 8 : 16,
                        32,
                        32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ExcludeSemantics(
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 28),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBg(context),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.hairline(context),
                                    width: 1,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/icon.png',
                                  width: 84,
                                  height: 84,
                                ),
                              ),
                            ),
                          ),

                          Text(
                            l10n.loginTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                              height: 1.1,
                              color: AppColors.textHeading(context),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            l10n.loginSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: AppColors.textSecondary(context),
                            ),
                          ),

                          const SizedBox(height: 48),

                          _isLoading
                              ? Center(
                                  child: Semantics(
                                    label: l10n.loginIniciandoSesion,
                                    child: CircularProgressIndicator(
                                        color: primary),
                                  ),
                                )
                              : FilledButton.icon(
                                  onPressed: _handleGoogleSignIn,
                                  icon: const Icon(Icons.login_rounded,
                                      size: 22),
                                  label: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      l10n.loginButtonGoogle,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),

                          const SizedBox(height: 28),

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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Paints the product's own landscape: one smooth day of readings inside its
/// range band, with meal events as nodes on the line. Geometry only — crisp
/// vector linework in the theme's own hues.
class GlucoseLandscape extends StatelessWidget {
  const GlucoseLandscape({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GlucoseLandscapePainter(
        stroke: AppColors.curveStroke(context),
        wash: AppColors.curveWash(context),
        low: AppColors.glucoseLow(context),
        high: AppColors.glucoseHigh(context),
        hairline: AppColors.hairline(context),
        ring: AppColors.scaffoldBg(context),
      ),
      size: Size.infinite,
    );
  }
}

class _GlucoseLandscapePainter extends CustomPainter {
  final Color stroke;
  final Color wash;
  final Color low;
  final Color high;
  final Color hairline;
  final Color ring;

  _GlucoseLandscapePainter({
    required this.stroke,
    required this.wash,
    required this.low,
    required this.high,
    required this.hairline,
    required this.ring,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Range band: the safe corridor the curve lives in.
    final bandTop = size.height * 0.34;
    final bandBottom = size.height * 0.66;
    canvas.drawRect(
      Rect.fromLTRB(0, bandTop, size.width, bandBottom),
      Paint()..color = wash,
    );

    // Quiet horizontal guides at the band edges.
    final guidePaint = Paint()
      ..color = hairline
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(size.width * 0.06, bandTop),
        Offset(size.width, bandTop),
        guidePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.06, bandBottom),
      Offset(size.width, bandBottom),
      guidePaint,
    );

    // One reading series across the width; y normalized 0..1 where 0 is up.
    // The day breathes inside the band: gentle rises, one dip after the
    // second meal, recovery — never a dramatic crash.
    const points = [
      Offset(-0.01, 0.52),
      Offset(0.10, 0.47),
      Offset(0.20, 0.42),
      Offset(0.30, 0.38),
      Offset(0.40, 0.46),
      Offset(0.50, 0.60),
      Offset(0.60, 0.72),
      Offset(0.70, 0.58),
      Offset(0.80, 0.44),
      Offset(0.90, 0.36),
      Offset(1.01, 0.40),
    ];
    final scaled = points
        .map((p) => Offset(p.dx * size.width, p.dy * size.height))
        .toList();

    // Smooth the readings with a Catmull-Rom to Bezier pass.
    final path = Path()..moveTo(scaled.first.dx, scaled.first.dy);
    for (var i = 0; i < scaled.length - 1; i++) {
      final p0 = scaled[i == 0 ? 0 : i - 1];
      final p1 = scaled[i];
      final p2 = scaled[i + 1];
      final p3 = scaled[i + 2 < scaled.length ? i + 2 : scaled.length - 1];
      final c1 = p1 + (p2 - p0) / 6;
      final c2 = p2 - (p3 - p1) / 6;
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }

    // Soft wash under the curve line, echoing the band.
    final fillPath = Path.from(path)
      ..lineTo(scaled.last.dx, size.height)
      ..lineTo(scaled.first.dx, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [wash, wash.withValues(alpha: 0)],
        ).createShader(Rect.fromLTWH(0, bandTop, size.width, size.height)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Event nodes on the line: one reading above range, one back in range —
    // the day the app exists for.
    _drawNode(canvas, scaled[6], high);
    _drawNode(canvas, scaled[9], stroke);
  }

  void _drawNode(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 9, Paint()..color = color.withValues(alpha: 0.18));
    canvas.drawCircle(center, 5, Paint()..color = color);
    canvas.drawCircle(
      center,
      5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = ring,
    );
  }

  @override
  bool shouldRepaint(covariant _GlucoseLandscapePainter oldDelegate) =>
      oldDelegate.stroke != stroke ||
      oldDelegate.wash != wash ||
      oldDelegate.low != low ||
      oldDelegate.high != high ||
      oldDelegate.hairline != hairline ||
      oldDelegate.ring != ring;
}
