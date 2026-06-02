// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'App wird geladen';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Dein persÃ¶nlicher Assistent fÃ¼r die tÃ¤gliche Erfassung von Kohlenhydraten und Rationen.';

  @override
  String get loginButtonGoogle => 'Mit Google anmelden';

  @override
  String get loginIniciandoSesion => 'Anmeldung lÃ¤uft';

  @override
  String get loginPrivacyText =>
      'Deine Gesundheitsdaten sind geschÃ¼tzt\nund nur mit deinem persÃ¶nlichen Konto verknÃ¼pft.';

  @override
  String get navCalculator => 'Rechner';

  @override
  String get navFoods => 'Lebensmittel';

  @override
  String get navGlobal => 'Global';

  @override
  String get navHistory => 'Verlauf';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAdminTooltip => 'Globale Verwaltung';

  @override
  String get calcTitle => 'Rechner & Teller';

  @override
  String get calcGramsMode => 'Ich habe die Gramm\n(Ich will Rationen)';

  @override
  String get calcRationsMode => 'Ich will Rationen\n(Nenne mir die Gramm)';

  @override
  String get calcSearchFood => 'Tippen, um Lebensmittel zu suchen...';

  @override
  String get calcSearchFoodAccessibility => 'Lebensmittel suchen';

  @override
  String get calcFoodAccessibility => 'Lebensmittel';

  @override
  String calcSelectedFood(String foodName) {
    return 'AusgewÃ¤hltes Lebensmittel: $foodName. Tippen zum Ã„ndern.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g KH / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Schnellfavoriten';

  @override
  String get calcInputGramsLabel => 'Menge in Gramm';

  @override
  String get calcInputRationsLabel => 'Rationen zum Essen';

  @override
  String get calcInputGramsSuffix => 'Gramm';

  @override
  String get calcInputRationsSuffix => 'Rationen';

  @override
  String get calcResultTitle => 'ERGEBNIS';

  @override
  String get calcResultInverseTitle => 'ABZUWIEBEN';

  @override
  String get calcGramsHC => 'KH (g)';

  @override
  String get calcRations => 'Rationen';

  @override
  String calcOfFood(String foodName) {
    return 'von $foodName';
  }

  @override
  String get calcAddToPlate => 'Zum Teller hinzufÃ¼gen';

  @override
  String get calcMyPlate => 'Mein aktueller Teller';

  @override
  String get calcClear => 'Leeren';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g verzehrt';
  }

  @override
  String calcRacShort(String rac) {
    return '$rac Rat.';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g KH';
  }

  @override
  String get calcDeleteFromPlate => 'Vom Teller entfernen';

  @override
  String get calcTotalPlate => 'TELLER GESAMT:';

  @override
  String calcTotalRac(String rac) {
    return '$rac Rat.';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g KH';
  }

  @override
  String get calcMealTypeLabel => 'Mahlzeittyp:';

  @override
  String get calcTimeLabel => 'Uhrzeit';

  @override
  String get calcDateLabel => 'Datum';

  @override
  String get calcBolusTitle => 'Insulin-Bolus';

  @override
  String get calcGlucoseLabel => 'Aktueller Blutzucker (optional)';

  @override
  String get calcGlucoseHint => 'Z.B.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Mahlzeiten-Bolus';

  @override
  String get calcBolusCorrection => 'Korrektur';

  @override
  String get calcBolusTotal => 'Gesamt';

  @override
  String get calcBolusUnitSuffix => 'Einheiten';

  @override
  String get calcNoFoodsMessage =>
      'FÃ¼ge Lebensmittel zum Teller hinzu, um den Bolus zu sehen.';

  @override
  String get calcNoMealTypeMessage =>
      'WÃ¤hle den Mahlzeittyp, um den Bolus zu berechnen.';

  @override
  String get calcCalculating => 'Berechne...';

  @override
  String get calcConfigureMessage =>
      'Richte deine Insulineinstellungen ein, um den empfohlenen Bolus zu sehen.';

  @override
  String get calcConfigureButton => 'Einrichten';

  @override
  String get calcSaveHistory => 'Im Tagesverlauf speichern';

  @override
  String get calcSaveTitle => 'Im Verlauf speichern';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Gespeichert als $mealType. Bolus: $bolus Einheiten';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Erfolgreich als $mealType gespeichert';
  }

  @override
  String calcSaveError(String error) {
    return 'Fehler beim Speichern: $error';
  }

  @override
  String get calcUndo => 'RÃ¼ckgÃ¤ngig';

  @override
  String calcItemRemoved(Object name) {
    return '$name entfernt';
  }

  @override
  String get calcMustLogin => 'Du musst dich anmelden';

  @override
  String get calcGramsModeAccessibility =>
      'Ich habe die Gramm, berechne Rationen';

  @override
  String get calcRationsModeAccessibility =>
      'Ich will Rationen essen, berechne Gramm';

  @override
  String get mealTypeBreakfast => 'FrÃ¼hstÃ¼ck';

  @override
  String get mealTypeMidMorning => 'Zwischenmahlzeit';

  @override
  String get mealTypeLunch => 'Mittagessen';

  @override
  String get mealTypeAfternoonSnack => 'Nachmittagssnack';

  @override
  String get mealTypeDinner => 'Abendessen';

  @override
  String get mealTypeSnack => 'Snack / Sonstiges';

  @override
  String get historyDaily => 'TÃ¤glich';

  @override
  String get historyWeekly => 'WÃ¶chentlich';

  @override
  String get historyExportButton => 'Exportieren';

  @override
  String get historyExportAccessibility => 'Verlauf als CSV exportieren';

  @override
  String get historyPrevDay => 'Vorheriger Tag';

  @override
  String get historyNextDay => 'NÃ¤chster Tag';

  @override
  String get historyToday => 'HEUTE';

  @override
  String get historyDailyAccessibility => 'Tagesansicht';

  @override
  String get historyWeeklyAccessibility => 'Wochenansicht';

  @override
  String get historyLoading => 'Verlauf wird geladen';

  @override
  String historyErrorLoading(String error) {
    return 'Fehler: $error';
  }

  @override
  String get historyNoRecords => 'Keine EintrÃ¤ge fÃ¼r diesen Tag.';

  @override
  String get historyMustLogin => 'Du musst dich anmelden';

  @override
  String get historyTotalRations => 'Gesamtrationen';

  @override
  String get historyTotalCarbs => 'Gesamt-KH';

  @override
  String get historySubtotal => 'ZWISCHENSUMME:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac Rationen (${carbs}g KH)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus Einheiten Insulin';
  }

  @override
  String get historyDeleteTitle => 'Mahlzeit lÃ¶schen';

  @override
  String get historyDeleteConfirm =>
      'Bist du sicher, dass du diesen Eintrag aus dem Verlauf lÃ¶schen mÃ¶chtest?';

  @override
  String get historyDeleteButton => 'LÃ¶schen';

  @override
  String get historyCancelButton => 'Abbrechen';

  @override
  String get historyDeleteSuccess => 'Eintrag gelÃ¶scht';

  @override
  String historyDeleteTooltip(String mealType) {
    return '$mealType lÃ¶schen';
  }

  @override
  String get historyEditButton => 'Bearbeiten';

  @override
  String get historyEditTitle => 'Eintrag bearbeiten';

  @override
  String get historyEditSave => 'Ã„nderungen speichern';

  @override
  String get historyEditSuccess => 'Eintrag aktualisiert';

  @override
  String get historyEditGramsLabel => 'Gramm';

  @override
  String get historyNoData7Days => 'Keine Daten in den letzten 7 Tagen.';

  @override
  String get historyLast7Days => 'Letzte 7 Tage';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g KH';
  }

  @override
  String get historyExportEmpty => 'Keine Daten zum Exportieren.';

  @override
  String get historyCsvHeader =>
      'Datum,Uhrzeit,Mahlzeittyp,Lebensmittel,Gramm,Rationen,KH (g)';

  @override
  String get historyShareSubject => 'Libreta Dulce Verlauf';

  @override
  String historyExportError(String error) {
    return 'Fehler beim Exportieren: $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g $name';
  }

  @override
  String historyRacShort(String rac) {
    return '$rac Rat.';
  }

  @override
  String get profileNotLoggedIn => 'Nicht angemeldet';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Profilbild von $name';
  }

  @override
  String get profileDefaultName => 'Benutzer';

  @override
  String get profileAboutTitle => 'Ãœber Libreta Dulce';

  @override
  String get profileAboutSubtitle =>
      'Mit Liebe von und fÃ¼r Diabetiker gemacht';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Hallo, ich bin ein unabhÃ¤ngiger Entwickler und habe diese App erstellt, um bei der tÃ¤glichen Verwaltung von Kohlenhydraten und Rationen zu helfen. Wenn du VorschlÃ¤ge hast oder Fehler findest, teile sie bitte mit.';

  @override
  String get profileAboutDialogClose => 'SchlieÃŸen';

  @override
  String get profileInsulinSettings => 'Insulineinstellungen';

  @override
  String get profileInsulinSettingsDesc =>
      'VerhÃ¤ltnis, Korrekturfaktor und Glukosezielwert';

  @override
  String get profileLogout => 'Abmelden';

  @override
  String get profileLogoutConfirm =>
      'Bist du sicher, dass du dich abmelden mÃ¶chtest?';

  @override
  String get profileLogoutCancel => 'Abbrechen';

  @override
  String get profileLogoutButton => 'Abmelden';

  @override
  String get profileLogoutDialogTitle => 'Abmelden';

  @override
  String get adminTitle => 'Anfragen & Globales Panel';

  @override
  String get adminTabRequests => 'Neue Anfragen';

  @override
  String get adminTabGlobal => 'Globale Daten';

  @override
  String get adminApproved => 'Lebensmittel genehmigt und verÃ¶ffentlicht';

  @override
  String get adminRejected => 'Anfrage abgelehnt';

  @override
  String get adminDeleted => 'Lebensmittel global gelÃ¶scht';

  @override
  String get adminEditTitle => 'Globales Lebensmittel bearbeiten';

  @override
  String get adminNameLabel => 'Name';

  @override
  String get adminCarbsLabel => 'KH pro 100g';

  @override
  String get adminCancelButton => 'Abbrechen';

  @override
  String get adminSaveButton => 'Speichern';

  @override
  String get adminUpdated => 'Lebensmittel aktualisiert';

  @override
  String get adminNoRequests =>
      'Alles klar! Keine neuen ausstehenden Anfragen.';

  @override
  String get adminNoName => 'Kein Name';

  @override
  String adminCarbsInfo(String carbs) {
    return 'KH: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Link/Zusatzinfos: $url';
  }

  @override
  String get adminRejectButton => 'Ablehnen';

  @override
  String get adminApproveButton => 'Genehmigen';

  @override
  String get adminEmptyGlobal => 'Die globale Datenbank ist leer.';

  @override
  String get adminGlobalFood => 'Globales Lebensmittel';

  @override
  String get adminEditGlobal => 'Global bearbeiten';

  @override
  String get adminDeleteGlobal => 'Globales Lebensmittel lÃ¶schen';

  @override
  String get adminDeleteConfirm => 'Lebensmittel lÃ¶schen?';

  @override
  String get adminDeleteWarning =>
      'Dies entfernt es aus der Ã¶ffentlichen Datenbank. Benutzer werden es nicht mehr suchen kÃ¶nnen.';

  @override
  String get adminDeleteButton => 'LÃ¶schen';

  @override
  String get adminLoadingRequests => 'Anfragen werden geladen';

  @override
  String get globalSearch => 'Globale Datenbank durchsuchen...';

  @override
  String get globalLoading => 'Globale Lebensmittel werden geladen';

  @override
  String get globalNoResults => 'Keine Lebensmittel gefunden.';

  @override
  String get globalGlobalFood => 'Globales Lebensmittel';

  @override
  String get globalCopyToMyFoods => 'Zu meinen Lebensmitteln kopieren';

  @override
  String get globalSuggestProduct => 'Produkt vorschlagen';

  @override
  String get globalScanning => 'Durchsuche OpenFoodFacts...';

  @override
  String get globalFound => 'Lebensmittel gefunden!';

  @override
  String get globalNotFound => 'Produkt nicht gefunden';

  @override
  String get globalRequestTitle => 'Neues Lebensmittel';

  @override
  String get globalRequestDesc =>
      'Deine Anfrage wird von einem Menschen Ã¼berprÃ¼ft, bevor sie der globalen Datenbank hinzugefÃ¼gt wird.';

  @override
  String get globalRequestName => 'Produktname';

  @override
  String get globalRequestBrand => 'Marke oder Beschreibung';

  @override
  String get globalRequestCarbs => 'KH pro 100g';

  @override
  String get globalRequestUrl => 'Produktlink (Optional)';

  @override
  String get globalRequestCancel => 'Abbrechen';

  @override
  String get globalRequestSent => 'Anfrage gesendet. Vielen Dank!';

  @override
  String get globalRequestSend => 'Anfrage senden';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name zu deinen Lebensmitteln hinzugefÃ¼gt';
  }

  @override
  String get globalScanTooltip => 'Barcode scannen';

  @override
  String get globalNotFoundDB => 'Produkt nicht in der Datenbank gefunden';

  @override
  String get globalConnectionError => 'Verbindungsfehler';

  @override
  String globalErrorFirebase(String error) {
    return 'Firebase-Fehler: $error';
  }

  @override
  String get foodsAddTitle => 'Lebensmittel hinzufÃ¼gen';

  @override
  String get foodsScanTooltip => 'Barcode scannen';

  @override
  String get foodsNameLabel => 'Name (z.B. Apfel)';

  @override
  String get foodsBrandLabel => 'Marke oder Beschr. (Optional)';

  @override
  String get foodsCarbsLabel => 'KH pro 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'Protein';

  @override
  String get foodsFatLabel => 'Fett';

  @override
  String get foodsCancel => 'Abbrechen';

  @override
  String get foodsSave => 'Speichern';

  @override
  String get foodsNameRequired => 'Lebensmittelname ist erforderlich.';

  @override
  String get foodsCarbsRequired => 'KH pro 100g sind erforderlich.';

  @override
  String get foodsCarbsInvalid => 'KH-Wert ist keine gÃ¼ltige Zahl.';

  @override
  String get foodsSearch => 'Lebensmittel suchen...';

  @override
  String get foodsMustLogin => 'Du musst dich anmelden';

  @override
  String get foodsLoadingError => 'Fehler beim Laden der Datenbank.';

  @override
  String get foodsEmpty =>
      'Du hast noch keine gespeicherten Lebensmittel.\nFÃ¼ge dein erstes hinzu!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Bist du sicher, dass du \"$name\" lÃ¶schen mÃ¶chtest?';
  }

  @override
  String get foodsAddToFavorites => 'Zu Favoriten hinzufÃ¼gen';

  @override
  String get foodsRemoveFromFavorites => 'Aus Favoriten entfernen';

  @override
  String foodsDeleteTooltip(String name) {
    return '$name lÃ¶schen';
  }

  @override
  String get foodsDetailTitle => 'Werte pro 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'Kohlenhydrate: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Kalorien: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'Protein: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Fett: ${value}g';
  }

  @override
  String get foodsDetailClose => 'SchlieÃŸen';

  @override
  String get foodsNewFood => 'Neues Lebensmittel';

  @override
  String get foodsFavoriteAccessibility => 'Favorit';

  @override
  String get foodsFoodAccessibility => 'Lebensmittel';

  @override
  String get foodsSearchAccessibility => 'Globales Lebensmittel';

  @override
  String get insulinTitle => 'Insulineinstellungen';

  @override
  String get insulinDesc =>
      'Diese Werte sind persÃ¶nlich und privat. Durch ihre Einrichtung kann die App den empfohlenen Insulinbolus berechnen.';

  @override
  String get insulinRatioTitle => 'InsulinverhÃ¤ltnis (Einheiten pro Ration)';

  @override
  String get insulinRatioBase => 'BasisverhÃ¤ltnis *';

  @override
  String get insulinRatioHint => 'Z.B.: 1,5';

  @override
  String get insulinRatioSuffix => 'Einheiten / Ration';

  @override
  String get insulinRatioRequired => 'BasisverhÃ¤ltnis ist erforderlich';

  @override
  String get insulinInvalidNumber => 'GÃ¼ltige Zahl eingeben';

  @override
  String get insulinMealRatios =>
      'Mahlzeitspezifische VerhÃ¤ltnisse (optional)';

  @override
  String get insulinFactorTitle => 'Korrekturfaktor';

  @override
  String get insulinFactorLabel => 'Korrekturfaktor *';

  @override
  String get insulinFactorHint => 'Z.B.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL pro Einheit';

  @override
  String get insulinFactorRequired => 'Korrekturfaktor ist erforderlich';

  @override
  String get insulinMustBePositive => 'Muss grÃ¶ÃŸer als 0 sein';

  @override
  String get insulinGlucoseTargetTitle => 'Zielglukose *';

  @override
  String get insulinGlucoseTargetLabel => 'Zielglukose *';

  @override
  String get insulinGlucoseTargetHint => 'Z.B.: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired => 'Zielglukose ist erforderlich';

  @override
  String get insulinHalfUnits => 'Halbeinheiten-Pen';

  @override
  String get insulinHalfUnitsDesc =>
      'ErmÃ¶glicht Dosierung in 0,5-Einheiten-Schritten';

  @override
  String get insulinRoundDown => 'Bolus abrunden';

  @override
  String get insulinRoundDownDesc =>
      'Schneidet den Bolus ab, anstatt auf den nÃ¤chsten Wert zu runden. NÃ¼tzlich bei bereichsbasierter Dosierung (z.B.: 1 Einheit pro 50 mg/dL)';

  @override
  String get insulinSaving => 'Wird gespeichert...';

  @override
  String get insulinSave => 'Einstellungen speichern';

  @override
  String get insulinSaved => 'Insulineinstellungen gespeichert';

  @override
  String get insulinOptionalHint =>
      'Leer lassen, um das BasisverhÃ¤ltnis zu verwenden';

  @override
  String get foodSearchTitle => 'Lebensmittel suchen';

  @override
  String get foodSearchClose => 'Suche schlieÃŸen';

  @override
  String get foodSearchHint => 'Z.B. Apfel, Brot, Reis...';

  @override
  String get foodSearchEmptyList =>
      'Du hast noch keine Lebensmittel in deiner Liste.';

  @override
  String foodSearchNoResults(String query) {
    return 'Keine Ergebnisse fÃ¼r \"$query\"';
  }

  @override
  String get barcodeTitle => 'Barcode scannen';

  @override
  String get barcodeScannedFood => 'Gescanntes Lebensmittel';

  @override
  String get confirmDeleteTitle => 'LÃ¶schung bestÃ¤tigen';

  @override
  String get confirmDeleteCancel => 'Abbrechen';

  @override
  String get confirmDeleteButton => 'LÃ¶schen';

  @override
  String get updateAvailable => 'Update verfÃ¼gbar';

  @override
  String updateVersion(String version) {
    return 'Version $version';
  }

  @override
  String get updateLater => 'SpÃ¤ter';

  @override
  String get updateDownload => 'Herunterladen';

  @override
  String get updateDownloading => 'Update wird heruntergeladen...';

  @override
  String get updateError =>
      'Download fehlgeschlagen. Besuche github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Neuigkeiten';

  @override
  String get profileThemeLabel => 'App-Design';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileThemeLight => 'Hell';

  @override
  String get profileThemeDark => 'Dunkel';

  @override
  String get profileSettingsSectionApp => 'Anwendung';

  @override
  String get profileSettingsSectionHealth => 'Gesundheit';

  @override
  String get profileSettings => 'Einstellungen';

  @override
  String get insulinGlucoseUnit => 'Blutzucker-Einheit';

  @override
  String get insulinGlucoseUnitDesc => 'Wechsel zwischen mg/dL und mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'mmol/L statt mg/dL verwenden';

  @override
  String get calcTabGrams => 'Gramm';

  @override
  String get calcTabRations => 'Rationen';
}
