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
  String get loadingApp => 'NaÄÃ­tÃ¡nÃ­ aplikace';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'VÃ¡Å¡ osobnÃ­ asistent pro kaÅ¾dodennÃ­ sledovÃ¡nÃ­ sacharidÅ¯ a vÃ½mÄ›nnÃ½ch jednotek.';

  @override
  String get loginButtonGoogle => 'PokraÄovat pÅ™es Google';

  @override
  String get loginIniciandoSesion => 'PÅ™ihlaÅ¡ovÃ¡nÃ­';

  @override
  String get loginPrivacyText =>
      'VaÅ¡e zdravotnÃ­ Ãºdaje jsou chrÃ¡nÄ›ny\na propojeny pouze s vaÅ¡Ã­m osobnÃ­m ÃºÄtem.';

  @override
  String get navCalculator => 'KalkulaÄka';

  @override
  String get navFoods => 'Potraviny';

  @override
  String get navGlobal => 'GlobÃ¡lnÃ­';

  @override
  String get navHistory => 'Historie';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAdminTooltip => 'GlobÃ¡lnÃ­ sprÃ¡va';

  @override
  String get calcTitle => 'KalkulaÄka a talÃ­Å™';

  @override
  String get calcGramsMode => 'ZnÃ¡m gramy\n(Chci VJ)';

  @override
  String get calcRationsMode => 'Chci VJ\n(Å˜ekni mi gramy)';

  @override
  String get calcSearchFood => 'KlepnÄ›te pro vyhledÃ¡nÃ­ potraviny...';

  @override
  String get calcSearchFoodAccessibility => 'Hledat potravinu';

  @override
  String get calcFoodAccessibility => 'Potravina';

  @override
  String calcSelectedFood(String foodName) {
    return 'VybranÃ¡ potravina: $foodName. KlepnÄ›te pro zmÄ›nu.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g sacharidÅ¯ / 100g';
  }

  @override
  String get calcFavoritesTitle => 'RychlÃ© oblÃ­benÃ©';

  @override
  String get calcInputGramsLabel => 'MnoÅ¾stvÃ­ v gramech';

  @override
  String get calcInputRationsLabel => 'VJ ke snÄ›denÃ­';

  @override
  String get calcInputGramsSuffix => 'gramÅ¯';

  @override
  String get calcInputRationsSuffix => 'VJ';

  @override
  String get calcResultTitle => 'VÃSLEDEK';

  @override
  String get calcResultInverseTitle => 'MUSÃTE NAVÃÅ½IT';

  @override
  String get calcGramsHC => 'Sacharidy (g)';

  @override
  String get calcRations => 'VÃ½mÄ›nnÃ© jednotky';

  @override
  String calcOfFood(String foodName) {
    return 'z $foodName';
  }

  @override
  String get calcAddToPlate => 'PÅ™idat na talÃ­Å™';

  @override
  String get calcMyPlate => 'MÅ¯j aktuÃ¡lnÃ­ talÃ­Å™';

  @override
  String get calcClear => 'VyÄistit';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g snÄ›deno';
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
  String get calcDeleteFromPlate => 'Odebrat z talÃ­Å™e';

  @override
  String get calcTotalPlate => 'CELKEM TALÃÅ˜:';

  @override
  String calcTotalRac(String rac) {
    return '$rac VJ';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g sach.';
  }

  @override
  String get calcMealTypeLabel => 'Typ jÃ­dla:';

  @override
  String get calcTimeLabel => 'ÄŒas';

  @override
  String get calcDateLabel => 'Datum';

  @override
  String get calcBolusTitle => 'InzulÃ­novÃ½ bolus';

  @override
  String get calcGlucoseLabel => 'AktuÃ¡lnÃ­ glykÃ©mie (volitelnÃ©)';

  @override
  String get calcGlucoseHint => 'NapÅ™.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'JÃ­delnÃ­ bolus';

  @override
  String get calcBolusCorrection => 'Korekce';

  @override
  String get calcBolusTotal => 'Celkem';

  @override
  String get calcBolusUnitSuffix => 'jednotek';

  @override
  String get calcNoFoodsMessage =>
      'PÅ™idejte potraviny na talÃ­Å™, aby se zobrazil bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'Vyberte typ jÃ­dla pro vÃ½poÄet bolusu.';

  @override
  String get calcCalculating => 'VÃ½poÄet...';

  @override
  String get calcConfigureMessage =>
      'Nastavte svÃ© inzulÃ­novÃ© parametry pro zobrazenÃ­ doporuÄenÃ©ho bolusu.';

  @override
  String get calcConfigureButton => 'Nastavit';

  @override
  String get calcSaveHistory => 'UloÅ¾it do dennÃ­ historie';

  @override
  String get calcSaveTitle => 'UloÅ¾it do historie';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'UloÅ¾eno jako $mealType. Bolus: $bolus jedn.';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'UloÅ¾eno jako $mealType ÃºspÄ›Å¡nÄ›';
  }

  @override
  String calcSaveError(String error) {
    return 'Chyba pÅ™i uklÃ¡dÃ¡nÃ­: $error';
  }

  @override
  String get calcUndo => 'ZpÄ›t';

  @override
  String calcItemRemoved(Object name) {
    return '$name odstranÄ›no';
  }

  @override
  String get calcMustLogin => 'MusÃ­te se pÅ™ihlÃ¡sit';

  @override
  String get calcGramsModeAccessibility => 'ZnÃ¡m gramy, spoÄÃ­tej VJ';

  @override
  String get calcRationsModeAccessibility => 'Chci snÃ­st VJ, spoÄÃ­tej gramy';

  @override
  String get mealTypeBreakfast => 'SnÃ­danÄ›';

  @override
  String get mealTypeMidMorning => 'DopolednÃ­ svaÄina';

  @override
  String get mealTypeLunch => 'ObÄ›d';

  @override
  String get mealTypeAfternoonSnack => 'OdpolednÃ­ svaÄina';

  @override
  String get mealTypeDinner => 'VeÄeÅ™e';

  @override
  String get mealTypeSnack => 'SvaÄina / JinÃ©';

  @override
  String get historyDaily => 'DennÃ­';

  @override
  String get historyWeekly => 'TÃ½dennÃ­';

  @override
  String get historyExportButton => 'Exportovat';

  @override
  String get historyExportAccessibility => 'Exportovat historii do CSV';

  @override
  String get historyPrevDay => 'PÅ™edchozÃ­ den';

  @override
  String get historyNextDay => 'NÃ¡sledujÃ­cÃ­ den';

  @override
  String get historyToday => 'DNES';

  @override
  String get historyDailyAccessibility => 'DennÃ­ zobrazenÃ­';

  @override
  String get historyWeeklyAccessibility => 'TÃ½dennÃ­ zobrazenÃ­';

  @override
  String get historyLoading => 'NaÄÃ­tÃ¡nÃ­ historie';

  @override
  String historyErrorLoading(String error) {
    return 'Chyba: $error';
  }

  @override
  String get historyNoRecords => 'Pro tento den nejsou Å¾Ã¡dnÃ© zÃ¡znamy.';

  @override
  String get historyMustLogin => 'MusÃ­te se pÅ™ihlÃ¡sit';

  @override
  String get historyTotalRations => 'Celkem VJ';

  @override
  String get historyTotalCarbs => 'Celkem sacharidÅ¯';

  @override
  String get historySubtotal => 'MEZISOUÄŒET:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac VJ (${carbs}g sach.)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus jednotek inzulÃ­nu';
  }

  @override
  String get historyDeleteTitle => 'Smazat jÃ­dlo';

  @override
  String get historyDeleteConfirm =>
      'Opravdu chcete smazat tento zÃ¡znam z historie?';

  @override
  String get historyDeleteButton => 'Smazat';

  @override
  String get historyCancelButton => 'ZruÅ¡it';

  @override
  String get historyDeleteSuccess => 'ZÃ¡znam smazÃ¡n';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Smazat $mealType';
  }

  @override
  String get historyEditButton => 'Upravit';

  @override
  String get historyEditTitle => 'Upravit zÃ¡znam';

  @override
  String get historyEditSave => 'UloÅ¾it zmÄ›ny';

  @override
  String get historyEditSuccess => 'ZÃ¡znam aktualizovÃ¡n';

  @override
  String get historyEditGramsLabel => 'Gramy';

  @override
  String get historyNoData7Days => 'Å½Ã¡dnÃ¡ data za poslednÃ­ch 7 dnÃ­.';

  @override
  String get historyLast7Days => 'PoslednÃ­ch 7 dnÃ­';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g sach.';
  }

  @override
  String get historyExportEmpty => 'Å½Ã¡dnÃ¡ data k exportu.';

  @override
  String get historyCsvHeader =>
      'Datum,ÄŒas,Typ jÃ­dla,Potravina,Gramy,VJ,Sacharidy (g)';

  @override
  String get historyShareSubject => 'Historie Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'Chyba pÅ™i exportu: $error';
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
  String get profileNotLoggedIn => 'NepÅ™ihlÃ¡Å¡en';

  @override
  String profilePhotoAccessibility(String name) {
    return 'ProfilovÃ¡ fotka uÅ¾ivatele $name';
  }

  @override
  String get profileDefaultName => 'UÅ¾ivatel';

  @override
  String get profileAboutTitle => 'O aplikaci Libreta Dulce';

  @override
  String get profileAboutSubtitle =>
      'VytvoÅ™eno s lÃ¡skou diabetiky a pro diabetiky';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Ahoj, jsem nezÃ¡vislÃ½ vÃ½vojÃ¡Å™ a vytvoÅ™il jsem tuto aplikaci, abych usnadnil kaÅ¾dodennÃ­ sprÃ¡vu sacharidÅ¯ a vÃ½mÄ›nnÃ½ch jednotek. Pokud mÃ¡te nÃ¡vrhy nebo najdete chyby, podÄ›lte se o nÄ› prosÃ­m.';

  @override
  String get profileAboutDialogClose => 'ZavÅ™Ã­t';

  @override
  String get profileInsulinSettings => 'NastavenÃ­ inzulÃ­nu';

  @override
  String get profileInsulinSettingsDesc =>
      'PomÄ›r, korekÄnÃ­ faktor a cÃ­lovÃ¡ glykÃ©mie';

  @override
  String get profileLogout => 'OdhlÃ¡sit se';

  @override
  String get profileLogoutConfirm => 'Opravdu se chcete odhlÃ¡sit?';

  @override
  String get profileLogoutCancel => 'ZruÅ¡it';

  @override
  String get profileLogoutButton => 'OdhlÃ¡sit se';

  @override
  String get profileLogoutDialogTitle => 'OdhlÃ¡sit se';

  @override
  String get adminTitle => 'Å½Ã¡dosti a globÃ¡lnÃ­ panel';

  @override
  String get adminTabRequests => 'NovÃ© Å¾Ã¡dosti';

  @override
  String get adminTabGlobal => 'GlobÃ¡lnÃ­ data';

  @override
  String get adminApproved => 'Potravina schvÃ¡lena a publikovÃ¡na';

  @override
  String get adminRejected => 'Å½Ã¡dost zamÃ­tnuta';

  @override
  String get adminDeleted => 'Potravina globÃ¡lnÄ› smazÃ¡na';

  @override
  String get adminEditTitle => 'Upravit globÃ¡lnÃ­ potravinu';

  @override
  String get adminNameLabel => 'NÃ¡zev';

  @override
  String get adminCarbsLabel => 'Sacharidy na 100g';

  @override
  String get adminCancelButton => 'ZruÅ¡it';

  @override
  String get adminSaveButton => 'UloÅ¾it';

  @override
  String get adminUpdated => 'Potravina aktualizovÃ¡na';

  @override
  String get adminNoRequests =>
      'VÅ¡e ÄistÃ©! Å½Ã¡dnÃ© novÃ© Å¾Ã¡dosti o potraviny.';

  @override
  String get adminNoName => 'Bez nÃ¡zvu';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Sacharidy: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Odkaz/DalÅ¡Ã­ info: $url';
  }

  @override
  String get adminRejectButton => 'ZamÃ­tnout';

  @override
  String get adminApproveButton => 'SchvÃ¡lit';

  @override
  String get adminEmptyGlobal => 'GlobÃ¡lnÃ­ databÃ¡ze je prÃ¡zdnÃ¡.';

  @override
  String get adminGlobalFood => 'GlobÃ¡lnÃ­ potravina';

  @override
  String get adminEditGlobal => 'Upravit globÃ¡lnÃ­';

  @override
  String get adminDeleteGlobal => 'Smazat globÃ¡lnÃ­ potravinu';

  @override
  String get adminDeleteConfirm => 'Smazat potravinu?';

  @override
  String get adminDeleteWarning =>
      'TÃ­m dojde k odstranÄ›nÃ­ z veÅ™ejnÃ© databÃ¡ze. UÅ¾ivatelÃ© jiÅ¾ nebudou moci tuto potravinu vyhledat.';

  @override
  String get adminDeleteButton => 'Smazat';

  @override
  String get adminLoadingRequests => 'NaÄÃ­tÃ¡nÃ­ Å¾Ã¡dostÃ­';

  @override
  String get globalSearch => 'Hledat v globÃ¡lnÃ­ databÃ¡zi...';

  @override
  String get globalLoading => 'NaÄÃ­tÃ¡nÃ­ globÃ¡lnÃ­ch potravin';

  @override
  String get globalNoResults => 'Å½Ã¡dnÃ© potraviny nebo nenalezeno.';

  @override
  String get globalGlobalFood => 'GlobÃ¡lnÃ­ potravina';

  @override
  String get globalCopyToMyFoods => 'KopÃ­rovat do MÃ½ch potravin';

  @override
  String get globalSuggestProduct => 'Navrhnout produkt';

  @override
  String get globalScanning => 'VyhledÃ¡vÃ¡nÃ­ v OpenFoodFacts...';

  @override
  String get globalFound => 'Potravina nalezena!';

  @override
  String get globalNotFound => 'Produkt nenalezen';

  @override
  String get globalRequestTitle => 'NovÃ¡ potravina';

  @override
  String get globalRequestDesc =>
      'VaÅ¡e Å¾Ã¡dost bude pÅ™ed pÅ™idÃ¡nÃ­m do globÃ¡lnÃ­ databÃ¡ze zkontrolovÃ¡na ÄlovÄ›kem.';

  @override
  String get globalRequestName => 'NÃ¡zev produktu';

  @override
  String get globalRequestBrand => 'ZnaÄka nebo popis';

  @override
  String get globalRequestCarbs => 'Sacharidy na 100g';

  @override
  String get globalRequestUrl => 'Odkaz na produkt (volitelnÃ©)';

  @override
  String get globalRequestCancel => 'ZruÅ¡it';

  @override
  String get globalRequestSent => 'Å½Ã¡dost odeslÃ¡na. DÄ›kujeme!';

  @override
  String get globalRequestSend => 'Odeslat Å¾Ã¡dost';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name pÅ™idÃ¡no do vaÅ¡ich potravin';
  }

  @override
  String get globalScanTooltip => 'Naskenovat ÄÃ¡rovÃ½ kÃ³d';

  @override
  String get globalNotFoundDB => 'Produkt nenalezen v databÃ¡zi';

  @override
  String get globalConnectionError => 'Chyba pÅ™ipojenÃ­';

  @override
  String globalErrorFirebase(String error) {
    return 'Chyba Firebase: $error';
  }

  @override
  String get foodsAddTitle => 'PÅ™idat potravinu';

  @override
  String get foodsScanTooltip => 'Naskenovat ÄÃ¡rovÃ½ kÃ³d';

  @override
  String get foodsNameLabel => 'NÃ¡zev (napÅ™. Jablko)';

  @override
  String get foodsBrandLabel => 'ZnaÄka nebo popis (volitelnÃ©)';

  @override
  String get foodsCarbsLabel => 'Sacharidy na 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'BÃ­lkoviny';

  @override
  String get foodsFatLabel => 'Tuky';

  @override
  String get foodsCancel => 'ZruÅ¡it';

  @override
  String get foodsSave => 'UloÅ¾it';

  @override
  String get foodsNameRequired => 'NÃ¡zev potraviny je povinnÃ½.';

  @override
  String get foodsCarbsRequired => 'Sacharidy na 100g jsou povinnÃ©.';

  @override
  String get foodsCarbsInvalid => 'Hodnota sacharidÅ¯ nenÃ­ platnÃ© ÄÃ­slo.';

  @override
  String get foodsSearch => 'Hledat potravinu...';

  @override
  String get foodsMustLogin => 'MusÃ­te se pÅ™ihlÃ¡sit';

  @override
  String get foodsLoadingError => 'Chyba pÅ™i naÄÃ­tÃ¡nÃ­ databÃ¡ze.';

  @override
  String get foodsEmpty =>
      'ZatÃ­m nemÃ¡te Å¾Ã¡dnÃ© uloÅ¾enÃ© potraviny.\nPÅ™idejte svou prvnÃ­!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Opravdu chcete smazat \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'PÅ™idat do oblÃ­benÃ½ch';

  @override
  String get foodsRemoveFromFavorites => 'Odebrat z oblÃ­benÃ½ch';

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
    return 'BÃ­lkoviny: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Tuky: ${value}g';
  }

  @override
  String get foodsDetailClose => 'ZavÅ™Ã­t';

  @override
  String get foodsNewFood => 'NovÃ¡ potravina';

  @override
  String get foodsFavoriteAccessibility => 'OblÃ­benÃ¡';

  @override
  String get foodsFoodAccessibility => 'Potravina';

  @override
  String get foodsSearchAccessibility => 'GlobÃ¡lnÃ­ potravina';

  @override
  String get insulinTitle => 'NastavenÃ­ inzulÃ­nu';

  @override
  String get insulinDesc =>
      'Tyto hodnoty jsou osobnÃ­ a soukromÃ©. Jejich nastavenÃ­ umoÅ¾Åˆuje aplikaci vypoÄÃ­tat doporuÄenÃ½ inzulÃ­novÃ½ bolus.';

  @override
  String get insulinRatioTitle => 'InzulÃ­novÃ½ pomÄ›r (jednotky na VJ)';

  @override
  String get insulinRatioBase => 'ZÃ¡kladnÃ­ pomÄ›r *';

  @override
  String get insulinRatioHint => 'NapÅ™.: 1,5';

  @override
  String get insulinRatioSuffix => 'jedn. / VJ';

  @override
  String get insulinRatioRequired => 'ZÃ¡kladnÃ­ pomÄ›r je povinnÃ½';

  @override
  String get insulinInvalidNumber => 'Zadejte platnÃ© ÄÃ­slo';

  @override
  String get insulinMealRatios => 'PomÄ›ry pro jednotlivÃ¡ jÃ­dla (volitelnÃ©)';

  @override
  String get insulinFactorTitle => 'KorekÄnÃ­ faktor';

  @override
  String get insulinFactorLabel => 'KorekÄnÃ­ faktor *';

  @override
  String get insulinFactorHint => 'NapÅ™.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL na jednotku';

  @override
  String get insulinFactorRequired => 'KorekÄnÃ­ faktor je povinnÃ½';

  @override
  String get insulinMustBePositive => 'Hodnota musÃ­ bÃ½t vÄ›tÅ¡Ã­ neÅ¾ 0';

  @override
  String get insulinGlucoseTargetTitle => 'CÃ­lovÃ¡ glykÃ©mie *';

  @override
  String get insulinGlucoseTargetLabel => 'CÃ­lovÃ¡ glykÃ©mie *';

  @override
  String get insulinGlucoseTargetHint => 'NapÅ™.: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired => 'CÃ­lovÃ¡ glykÃ©mie je povinnÃ¡';

  @override
  String get insulinHalfUnits => 'Pero s dÃ¡vkovÃ¡nÃ­m po 0,5 jedn.';

  @override
  String get insulinHalfUnitsDesc =>
      'UmoÅ¾Åˆuje dÃ¡vkovÃ¡nÃ­ s pÅ™esnostÃ­ na 0,5 jednotky';

  @override
  String get insulinRoundDown => 'Zaokrouhlovat bolus dolÅ¯';

  @override
  String get insulinRoundDownDesc =>
      'OÅ™Ã­zne bolus mÃ­sto zaokrouhlenÃ­ na nejbliÅ¾Å¡Ã­ hodnotu. UÅ¾iteÄnÃ© pÅ™i dÃ¡vkovÃ¡nÃ­ podle rozsahÅ¯ (napÅ™. 1 jedn. na 50 mg/dL)';

  @override
  String get insulinSaving => 'UklÃ¡dÃ¡nÃ­...';

  @override
  String get insulinSave => 'UloÅ¾it nastavenÃ­';

  @override
  String get insulinSaved => 'NastavenÃ­ inzulÃ­nu uloÅ¾eno';

  @override
  String get insulinOptionalHint =>
      'Ponechte prÃ¡zdnÃ© pro pouÅ¾itÃ­ zÃ¡kladnÃ­ho pomÄ›ru';

  @override
  String get foodSearchTitle => 'Hledat potravinu';

  @override
  String get foodSearchClose => 'ZavÅ™Ã­t hledÃ¡nÃ­';

  @override
  String get foodSearchHint => 'NapÅ™. Jablko, chlÃ©b, rÃ½Å¾e...';

  @override
  String get foodSearchEmptyList =>
      'ZatÃ­m nemÃ¡te na svÃ©m seznamu Å¾Ã¡dnÃ© potraviny.';

  @override
  String foodSearchNoResults(String query) {
    return 'Å½Ã¡dnÃ© vÃ½sledky pro \"$query\"';
  }

  @override
  String get barcodeTitle => 'Naskenovat ÄÃ¡rovÃ½ kÃ³d';

  @override
  String get barcodeScannedFood => 'NaskenovanÃ¡ potravina';

  @override
  String get confirmDeleteTitle => 'Potvrdit smazÃ¡nÃ­';

  @override
  String get confirmDeleteCancel => 'ZruÅ¡it';

  @override
  String get confirmDeleteButton => 'Smazat';

  @override
  String get updateAvailable => 'Aktualizace k dispozici';

  @override
  String updateVersion(String version) {
    return 'Verze $version';
  }

  @override
  String get updateLater => 'PozdÄ›ji';

  @override
  String get updateDownload => 'StÃ¡hnout';

  @override
  String get updateDownloading => 'StahovÃ¡nÃ­ aktualizace...';

  @override
  String get updateError =>
      'StahovÃ¡nÃ­ selhalo. NavÅ¡tivte github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Co je novÃ©ho';

  @override
  String get profileThemeLabel => 'Motiv aplikace';

  @override
  String get profileThemeSystem => 'SystÃ©m';

  @override
  String get profileThemeLight => 'SvÄ›tlÃ½';

  @override
  String get profileThemeDark => 'TmavÃ½';

  @override
  String get profileSettingsSectionApp => 'Aplikace';

  @override
  String get profileSettingsSectionHealth => 'ZdravÃ­';

  @override
  String get profileSettings => 'NastavenÃ­';

  @override
  String get insulinGlucoseUnit => 'Jednotka glykÃ©mie';

  @override
  String get insulinGlucoseUnitDesc => 'PÅ™epÃ­nÃ¡nÃ­ mezi mg/dL a mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'PouÅ¾Ã­t mmol/L mÃ­sto mg/dL';

  @override
  String get calcTabGrams => 'Gramy';

  @override
  String get calcTabRations => 'VJ';
}
