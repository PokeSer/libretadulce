// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'Načítání aplikace';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Váš osobní asistent pro každodenní sledování sacharidů a výměnných jednotek.';

  @override
  String get loginButtonGoogle => 'Pokračovat přes Google';

  @override
  String get loginIniciandoSesion => 'Přihlašování';

  @override
  String get loginPrivacyText =>
      'Vaše zdravotní údaje jsou chráněny\na propojeny pouze s vaším osobním účtem.';

  @override
  String get navCalculator => 'Kalkulačka';

  @override
  String get navFoods => 'Potraviny';

  @override
  String get navGlobal => 'Globální';

  @override
  String get navHistory => 'Historie';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAdminTooltip => 'Globální správa';

  @override
  String get calcTitle => 'Kalkulačka a talíř';

  @override
  String get calcGramsMode => 'Znám gramy\n(Chci VJ)';

  @override
  String get calcRationsMode => 'Chci VJ\n(Řekni mi gramy)';

  @override
  String get calcSearchFood => 'Klepněte pro vyhledání potraviny...';

  @override
  String get calcSearchFoodAccessibility => 'Hledat potravinu';

  @override
  String get calcFoodAccessibility => 'Potravina';

  @override
  String calcSelectedFood(String foodName) {
    return 'Vybraná potravina: $foodName. Klepněte pro změnu.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g sacharidů / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Rychlé oblíbené';

  @override
  String get calcInputGramsLabel => 'Množství v gramech';

  @override
  String get calcInputRationsLabel => 'VJ ke snědení';

  @override
  String get calcInputGramsSuffix => 'gramů';

  @override
  String get calcInputRationsSuffix => 'VJ';

  @override
  String get calcResultTitle => 'VÝSLEDEK';

  @override
  String get calcResultInverseTitle => 'MUSÍTE NAVÁŽIT';

  @override
  String get calcGramsHC => 'Sacharidy (g)';

  @override
  String get calcRations => 'Výměnné jednotky';

  @override
  String calcOfFood(String foodName) {
    return 'z $foodName';
  }

  @override
  String get calcAddToPlate => 'Přidat na talíř';

  @override
  String get calcMyPlate => 'Můj aktuální talíř';

  @override
  String get calcClear => 'Vyčistit';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g snědeno';
  }

  @override
  String calcRacShort(String rac) {
    return '$rac VJ';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g sach.';
  }

  @override
  String get calcDeleteFromPlate => 'Odebrat z talíře';

  @override
  String get calcTotalPlate => 'CELKEM TALÍŘ:';

  @override
  String calcTotalRac(String rac) {
    return '$rac VJ';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g sach.';
  }

  @override
  String get calcMealTypeLabel => 'Typ jídla:';

  @override
  String get calcTimeLabel => 'Čas';

  @override
  String get calcDateLabel => 'Datum';

  @override
  String get calcBolusTitle => 'Inzulínový bolus';

  @override
  String get calcGlucoseLabel => 'Aktuální glykémie (volitelné)';

  @override
  String get calcGlucoseHint => 'Např.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Jídelní bolus';

  @override
  String get calcBolusCorrection => 'Korekce';

  @override
  String get calcBolusTotal => 'Celkem';

  @override
  String get calcBolusUnitSuffix => 'jednotek';

  @override
  String get calcNoFoodsMessage =>
      'Přidejte potraviny na talíř, aby se zobrazil bolus.';

  @override
  String get calcNoMealTypeMessage => 'Vyberte typ jídla pro výpočet bolusu.';

  @override
  String get calcCalculating => 'Výpočet...';

  @override
  String get calcConfigureMessage =>
      'Nastavte své inzulínové parametry pro zobrazení doporučeného bolusu.';

  @override
  String get calcConfigureButton => 'Nastavit';

  @override
  String get calcSaveHistory => 'Uložit do denní historie';

  @override
  String get calcSaveTitle => 'Uložit do historie';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Uloženo jako $mealType. Bolus: $bolus jedn.';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Uloženo jako $mealType úspěšně';
  }

  @override
  String calcSaveError(String error) {
    return 'Chyba při ukládání: $error';
  }

  @override
  String get calcUndo => 'Zpět';

  @override
  String calcItemRemoved(Object name) {
    return '$name odstraněno';
  }

  @override
  String get calcMustLogin => 'Musíte se přihlásit';

  @override
  String get calcGramsModeAccessibility => 'Znám gramy, spočítej VJ';

  @override
  String get calcRationsModeAccessibility => 'Chci sníst VJ, spočítej gramy';

  @override
  String calcRepeatLastMeal(String mealType) {
    return 'Opakovat poslední $mealType';
  }

  @override
  String get calcRepeatLastMealTooltip => 'Rychle vyplnit posledním jídlem';

  @override
  String get calcSaveAsTemplate => 'Uložit jako šablonu';

  @override
  String get calcTemplateNameHint => 'Např: Moje obvyklá snídaně';

  @override
  String get calcTemplateNameRequired => 'Zadejte název šablony';

  @override
  String get calcTemplateSaved => 'Šablona uložena';

  @override
  String get calcLoadTemplate => 'Načíst šablonu';

  @override
  String get calcNoTemplates => 'Žádné uložené šablony';

  @override
  String calcTemplateLoaded(String name) {
    return 'Šablona \"$name\" načtena';
  }

  @override
  String get calcDeleteTemplate => 'Smazat šablonu';

  @override
  String calcDeleteTemplateConfirm(String name) {
    return 'Smazat \"$name\"?';
  }

  @override
  String get mealTypeBreakfast => 'Snídaně';

  @override
  String get mealTypeMidMorning => 'Dopolední svačina';

  @override
  String get mealTypeLunch => 'Oběd';

  @override
  String get mealTypeAfternoonSnack => 'Odpolední svačina';

  @override
  String get mealTypeDinner => 'Večeře';

  @override
  String get mealTypeSnack => 'Svačina / Jiné';

  @override
  String get historyDaily => 'Denní';

  @override
  String get historyWeekly => 'Týdenní';

  @override
  String get historyExportButton => 'Exportovat';

  @override
  String get historyExportAccessibility => 'Exportovat historii do CSV';

  @override
  String get historyPrevDay => 'Předchozí den';

  @override
  String get historyNextDay => 'Následující den';

  @override
  String get historyToday => 'DNES';

  @override
  String get historyDailyAccessibility => 'Denní zobrazení';

  @override
  String get historyWeeklyAccessibility => 'Týdenní zobrazení';

  @override
  String get historyLoading => 'Načítání historie';

  @override
  String historyErrorLoading(String error) {
    return 'Chyba: $error';
  }

  @override
  String get historyNoRecords => 'Pro tento den nejsou žádné záznamy.';

  @override
  String get historyMustLogin => 'Musíte se přihlásit';

  @override
  String get historyTotalRations => 'Celkem VJ';

  @override
  String get historyTotalCarbs => 'Celkem sacharidů';

  @override
  String get historySubtotal => 'MEZISOUČET:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac VJ (${carbs}g sach.)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus jednotek inzulínu';
  }

  @override
  String get historyDeleteTitle => 'Smazat jídlo';

  @override
  String get historyDeleteConfirm =>
      'Opravdu chcete smazat tento záznam z historie?';

  @override
  String get historyDeleteButton => 'Smazat';

  @override
  String get historyCancelButton => 'Zrušit';

  @override
  String get historyDeleteSuccess => 'Záznam smazán';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Smazat $mealType';
  }

  @override
  String get historyEditButton => 'Upravit';

  @override
  String get historyEditTitle => 'Upravit záznam';

  @override
  String get historyEditSave => 'Uložit změny';

  @override
  String get historyEditSuccess => 'Záznam aktualizován';

  @override
  String get historyEditGramsLabel => 'Gramy';

  @override
  String get historyNoData7Days => 'Žádná data za posledních 7 dní.';

  @override
  String get historyLast7Days => 'Posledních 7 dní';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g sach.';
  }

  @override
  String get historyExportEmpty => 'Žádná data k exportu.';

  @override
  String get historyCsvHeader =>
      'Datum,Čas,Typ jídla,Potravina,Gramy,VJ,Sacharidy (g)';

  @override
  String get historyShareSubject => 'Historie Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'Chyba při exportu: $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g $name';
  }

  @override
  String historyRacShort(String rac) {
    return '$rac VJ';
  }

  @override
  String get profileNotLoggedIn => 'Nepřihlášen';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Profilová fotka uživatele $name';
  }

  @override
  String get profileDefaultName => 'Uživatel';

  @override
  String get profileAboutTitle => 'O aplikaci Libreta Dulce';

  @override
  String get profileAboutSubtitle =>
      'Vytvořeno s láskou diabetiky a pro diabetiky';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Ahoj, jsem nezávislý vývojář a vytvořil jsem tuto aplikaci, abych usnadnil každodenní správu sacharidů a výměnných jednotek. Pokud máte návrhy nebo najdete chyby, podělte se o ně prosím.';

  @override
  String get profileAboutDialogClose => 'Zavřít';

  @override
  String get profileInsulinSettings => 'Nastavení inzulínu';

  @override
  String get profileInsulinSettingsDesc =>
      'Poměr, korekční faktor a cílová glykémie';

  @override
  String get profileLogout => 'Odhlásit se';

  @override
  String get profileLogoutConfirm => 'Opravdu se chcete odhlásit?';

  @override
  String get profileLogoutCancel => 'Zrušit';

  @override
  String get profileLogoutButton => 'Odhlásit se';

  @override
  String get profileLogoutDialogTitle => 'Odhlásit se';

  @override
  String get adminTitle => 'Žádosti a globální panel';

  @override
  String get adminTabRequests => 'Nové žádosti';

  @override
  String get adminTabGlobal => 'Globální data';

  @override
  String get adminApproved => 'Potravina schválena a publikována';

  @override
  String get adminRejected => 'Žádost zamítnuta';

  @override
  String get adminDeleted => 'Potravina globálně smazána';

  @override
  String get adminEditTitle => 'Upravit globální potravinu';

  @override
  String get adminNameLabel => 'Název';

  @override
  String get adminCarbsLabel => 'Sacharidy na 100g';

  @override
  String get adminCancelButton => 'Zrušit';

  @override
  String get adminSaveButton => 'Uložit';

  @override
  String get adminUpdated => 'Potravina aktualizována';

  @override
  String get adminNoRequests => 'Vše čisté! Žádné nové žádosti o potraviny.';

  @override
  String get adminNoName => 'Bez názvu';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Sacharidy: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Odkaz/Další info: $url';
  }

  @override
  String get adminRejectButton => 'Zamítnout';

  @override
  String get adminApproveButton => 'Schválit';

  @override
  String get adminEmptyGlobal => 'Globální databáze je prázdná.';

  @override
  String get adminGlobalFood => 'Globální potravina';

  @override
  String get adminEditGlobal => 'Upravit globální';

  @override
  String get adminDeleteGlobal => 'Smazat globální potravinu';

  @override
  String get adminDeleteConfirm => 'Smazat potravinu?';

  @override
  String get adminDeleteWarning =>
      'Tím dojde k odstranění z veřejné databáze. Uživatelé již nebudou moci tuto potravinu vyhledat.';

  @override
  String get adminDeleteButton => 'Smazat';

  @override
  String get adminLoadingRequests => 'Načítání žádostí';

  @override
  String get globalSearch => 'Hledat v globální databázi...';

  @override
  String get globalLoading => 'Načítání globálních potravin';

  @override
  String get globalNoResults => 'Žádné potraviny nebo nenalezeno.';

  @override
  String get globalGlobalFood => 'Globální potravina';

  @override
  String get globalCopyToMyFoods => 'Kopírovat do Mých potravin';

  @override
  String get globalSuggestProduct => 'Navrhnout produkt';

  @override
  String get globalScanning => 'Vyhledávání v OpenFoodFacts...';

  @override
  String get globalFound => 'Potravina nalezena!';

  @override
  String get globalNotFound => 'Produkt nenalezen';

  @override
  String get globalRequestTitle => 'Nová potravina';

  @override
  String get globalRequestDesc =>
      'Vaše žádost bude před přidáním do globální databáze zkontrolována člověkem.';

  @override
  String get globalRequestName => 'Název produktu';

  @override
  String get globalRequestBrand => 'Značka nebo popis';

  @override
  String get globalRequestCarbs => 'Sacharidy na 100g';

  @override
  String get globalRequestUrl => 'Odkaz na produkt (volitelné)';

  @override
  String get globalRequestCancel => 'Zrušit';

  @override
  String get globalRequestSent => 'Žádost odeslána. Děkujeme!';

  @override
  String get globalRequestSend => 'Odeslat žádost';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name přidáno do vašich potravin';
  }

  @override
  String get globalScanTooltip => 'Naskenovat čárový kód';

  @override
  String get globalNotFoundDB => 'Produkt nenalezen v databázi';

  @override
  String get globalConnectionError => 'Chyba připojení';

  @override
  String globalErrorFirebase(String error) {
    return 'Chyba Firebase: $error';
  }

  @override
  String get serviceError => 'Došlo k chybě. Zkuste to prosím znovu.';

  @override
  String get foodsAddTitle => 'Přidat potravinu';

  @override
  String get foodsScanTooltip => 'Naskenovat čárový kód';

  @override
  String get foodsNameLabel => 'Název (např. Jablko)';

  @override
  String get foodsBrandLabel => 'Značka nebo popis (volitelné)';

  @override
  String get foodsCarbsLabel => 'Sacharidy na 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'Bílkoviny';

  @override
  String get foodsFatLabel => 'Tuky';

  @override
  String get foodsCancel => 'Zrušit';

  @override
  String get foodsSave => 'Uložit';

  @override
  String get foodsNameRequired => 'Název potraviny je povinný.';

  @override
  String get foodsCarbsRequired => 'Sacharidy na 100g jsou povinné.';

  @override
  String get foodsCarbsInvalid => 'Hodnota sacharidů není platné číslo.';

  @override
  String get foodsSearch => 'Hledat potravinu...';

  @override
  String get foodsMustLogin => 'Musíte se přihlásit';

  @override
  String get foodsLoadingError => 'Chyba při načítání databáze.';

  @override
  String get foodsEmpty =>
      'Zatím nemáte žádné uložené potraviny.\nPřidejte svou první!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Opravdu chcete smazat \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'Přidat do oblíbených';

  @override
  String get foodsRemoveFromFavorites => 'Odebrat z oblíbených';

  @override
  String foodsDeleteTooltip(String name) {
    return 'Smazat $name';
  }

  @override
  String get foodsDetailTitle => 'Hodnoty na 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'Sacharidy: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Kalorie: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'Bílkoviny: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Tuky: ${value}g';
  }

  @override
  String get foodsDetailClose => 'Zavřít';

  @override
  String get foodsNewFood => 'Nová potravina';

  @override
  String get foodsFavoriteAccessibility => 'Oblíbená';

  @override
  String get foodsFoodAccessibility => 'Potravina';

  @override
  String get foodsSearchAccessibility => 'Globální potravina';

  @override
  String get insulinTitle => 'Nastavení inzulínu';

  @override
  String get insulinDesc =>
      'Tyto hodnoty jsou osobní a soukromé. Jejich nastavení umožňuje aplikaci vypočítat doporučený inzulínový bolus.';

  @override
  String get insulinRatioTitle => 'Inzulínový poměr (jednotky na VJ)';

  @override
  String get insulinRatioBase => 'Základní poměr *';

  @override
  String get insulinRatioHint => 'Např.: 1,5';

  @override
  String get insulinRatioSuffix => 'jedn. / VJ';

  @override
  String get insulinRatioRequired => 'Základní poměr je povinný';

  @override
  String get insulinInvalidNumber => 'Zadejte platné číslo';

  @override
  String get insulinMealRatios => 'Poměry pro jednotlivá jídla (volitelné)';

  @override
  String get insulinFactorTitle => 'Korekční faktor';

  @override
  String get insulinFactorLabel => 'Korekční faktor *';

  @override
  String get insulinFactorHint => 'Např.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL na jednotku';

  @override
  String get insulinFactorRequired => 'Korekční faktor je povinný';

  @override
  String get insulinMustBePositive => 'Hodnota musí být větší než 0';

  @override
  String get insulinGlucoseTargetTitle => 'Cílová glykémie *';

  @override
  String get insulinGlucoseTargetLabel => 'Cílová glykémie *';

  @override
  String get insulinGlucoseTargetHint => 'Např.: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired => 'Cílová glykémie je povinná';

  @override
  String get insulinHalfUnits => 'Pero s dávkováním po 0,5 jedn.';

  @override
  String get insulinHalfUnitsDesc =>
      'Umožňuje dávkování s přesností na 0,5 jednotky';

  @override
  String get insulinRoundDown => 'Zaokrouhlovat bolus dolů';

  @override
  String get insulinRoundDownDesc =>
      'Ořízne bolus místo zaokrouhlení na nejbližší hodnotu. Užitečné při dávkování podle rozsahů (např. 1 jedn. na 50 mg/dL)';

  @override
  String get insulinSaving => 'Ukládání...';

  @override
  String get insulinSave => 'Uložit nastavení';

  @override
  String get insulinSaved => 'Nastavení inzulínu uloženo';

  @override
  String get insulinOptionalHint =>
      'Ponechte prázdné pro použití základního poměru';

  @override
  String get foodSearchTitle => 'Hledat potravinu';

  @override
  String get foodSearchClose => 'Zavřít hledání';

  @override
  String get foodSearchHint => 'Např. Jablko, chléb, rýže...';

  @override
  String get foodSearchEmptyList =>
      'Zatím nemáte na svém seznamu žádné potraviny.';

  @override
  String foodSearchNoResults(String query) {
    return 'Žádné výsledky pro \"$query\"';
  }

  @override
  String get barcodeTitle => 'Naskenovat čárový kód';

  @override
  String get barcodeScannedFood => 'Naskenovaná potravina';

  @override
  String get confirmDeleteTitle => 'Potvrdit smazání';

  @override
  String get confirmDeleteCancel => 'Zrušit';

  @override
  String get confirmDeleteButton => 'Smazat';

  @override
  String get updateAvailable => 'Aktualizace k dispozici';

  @override
  String updateVersion(String version) {
    return 'Verze $version';
  }

  @override
  String get updateLater => 'Později';

  @override
  String get updateDownload => 'Stáhnout';

  @override
  String get updateDownloading => 'Stahování aktualizace...';

  @override
  String get updateError =>
      'Stahování selhalo. Navštivte github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Co je nového';

  @override
  String get profileThemeLabel => 'Motiv aplikace';

  @override
  String get profileThemeSystem => 'Systém';

  @override
  String get profileThemeLight => 'Světlý';

  @override
  String get profileThemeDark => 'Tmavý';

  @override
  String get profileSettingsSectionApp => 'Aplikace';

  @override
  String get profileSettingsSectionHealth => 'Zdraví';

  @override
  String get profileSettings => 'Nastavení';

  @override
  String get insulinGlucoseUnit => 'Jednotka glykémie';

  @override
  String get insulinGlucoseUnitDesc => 'Přepínání mezi mg/dL a mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Použít mmol/L místo mg/dL';

  @override
  String get calcTabGrams => 'Gramy';

  @override
  String get calcTabRations => 'VJ';
}
