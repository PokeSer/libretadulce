import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'core/services/app_settings.dart';
import 'core/services/app_settings_scope.dart';
import 'core/theme/app_dimens.dart';
import 'l10n/app_localizations.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'services/food_photo_analyzer_service.dart';

// DIRECTION CONTRACT — Libreta Dulce · mundo «El paisaje de la glucemia»
// THESIS: tu glucemia como paisaje vivo; la curva protagoniza y todo lo
//   demás orbita a su alrededor. Se rechaza la app-tarjetas Material por
//   defecto: aquí cada superficie es un instrumento sobre un lienzo de tinta.
// OWN-WORLD: lienzo de tinta profunda (#101418) en oscuro y porcelana
//   clínica en claro; verde curva (#43CE85 / #177A45) como color de trabajo;
//   ámbar = glucemia baja, rojo = alta, verde = en rango (codificación
//   clínica, nunca decorativa); dígitos tabulares Spline Sans Mono para todo
//   valor medido; Schibsted Grotesk para UI; hairlines outlineVariant.
// STORY: el usuario entiende sus números de un vistazo, confía en el cálculo
//   y guarda su comida sabiendo que el resultado aparece dentro del flujo,
//   nunca interrumpido por diálogos.
// FIRST VIEWPORT: historial diario con el panel de estadísticas y la línea
//   del tiempo como paisaje del día; calculadora con ventana de dosis
//   anclada bajo el plato, cifras magnificadas en mono.
// FORM: IMPECCABLE'S PICK «El paisaje de la glucemia» (candidato 1 de la
//   lista fundamentada; retadores fusionados con donaciones nombradas);
//   seed b23a1bf0. Build code-led: sin comp aprobado; la ambición vive en
//   este contrato y se audita en la revisión final.
// FINISH: unreviewed and undocumented is unfinished; this build ends with
//   the finish review, the verdict, DESIGN.md, and every shipping raster
//   carrying its provenance.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appSettings = AppSettings();
  await appSettings.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  const locales = [
    'es_ES',
    'en_US',
    'fr_FR',
    'it_IT',
    'de_DE',
    'pt',
    'pl_PL',
    'cs_CZ',
  ];
  await Future.wait(locales.map((l) => initializeDateFormatting(l, null)));
  await FoodPhotoAnalyzerService.initApiKeyStatus();
  runApp(AppSettingsScope(settings: appSettings, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    return MaterialApp(
      title: 'Libreta Dulce',
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      themeMode: settings.themeMode,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      home: const AuthWrapper(),
    );
  }

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF43CE85),
    onPrimary: Color(0xFF00391D),
    primaryContainer: Color(0xFF175A36),
    onPrimaryContainer: Color(0xFFA5F2C8),
    secondary: Color(0xFF9CC5B0),
    onSecondary: Color(0xFF07341F),
    secondaryContainer: Color(0xFF24462F),
    onSecondaryContainer: Color(0xFFB7E2CB),
    tertiary: Color(0xFFF2B33D),
    onTertiary: Color(0xFF402D00),
    tertiaryContainer: Color(0xFF5C4300),
    onTertiaryContainer: Color(0xFFFFDF9E),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF101418),
    onSurface: Color(0xFFE4E8E6),
    onSurfaceVariant: Color(0xFFA3ADA7),
    outline: Color(0xFF6F7973),
    outlineVariant: Color(0xFF2C342F),
    inverseSurface: Color(0xFFE4E8E6),
    onInverseSurface: Color(0xFF2B3230),
    inversePrimary: Color(0xFF177A45),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceContainerHighest: Color(0xFF262D31),
    surfaceContainerHigh: Color(0xFF1F2529),
    surfaceContainer: Color(0xFF191E22),
    surfaceContainerLow: Color(0xFF14181C),
    surfaceContainerLowest: Color(0xFF0C0F12),
    primaryFixed: Color(0xFFA5F2C8),
    onPrimaryFixed: Color(0xFF00210F),
    primaryFixedDim: Color(0xFF43CE85),
    onPrimaryFixedVariant: Color(0xFF175A36),
    secondaryFixed: Color(0xFFB7E2CB),
    onSecondaryFixed: Color(0xFF07341F),
    secondaryFixedDim: Color(0xFF9CC5B0),
    onSecondaryFixedVariant: Color(0xFF24462F),
    tertiaryFixed: Color(0xFFFFDF9E),
    onTertiaryFixed: Color(0xFF261A00),
    tertiaryFixedDim: Color(0xFFF2B33D),
    onTertiaryFixedVariant: Color(0xFF5C4300),
    surfaceTint: Color(0xFF43CE85),
  );

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF177A45),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFA6F2C6),
    onPrimaryContainer: Color(0xFF00210F),
    secondary: Color(0xFF4C6357),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFCFE9D8),
    onSecondaryContainer: Color(0xFF092016),
    tertiary: Color(0xFF8A5A00),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDEA6),
    onTertiaryContainer: Color(0xFF2B1800),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF7F8F5),
    onSurface: Color(0xFF171B17),
    onSurfaceVariant: Color(0xFF48524A),
    outline: Color(0xFF78827A),
    outlineVariant: Color(0xFFDCE2DB),
    inverseSurface: Color(0xFF2B3230),
    onInverseSurface: Color(0xFFECF1EE),
    inversePrimary: Color(0xFF43CE85),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceContainerHighest: Color(0xFFE2E5DE),
    surfaceContainerHigh: Color(0xFFE8EBE4),
    surfaceContainer: Color(0xFFEEEFE9),
    surfaceContainerLow: Color(0xFFF4F5EF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    primaryFixed: Color(0xFFA6F2C6),
    onPrimaryFixed: Color(0xFF00210F),
    primaryFixedDim: Color(0xFF43CE85),
    onPrimaryFixedVariant: Color(0xFF00522B),
    secondaryFixed: Color(0xFFCFE9D8),
    onSecondaryFixed: Color(0xFF092016),
    secondaryFixedDim: Color(0xFFB3CCBD),
    onSecondaryFixedVariant: Color(0xFF354B40),
    tertiaryFixed: Color(0xFFFFDEA6),
    onTertiaryFixed: Color(0xFF2B1800),
    tertiaryFixedDim: Color(0xFFFFBE48),
    onTertiaryFixedVariant: Color(0xFF694400),
    surfaceTint: Color(0xFF177A45),
  );

  /// Shared component grammar for both modes: quiet panels with hairlines,
  /// tonal elevation only, mono numerals in inputs' suffixes handled by the
  /// widgets themselves.
  static ThemeData _baseTheme(ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final hairline = scheme.outlineVariant;

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      splashFactory: InkSparkle.splashFactory,
      textTheme: GoogleFonts.schibstedGroteskTextTheme(
        brightness == Brightness.dark
            ? ThemeData.dark().textTheme
            : ThemeData.light().textTheme,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          side: BorderSide(color: hairline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
          borderSide: BorderSide(color: hairline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
          borderSide: BorderSide(color: scheme.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
          borderSide: BorderSide(color: scheme.error, width: 1.6),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.schibstedGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: isDark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? scheme.onPrimaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.schibstedGrotesk(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? scheme.onSurface
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusInput + 2),
          ),
          textStyle: GoogleFonts.schibstedGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusInput + 2),
          ),
          textStyle: GoogleFonts.schibstedGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.schibstedGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusCardLg),
        ),
      ),
      chipTheme: ChipThemeData(
        side: BorderSide(color: hairline, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
        labelStyle: GoogleFonts.schibstedGrotesk(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: scheme.onSurfaceVariant,
        ),
        selectedColor: scheme.primaryContainer,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusDialog),
          side: BorderSide(color: hairline, width: 1),
        ),
        titleTextStyle: GoogleFonts.schibstedGrotesk(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        modalBackgroundColor: isDark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        showDragHandle: true,
        dragHandleColor: scheme.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: GoogleFonts.schibstedGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: scheme.onInverseSurface,
        ),
        actionTextColor: scheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusInput + 2),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.schibstedGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.schibstedGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusInput),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: hairline,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.onPrimary
              : scheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceContainerHighest,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: isDark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        headerForegroundColor: scheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusDialog),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        dialHandColor: scheme.primaryContainer,
        dialBackgroundColor: scheme.surfaceContainerHigh,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.schibstedGrotesk(
          fontSize: 12,
          color: scheme.onInverseSurface,
        ),
      ),
    );
  }

  ThemeData _buildLightTheme() => _baseTheme(_lightColorScheme, Brightness.light);

  ThemeData _buildDarkTheme() => _baseTheme(_darkColorScheme, Brightness.dark);
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Semantics(
                label: l10n.loadingApp,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
