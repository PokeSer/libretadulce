import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pl'),
    Locale('pt'),
  ];

  /// Application title used in the app bar and material app
  ///
  /// In es, this message translates to:
  /// **'Libreta Dulce'**
  String get appTitle;

  /// Accessibility label for loading indicator
  ///
  /// In es, this message translates to:
  /// **'Cargando aplicación'**
  String get loadingApp;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Libreta Dulce'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Tu asistente personal para el control diario de carbohidratos y raciones.'**
  String get loginSubtitle;

  /// No description provided for @loginButtonGoogle.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get loginButtonGoogle;

  /// No description provided for @loginIniciandoSesion.
  ///
  /// In es, this message translates to:
  /// **'Iniciando sesión'**
  String get loginIniciandoSesion;

  /// No description provided for @loginPrivacyText.
  ///
  /// In es, this message translates to:
  /// **'Tus datos de salud están protegidos\ny vinculados únicamente a tu cuenta personal.'**
  String get loginPrivacyText;

  /// No description provided for @navCalculator.
  ///
  /// In es, this message translates to:
  /// **'Calculadora'**
  String get navCalculator;

  /// No description provided for @navFoods.
  ///
  /// In es, this message translates to:
  /// **'Alimentos'**
  String get navFoods;

  /// No description provided for @navGlobal.
  ///
  /// In es, this message translates to:
  /// **'Global'**
  String get navGlobal;

  /// No description provided for @navHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @navAdminTooltip.
  ///
  /// In es, this message translates to:
  /// **'Administración Global'**
  String get navAdminTooltip;

  /// No description provided for @calcTitle.
  ///
  /// In es, this message translates to:
  /// **'Calculadora & Plato'**
  String get calcTitle;

  /// No description provided for @calcGramsMode.
  ///
  /// In es, this message translates to:
  /// **'Tengo los gramos\n(Quiero Raciones)'**
  String get calcGramsMode;

  /// No description provided for @calcRationsMode.
  ///
  /// In es, this message translates to:
  /// **'Quiero comer Raciones\n(Dime los gramos)'**
  String get calcRationsMode;

  /// No description provided for @calcSearchFood.
  ///
  /// In es, this message translates to:
  /// **'Toca para buscar alimento...'**
  String get calcSearchFood;

  /// No description provided for @calcSearchFoodAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Buscar alimento'**
  String get calcSearchFoodAccessibility;

  /// No description provided for @calcFoodAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Alimento'**
  String get calcFoodAccessibility;

  /// Accessibility label for selected food
  ///
  /// In es, this message translates to:
  /// **'Alimento seleccionado: {foodName}. Toca para cambiar.'**
  String calcSelectedFood(String foodName);

  /// No description provided for @calcCarbsPer100g.
  ///
  /// In es, this message translates to:
  /// **'{carbs}g HC / 100g'**
  String calcCarbsPer100g(String carbs);

  /// No description provided for @calcFavoritesTitle.
  ///
  /// In es, this message translates to:
  /// **'Favoritos rápidos'**
  String get calcFavoritesTitle;

  /// No description provided for @calcInputGramsLabel.
  ///
  /// In es, this message translates to:
  /// **'Cantidad en gramos'**
  String get calcInputGramsLabel;

  /// No description provided for @calcInputRationsLabel.
  ///
  /// In es, this message translates to:
  /// **'Raciones a comer'**
  String get calcInputRationsLabel;

  /// No description provided for @calcInputGramsSuffix.
  ///
  /// In es, this message translates to:
  /// **'gramos'**
  String get calcInputGramsSuffix;

  /// No description provided for @calcInputRationsSuffix.
  ///
  /// In es, this message translates to:
  /// **'raciones'**
  String get calcInputRationsSuffix;

  /// No description provided for @calcResultTitle.
  ///
  /// In es, this message translates to:
  /// **'RESULTADO'**
  String get calcResultTitle;

  /// No description provided for @calcResultInverseTitle.
  ///
  /// In es, this message translates to:
  /// **'TIENES QUE PESAR'**
  String get calcResultInverseTitle;

  /// No description provided for @calcGramsHC.
  ///
  /// In es, this message translates to:
  /// **'Gramos HC'**
  String get calcGramsHC;

  /// No description provided for @calcRations.
  ///
  /// In es, this message translates to:
  /// **'Raciones'**
  String get calcRations;

  /// No description provided for @calcOfFood.
  ///
  /// In es, this message translates to:
  /// **'de {foodName}'**
  String calcOfFood(String foodName);

  /// No description provided for @calcAddToPlate.
  ///
  /// In es, this message translates to:
  /// **'Añadir al plato actual'**
  String get calcAddToPlate;

  /// No description provided for @calcMyPlate.
  ///
  /// In es, this message translates to:
  /// **'Mi Plato Actual'**
  String get calcMyPlate;

  /// No description provided for @calcClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get calcClear;

  /// No description provided for @calcGramsConsumed.
  ///
  /// In es, this message translates to:
  /// **'{grams}g consumidos'**
  String calcGramsConsumed(String grams);

  /// No description provided for @calcRacShort.
  ///
  /// In es, this message translates to:
  /// **'{rac}Rac.'**
  String calcRacShort(String rac);

  /// No description provided for @calcHC.
  ///
  /// In es, this message translates to:
  /// **'{carbs}g HC'**
  String calcHC(String carbs);

  /// No description provided for @calcDeleteFromPlate.
  ///
  /// In es, this message translates to:
  /// **'Eliminar del plato'**
  String get calcDeleteFromPlate;

  /// No description provided for @calcTotalPlate.
  ///
  /// In es, this message translates to:
  /// **'TOTAL DEL PLATO:'**
  String get calcTotalPlate;

  /// No description provided for @calcTotalRac.
  ///
  /// In es, this message translates to:
  /// **'{rac}Rac.'**
  String calcTotalRac(String rac);

  /// No description provided for @calcTotalHC.
  ///
  /// In es, this message translates to:
  /// **'{carbs}g HC'**
  String calcTotalHC(String carbs);

  /// No description provided for @calcMealTypeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo de comida:'**
  String get calcMealTypeLabel;

  /// No description provided for @calcTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get calcTimeLabel;

  /// No description provided for @calcDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get calcDateLabel;

  /// No description provided for @calcBolusTitle.
  ///
  /// In es, this message translates to:
  /// **'Bolo de Insulina'**
  String get calcBolusTitle;

  /// No description provided for @calcGlucoseLabel.
  ///
  /// In es, this message translates to:
  /// **'Glucemia actual (opcional)'**
  String get calcGlucoseLabel;

  /// No description provided for @calcGlucoseHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 145'**
  String get calcGlucoseHint;

  /// No description provided for @calcGlucoseSuffix.
  ///
  /// In es, this message translates to:
  /// **'mg/dL'**
  String get calcGlucoseSuffix;

  /// No description provided for @calcBolusMeal.
  ///
  /// In es, this message translates to:
  /// **'Bolo comida'**
  String get calcBolusMeal;

  /// No description provided for @calcBolusCorrection.
  ///
  /// In es, this message translates to:
  /// **'Corrección'**
  String get calcBolusCorrection;

  /// No description provided for @calcBolusTotal.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get calcBolusTotal;

  /// No description provided for @calcBolusUnitSuffix.
  ///
  /// In es, this message translates to:
  /// **'uds'**
  String get calcBolusUnitSuffix;

  /// No description provided for @calcNoFoodsMessage.
  ///
  /// In es, this message translates to:
  /// **'Añade alimentos al plato para ver el bolo.'**
  String get calcNoFoodsMessage;

  /// No description provided for @calcNoMealTypeMessage.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el tipo de comida para calcular el bolo.'**
  String get calcNoMealTypeMessage;

  /// No description provided for @calcCalculating.
  ///
  /// In es, this message translates to:
  /// **'Calculando...'**
  String get calcCalculating;

  /// No description provided for @calcConfigureMessage.
  ///
  /// In es, this message translates to:
  /// **'Configura tus ajustes de insulina para ver el bolo recomendado.'**
  String get calcConfigureMessage;

  /// No description provided for @calcConfigureButton.
  ///
  /// In es, this message translates to:
  /// **'Configurar'**
  String get calcConfigureButton;

  /// No description provided for @calcSaveHistory.
  ///
  /// In es, this message translates to:
  /// **'Guardar en Historial Diario'**
  String get calcSaveHistory;

  /// No description provided for @calcSaveTitle.
  ///
  /// In es, this message translates to:
  /// **'Guardar en Historial'**
  String get calcSaveTitle;

  /// No description provided for @calcSaveSuccessBolus.
  ///
  /// In es, this message translates to:
  /// **'Guardado como {mealType}. Bolo: {bolus} uds'**
  String calcSaveSuccessBolus(String mealType, String bolus);

  /// No description provided for @calcSaveSuccess.
  ///
  /// In es, this message translates to:
  /// **'Guardado como {mealType} exitosamente'**
  String calcSaveSuccess(String mealType);

  /// No description provided for @calcSaveError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar: {error}'**
  String calcSaveError(String error);

  /// No description provided for @calcUndo.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get calcUndo;

  /// SnackBar shown when an item is removed from the meal plate
  ///
  /// In es, this message translates to:
  /// **'{name} eliminado'**
  String calcItemRemoved(Object name);

  /// No description provided for @calcMustLogin.
  ///
  /// In es, this message translates to:
  /// **'Debes iniciar sesión'**
  String get calcMustLogin;

  /// No description provided for @calcGramsModeAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Tengo los gramos, calcular raciones'**
  String get calcGramsModeAccessibility;

  /// No description provided for @calcRationsModeAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Quiero comer raciones, calcular gramos'**
  String get calcRationsModeAccessibility;

  /// No description provided for @mealTypeBreakfast.
  ///
  /// In es, this message translates to:
  /// **'Desayuno'**
  String get mealTypeBreakfast;

  /// No description provided for @mealTypeMidMorning.
  ///
  /// In es, this message translates to:
  /// **'Media Mañana'**
  String get mealTypeMidMorning;

  /// No description provided for @mealTypeLunch.
  ///
  /// In es, this message translates to:
  /// **'Almuerzo'**
  String get mealTypeLunch;

  /// No description provided for @mealTypeAfternoonSnack.
  ///
  /// In es, this message translates to:
  /// **'Merienda'**
  String get mealTypeAfternoonSnack;

  /// No description provided for @mealTypeDinner.
  ///
  /// In es, this message translates to:
  /// **'Cena'**
  String get mealTypeDinner;

  /// No description provided for @mealTypeSnack.
  ///
  /// In es, this message translates to:
  /// **'Snack / Otro'**
  String get mealTypeSnack;

  /// No description provided for @historyDaily.
  ///
  /// In es, this message translates to:
  /// **'Diario'**
  String get historyDaily;

  /// No description provided for @historyWeekly.
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get historyWeekly;

  /// No description provided for @historyExportButton.
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get historyExportButton;

  /// No description provided for @historyExportAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Exportar historial a CSV'**
  String get historyExportAccessibility;

  /// No description provided for @historyPrevDay.
  ///
  /// In es, this message translates to:
  /// **'Día anterior'**
  String get historyPrevDay;

  /// No description provided for @historyNextDay.
  ///
  /// In es, this message translates to:
  /// **'Día siguiente'**
  String get historyNextDay;

  /// No description provided for @historyToday.
  ///
  /// In es, this message translates to:
  /// **'HOY'**
  String get historyToday;

  /// No description provided for @historyDailyAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Vista diaria'**
  String get historyDailyAccessibility;

  /// No description provided for @historyWeeklyAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Vista semanal'**
  String get historyWeeklyAccessibility;

  /// No description provided for @historyLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando historial'**
  String get historyLoading;

  /// No description provided for @historyErrorLoading.
  ///
  /// In es, this message translates to:
  /// **'Error: {error}'**
  String historyErrorLoading(String error);

  /// No description provided for @historyNoRecords.
  ///
  /// In es, this message translates to:
  /// **'No hay registros este día.'**
  String get historyNoRecords;

  /// No description provided for @historyMustLogin.
  ///
  /// In es, this message translates to:
  /// **'Debes iniciar sesión'**
  String get historyMustLogin;

  /// No description provided for @historyTotalRations.
  ///
  /// In es, this message translates to:
  /// **'Total Raciones'**
  String get historyTotalRations;

  /// No description provided for @historyTotalCarbs.
  ///
  /// In es, this message translates to:
  /// **'Total Carbohidratos'**
  String get historyTotalCarbs;

  /// No description provided for @historySubtotal.
  ///
  /// In es, this message translates to:
  /// **'SUBTOTAL:'**
  String get historySubtotal;

  /// No description provided for @historyRationsCarbs.
  ///
  /// In es, this message translates to:
  /// **'{rac}Raciones ({carbs}g HC)'**
  String historyRationsCarbs(String rac, String carbs);

  /// No description provided for @historyBolus.
  ///
  /// In es, this message translates to:
  /// **'BOLO:'**
  String get historyBolus;

  /// No description provided for @historyBolusUnits.
  ///
  /// In es, this message translates to:
  /// **'{bolus}uds insulina'**
  String historyBolusUnits(String bolus);

  /// No description provided for @historyDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Comida'**
  String get historyDeleteTitle;

  /// No description provided for @historyDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar este registro del historial?'**
  String get historyDeleteConfirm;

  /// No description provided for @historyDeleteButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get historyDeleteButton;

  /// No description provided for @historyCancelButton.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get historyCancelButton;

  /// No description provided for @historyDeleteSuccess.
  ///
  /// In es, this message translates to:
  /// **'Registro eliminado'**
  String get historyDeleteSuccess;

  /// No description provided for @historyDeleteTooltip.
  ///
  /// In es, this message translates to:
  /// **'Eliminar {mealType}'**
  String historyDeleteTooltip(String mealType);

  /// No description provided for @historyEditButton.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get historyEditButton;

  /// No description provided for @historyEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar entrada'**
  String get historyEditTitle;

  /// No description provided for @historyEditSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get historyEditSave;

  /// No description provided for @historyEditSuccess.
  ///
  /// In es, this message translates to:
  /// **'Entrada actualizada'**
  String get historyEditSuccess;

  /// No description provided for @historyEditGramsLabel.
  ///
  /// In es, this message translates to:
  /// **'Gramos a editar'**
  String get historyEditGramsLabel;

  /// No description provided for @historyNoData7Days.
  ///
  /// In es, this message translates to:
  /// **'No hay datos en los últimos 7 días.'**
  String get historyNoData7Days;

  /// No description provided for @historyLast7Days.
  ///
  /// In es, this message translates to:
  /// **'Últimos 7 días'**
  String get historyLast7Days;

  /// No description provided for @historyChartTooltip.
  ///
  /// In es, this message translates to:
  /// **'{day}\n{carbs}g HC'**
  String historyChartTooltip(String day, String carbs);

  /// No description provided for @historyExportEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay datos para exportar.'**
  String get historyExportEmpty;

  /// No description provided for @historyCsvHeader.
  ///
  /// In es, this message translates to:
  /// **'Fecha,Hora,Tipo de comida,Alimento,Gramos,Raciones,Carbohidratos (g)'**
  String get historyCsvHeader;

  /// No description provided for @historyShareSubject.
  ///
  /// In es, this message translates to:
  /// **'Historial Libreta Dulce'**
  String get historyShareSubject;

  /// No description provided for @historyExportError.
  ///
  /// In es, this message translates to:
  /// **'Error al exportar: {error}'**
  String historyExportError(String error);

  /// No description provided for @historyGramsFood.
  ///
  /// In es, this message translates to:
  /// **'{grams}g de {name}'**
  String historyGramsFood(String grams, String name);

  /// No description provided for @historyRacShort.
  ///
  /// In es, this message translates to:
  /// **'{rac}Rac.'**
  String historyRacShort(String rac);

  /// No description provided for @profileNotLoggedIn.
  ///
  /// In es, this message translates to:
  /// **'Sesión no iniciada'**
  String get profileNotLoggedIn;

  /// No description provided for @profilePhotoAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Foto de perfil de {name}'**
  String profilePhotoAccessibility(String name);

  /// No description provided for @profileDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get profileDefaultName;

  /// No description provided for @profileAboutTitle.
  ///
  /// In es, this message translates to:
  /// **'Sobre Libreta Dulce'**
  String get profileAboutTitle;

  /// No description provided for @profileAboutSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Hecho con cariño por y para diabéticos'**
  String get profileAboutSubtitle;

  /// No description provided for @profileAboutDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Libreta Dulce'**
  String get profileAboutDialogTitle;

  /// No description provided for @profileAboutDialogText.
  ///
  /// In es, this message translates to:
  /// **'Hola, soy un desarrollador independiente y he creado esta app para ayudar a gestionar los carbohidratos y raciones en el día a día. Si tienes sugerencias o encuentras errores, por favor compártelos.'**
  String get profileAboutDialogText;

  /// No description provided for @profileAboutDialogClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get profileAboutDialogClose;

  /// No description provided for @profileInsulinSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes de Insulina'**
  String get profileInsulinSettings;

  /// No description provided for @profileInsulinSettingsDesc.
  ///
  /// In es, this message translates to:
  /// **'Ratio, factor de corrección y glucemia objetivo'**
  String get profileInsulinSettingsDesc;

  /// No description provided for @profileLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres salir?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileLogoutCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get profileLogoutCancel;

  /// No description provided for @profileLogoutButton.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get profileLogoutButton;

  /// No description provided for @profileLogoutDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get profileLogoutDialogTitle;

  /// No description provided for @adminTitle.
  ///
  /// In es, this message translates to:
  /// **'Panel Peticiones & Global'**
  String get adminTitle;

  /// No description provided for @adminTabRequests.
  ///
  /// In es, this message translates to:
  /// **'Nuevas Peticiones'**
  String get adminTabRequests;

  /// No description provided for @adminTabGlobal.
  ///
  /// In es, this message translates to:
  /// **'Datos Globales'**
  String get adminTabGlobal;

  /// No description provided for @adminApproved.
  ///
  /// In es, this message translates to:
  /// **'Alimento aprobado y publicado'**
  String get adminApproved;

  /// No description provided for @adminRejected.
  ///
  /// In es, this message translates to:
  /// **'Petición rechazada'**
  String get adminRejected;

  /// No description provided for @adminDeleted.
  ///
  /// In es, this message translates to:
  /// **'Alimento eliminado globalmente'**
  String get adminDeleted;

  /// No description provided for @adminEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Alimento Global'**
  String get adminEditTitle;

  /// No description provided for @adminNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get adminNameLabel;

  /// No description provided for @adminCarbsLabel.
  ///
  /// In es, this message translates to:
  /// **'Hidratos por 100g'**
  String get adminCarbsLabel;

  /// No description provided for @adminCancelButton.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get adminCancelButton;

  /// No description provided for @adminSaveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get adminSaveButton;

  /// No description provided for @adminUpdated.
  ///
  /// In es, this message translates to:
  /// **'Alimento actualizado'**
  String get adminUpdated;

  /// No description provided for @adminNoRequests.
  ///
  /// In es, this message translates to:
  /// **'¡Todo al día! No hay nuevas peticiones de alimentos pendientes.'**
  String get adminNoRequests;

  /// No description provided for @adminNoName.
  ///
  /// In es, this message translates to:
  /// **'Sin nombre'**
  String get adminNoName;

  /// No description provided for @adminCarbsInfo.
  ///
  /// In es, this message translates to:
  /// **'Hidratos: {carbs}g / 100g'**
  String adminCarbsInfo(String carbs);

  /// No description provided for @adminUrlInfo.
  ///
  /// In es, this message translates to:
  /// **'Enlace/Info extra: {url}'**
  String adminUrlInfo(String url);

  /// No description provided for @adminRejectButton.
  ///
  /// In es, this message translates to:
  /// **'Rechazar'**
  String get adminRejectButton;

  /// No description provided for @adminApproveButton.
  ///
  /// In es, this message translates to:
  /// **'Aprobar'**
  String get adminApproveButton;

  /// No description provided for @adminEmptyGlobal.
  ///
  /// In es, this message translates to:
  /// **'La base global está vacía.'**
  String get adminEmptyGlobal;

  /// No description provided for @adminGlobalFood.
  ///
  /// In es, this message translates to:
  /// **'Alimento global'**
  String get adminGlobalFood;

  /// No description provided for @adminEditGlobal.
  ///
  /// In es, this message translates to:
  /// **'Editar global'**
  String get adminEditGlobal;

  /// No description provided for @adminDeleteGlobal.
  ///
  /// In es, this message translates to:
  /// **'Eliminar alimento global'**
  String get adminDeleteGlobal;

  /// No description provided for @adminDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar alimento?'**
  String get adminDeleteConfirm;

  /// No description provided for @adminDeleteWarning.
  ///
  /// In es, this message translates to:
  /// **'Esto lo borrará de la base pública. Los usuarios no podrán buscarlo más.'**
  String get adminDeleteWarning;

  /// No description provided for @adminDeleteButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get adminDeleteButton;

  /// No description provided for @adminLoadingRequests.
  ///
  /// In es, this message translates to:
  /// **'Cargando peticiones'**
  String get adminLoadingRequests;

  /// No description provided for @globalSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar en base global...'**
  String get globalSearch;

  /// No description provided for @globalLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando alimentos globales'**
  String get globalLoading;

  /// No description provided for @globalNoResults.
  ///
  /// In es, this message translates to:
  /// **'No hay alimentos o no se encontraron.'**
  String get globalNoResults;

  /// No description provided for @globalGlobalFood.
  ///
  /// In es, this message translates to:
  /// **'Alimento global'**
  String get globalGlobalFood;

  /// No description provided for @globalCopyToMyFoods.
  ///
  /// In es, this message translates to:
  /// **'Copiar a Mis Alimentos'**
  String get globalCopyToMyFoods;

  /// No description provided for @globalSuggestProduct.
  ///
  /// In es, this message translates to:
  /// **'Sugerir Producto'**
  String get globalSuggestProduct;

  /// No description provided for @globalScanning.
  ///
  /// In es, this message translates to:
  /// **'Buscando en OpenFoodFacts...'**
  String get globalScanning;

  /// No description provided for @globalFound.
  ///
  /// In es, this message translates to:
  /// **'¡Alimento encontrado!'**
  String get globalFound;

  /// No description provided for @globalNotFound.
  ///
  /// In es, this message translates to:
  /// **'Producto no encontrado'**
  String get globalNotFound;

  /// No description provided for @globalRequestTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo alimento'**
  String get globalRequestTitle;

  /// No description provided for @globalRequestDesc.
  ///
  /// In es, this message translates to:
  /// **'Tu petición será revisada por un humano antes de añadirse a la base global.'**
  String get globalRequestDesc;

  /// No description provided for @globalRequestName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del producto'**
  String get globalRequestName;

  /// No description provided for @globalRequestBrand.
  ///
  /// In es, this message translates to:
  /// **'Marca o Descripción'**
  String get globalRequestBrand;

  /// No description provided for @globalRequestCarbs.
  ///
  /// In es, this message translates to:
  /// **'Hidratos por 100g'**
  String get globalRequestCarbs;

  /// No description provided for @globalRequestUrl.
  ///
  /// In es, this message translates to:
  /// **'Enlace al producto (Opcional)'**
  String get globalRequestUrl;

  /// No description provided for @globalRequestCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get globalRequestCancel;

  /// No description provided for @globalRequestSent.
  ///
  /// In es, this message translates to:
  /// **'¡Petición enviada. Gracias!'**
  String get globalRequestSent;

  /// No description provided for @globalRequestSend.
  ///
  /// In es, this message translates to:
  /// **'Enviar Petición'**
  String get globalRequestSend;

  /// No description provided for @globalAddedToMyFoods.
  ///
  /// In es, this message translates to:
  /// **'{name} añadido a tus alimentos'**
  String globalAddedToMyFoods(String name);

  /// No description provided for @globalScanTooltip.
  ///
  /// In es, this message translates to:
  /// **'Escanear código'**
  String get globalScanTooltip;

  /// No description provided for @globalNotFoundDB.
  ///
  /// In es, this message translates to:
  /// **'Producto no encontrado en la base de datos'**
  String get globalNotFoundDB;

  /// No description provided for @globalConnectionError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión'**
  String get globalConnectionError;

  /// No description provided for @globalErrorFirebase.
  ///
  /// In es, this message translates to:
  /// **'Error de Firebase: {error}'**
  String globalErrorFirebase(String error);

  /// No description provided for @serviceError.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error. Inténtalo de nuevo.'**
  String get serviceError;

  /// No description provided for @foodsAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Añadir alimento'**
  String get foodsAddTitle;

  /// No description provided for @foodsScanTooltip.
  ///
  /// In es, this message translates to:
  /// **'Escanear código'**
  String get foodsScanTooltip;

  /// No description provided for @foodsNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre (ej. Manzana)'**
  String get foodsNameLabel;

  /// No description provided for @foodsBrandLabel.
  ///
  /// In es, this message translates to:
  /// **'Marca o Descr. (Opcional)'**
  String get foodsBrandLabel;

  /// No description provided for @foodsCarbsLabel.
  ///
  /// In es, this message translates to:
  /// **'Carbohidratos por 100g *'**
  String get foodsCarbsLabel;

  /// No description provided for @foodsCarbsSuffix.
  ///
  /// In es, this message translates to:
  /// **'g'**
  String get foodsCarbsSuffix;

  /// No description provided for @foodsKcalLabel.
  ///
  /// In es, this message translates to:
  /// **'Kcal'**
  String get foodsKcalLabel;

  /// No description provided for @foodsProteinLabel.
  ///
  /// In es, this message translates to:
  /// **'Prot.'**
  String get foodsProteinLabel;

  /// No description provided for @foodsFatLabel.
  ///
  /// In es, this message translates to:
  /// **'Grasas'**
  String get foodsFatLabel;

  /// No description provided for @foodsCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get foodsCancel;

  /// No description provided for @foodsSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get foodsSave;

  /// No description provided for @foodsNameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre del alimento es obligatorio.'**
  String get foodsNameRequired;

  /// No description provided for @foodsCarbsRequired.
  ///
  /// In es, this message translates to:
  /// **'Los carbohidratos por 100g son obligatorios.'**
  String get foodsCarbsRequired;

  /// No description provided for @foodsCarbsInvalid.
  ///
  /// In es, this message translates to:
  /// **'El valor de carbohidratos no es un número válido.'**
  String get foodsCarbsInvalid;

  /// No description provided for @foodsSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar alimento...'**
  String get foodsSearch;

  /// No description provided for @foodsMustLogin.
  ///
  /// In es, this message translates to:
  /// **'Debes iniciar sesión'**
  String get foodsMustLogin;

  /// No description provided for @foodsLoadingError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar la base de datos.'**
  String get foodsLoadingError;

  /// No description provided for @foodsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes alimentos guardados.\n¡Añade el primero!'**
  String get foodsEmpty;

  /// No description provided for @foodsDeleteConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar \"{name}\"?'**
  String foodsDeleteConfirm(String name);

  /// No description provided for @foodsAddToFavorites.
  ///
  /// In es, this message translates to:
  /// **'Marcar como favorito'**
  String get foodsAddToFavorites;

  /// No description provided for @foodsRemoveFromFavorites.
  ///
  /// In es, this message translates to:
  /// **'Quitar de favoritos'**
  String get foodsRemoveFromFavorites;

  /// No description provided for @foodsDeleteTooltip.
  ///
  /// In es, this message translates to:
  /// **'Eliminar {name}'**
  String foodsDeleteTooltip(String name);

  /// No description provided for @foodsDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Valores por cada 100g:'**
  String get foodsDetailTitle;

  /// No description provided for @foodsDetailCarbs.
  ///
  /// In es, this message translates to:
  /// **'Carbohidratos: {value}g'**
  String foodsDetailCarbs(String value);

  /// No description provided for @foodsDetailCalories.
  ///
  /// In es, this message translates to:
  /// **'Calorías: {value}kcal'**
  String foodsDetailCalories(String value);

  /// No description provided for @foodsDetailProtein.
  ///
  /// In es, this message translates to:
  /// **'Proteínas: {value}g'**
  String foodsDetailProtein(String value);

  /// No description provided for @foodsDetailFat.
  ///
  /// In es, this message translates to:
  /// **'Grasas: {value}g'**
  String foodsDetailFat(String value);

  /// No description provided for @foodsDetailClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get foodsDetailClose;

  /// No description provided for @foodsNewFood.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Alimento'**
  String get foodsNewFood;

  /// No description provided for @foodsFavoriteAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Favorito'**
  String get foodsFavoriteAccessibility;

  /// No description provided for @foodsFoodAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Alimento'**
  String get foodsFoodAccessibility;

  /// No description provided for @foodsSearchAccessibility.
  ///
  /// In es, this message translates to:
  /// **'Alimento global'**
  String get foodsSearchAccessibility;

  /// No description provided for @insulinTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes de Insulina'**
  String get insulinTitle;

  /// No description provided for @insulinDesc.
  ///
  /// In es, this message translates to:
  /// **'Estos valores son personales y privados. Configurarlos permite a la app calcular el bolo de insulina recomendado.'**
  String get insulinDesc;

  /// No description provided for @insulinRatioTitle.
  ///
  /// In es, this message translates to:
  /// **'Ratio de insulina (unidades por ración)'**
  String get insulinRatioTitle;

  /// No description provided for @insulinRatioBase.
  ///
  /// In es, this message translates to:
  /// **'Ratio base *'**
  String get insulinRatioBase;

  /// No description provided for @insulinRatioHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 1.5'**
  String get insulinRatioHint;

  /// No description provided for @insulinRatioSuffix.
  ///
  /// In es, this message translates to:
  /// **'uds / ración'**
  String get insulinRatioSuffix;

  /// No description provided for @insulinRatioRequired.
  ///
  /// In es, this message translates to:
  /// **'El ratio base es obligatorio'**
  String get insulinRatioRequired;

  /// No description provided for @insulinInvalidNumber.
  ///
  /// In es, this message translates to:
  /// **'Introduce un número válido'**
  String get insulinInvalidNumber;

  /// No description provided for @insulinMealRatios.
  ///
  /// In es, this message translates to:
  /// **'Ratios específicos por comida (opcional)'**
  String get insulinMealRatios;

  /// No description provided for @insulinFactorTitle.
  ///
  /// In es, this message translates to:
  /// **'Factor de corrección'**
  String get insulinFactorTitle;

  /// No description provided for @insulinFactorLabel.
  ///
  /// In es, this message translates to:
  /// **'Factor de corrección *'**
  String get insulinFactorLabel;

  /// No description provided for @insulinFactorHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 40'**
  String get insulinFactorHint;

  /// No description provided for @insulinFactorSuffix.
  ///
  /// In es, this message translates to:
  /// **'mg/dL por ud'**
  String get insulinFactorSuffix;

  /// No description provided for @insulinFactorRequired.
  ///
  /// In es, this message translates to:
  /// **'El factor de corrección es obligatorio'**
  String get insulinFactorRequired;

  /// No description provided for @insulinMustBePositive.
  ///
  /// In es, this message translates to:
  /// **'Debe ser mayor que 0'**
  String get insulinMustBePositive;

  /// No description provided for @insulinGlucoseTargetTitle.
  ///
  /// In es, this message translates to:
  /// **'Glucemia objetivo *'**
  String get insulinGlucoseTargetTitle;

  /// No description provided for @insulinGlucoseTargetLabel.
  ///
  /// In es, this message translates to:
  /// **'Glucemia objetivo *'**
  String get insulinGlucoseTargetLabel;

  /// No description provided for @insulinGlucoseTargetHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: 100'**
  String get insulinGlucoseTargetHint;

  /// No description provided for @insulinGlucoseTargetSuffix.
  ///
  /// In es, this message translates to:
  /// **'mg/dL'**
  String get insulinGlucoseTargetSuffix;

  /// No description provided for @insulinGlucoseTargetRequired.
  ///
  /// In es, this message translates to:
  /// **'La glucemia objetivo es obligatoria'**
  String get insulinGlucoseTargetRequired;

  /// No description provided for @insulinHalfUnits.
  ///
  /// In es, this message translates to:
  /// **'Pluma con medias unidades'**
  String get insulinHalfUnits;

  /// No description provided for @insulinHalfUnitsDesc.
  ///
  /// In es, this message translates to:
  /// **'Permite dosis de 0.5 en 0.5 unidades'**
  String get insulinHalfUnitsDesc;

  /// No description provided for @insulinRoundDown.
  ///
  /// In es, this message translates to:
  /// **'Redondear bolo hacia abajo'**
  String get insulinRoundDown;

  /// No description provided for @insulinRoundDownDesc.
  ///
  /// In es, this message translates to:
  /// **'Trunca el bolo en lugar de redondear al más cercano. Útil si dosificas por rangos (ej: 1 ud por cada 50 mg/dL)'**
  String get insulinRoundDownDesc;

  /// No description provided for @insulinSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get insulinSaving;

  /// No description provided for @insulinSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar Ajustes'**
  String get insulinSave;

  /// No description provided for @insulinSaved.
  ///
  /// In es, this message translates to:
  /// **'Ajustes de insulina guardados'**
  String get insulinSaved;

  /// No description provided for @insulinOptionalHint.
  ///
  /// In es, this message translates to:
  /// **'Si no pones nada, usa el ratio base'**
  String get insulinOptionalHint;

  /// No description provided for @foodSearchTitle.
  ///
  /// In es, this message translates to:
  /// **'Buscar Alimento'**
  String get foodSearchTitle;

  /// No description provided for @foodSearchClose.
  ///
  /// In es, this message translates to:
  /// **'Cerrar búsqueda'**
  String get foodSearchClose;

  /// No description provided for @foodSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Manzana, pan, arroz...'**
  String get foodSearchHint;

  /// No description provided for @foodSearchEmptyList.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes alimentos en tu lista.'**
  String get foodSearchEmptyList;

  /// No description provided for @foodSearchNoResults.
  ///
  /// In es, this message translates to:
  /// **'No hay resultados para \"{query}\"'**
  String foodSearchNoResults(String query);

  /// No description provided for @barcodeTitle.
  ///
  /// In es, this message translates to:
  /// **'Escanea el código de barras'**
  String get barcodeTitle;

  /// No description provided for @barcodeScannedFood.
  ///
  /// In es, this message translates to:
  /// **'Alimento escaneado'**
  String get barcodeScannedFood;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Confirmar eliminación'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get confirmDeleteCancel;

  /// No description provided for @confirmDeleteButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get confirmDeleteButton;

  /// Title for the update available dialog
  ///
  /// In es, this message translates to:
  /// **'Actualización disponible'**
  String get updateAvailable;

  /// No description provided for @updateVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión {version}'**
  String updateVersion(String version);

  /// No description provided for @updateLater.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get updateLater;

  /// No description provided for @updateDownload.
  ///
  /// In es, this message translates to:
  /// **'Descargar'**
  String get updateDownload;

  /// No description provided for @updateDownloading.
  ///
  /// In es, this message translates to:
  /// **'Descargando actualización...'**
  String get updateDownloading;

  /// No description provided for @updateError.
  ///
  /// In es, this message translates to:
  /// **'Error al descargar. Visita github.com/PokeSer/libretadulce/releases'**
  String get updateError;

  /// No description provided for @updateWhatIsNew.
  ///
  /// In es, this message translates to:
  /// **'Novedades'**
  String get updateWhatIsNew;

  /// No description provided for @profileThemeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tema de la app'**
  String get profileThemeLabel;

  /// No description provided for @profileThemeSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get profileThemeSystem;

  /// No description provided for @profileThemeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get profileThemeDark;

  /// No description provided for @profileSettingsSectionApp.
  ///
  /// In es, this message translates to:
  /// **'Aplicación'**
  String get profileSettingsSectionApp;

  /// No description provided for @profileSettingsSectionHealth.
  ///
  /// In es, this message translates to:
  /// **'Salud'**
  String get profileSettingsSectionHealth;

  /// No description provided for @profileSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get profileSettings;

  /// No description provided for @insulinGlucoseUnit.
  ///
  /// In es, this message translates to:
  /// **'Unidad de glucemia'**
  String get insulinGlucoseUnit;

  /// No description provided for @insulinGlucoseUnitDesc.
  ///
  /// In es, this message translates to:
  /// **'Alternar entre mg/dL y mmol/L'**
  String get insulinGlucoseUnitDesc;

  /// No description provided for @insulinGlucoseUnitLabel.
  ///
  /// In es, this message translates to:
  /// **'Usar mmol/L en lugar de mg/dL'**
  String get insulinGlucoseUnitLabel;

  /// No description provided for @calcTabGrams.
  ///
  /// In es, this message translates to:
  /// **'Gramos'**
  String get calcTabGrams;

  /// No description provided for @calcTabRations.
  ///
  /// In es, this message translates to:
  /// **'Raciones'**
  String get calcTabRations;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pl',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
