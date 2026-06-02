// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'Åadowanie aplikacji';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'TwÃ³j osobisty asystent do codziennego Å›ledzenia wÄ™glowodanÃ³w i wymiennikÃ³w wÄ™glowodanowych.';

  @override
  String get loginButtonGoogle => 'Kontynuuj przez Google';

  @override
  String get loginIniciandoSesion => 'Logowanie';

  @override
  String get loginPrivacyText =>
      'Twoje dane zdrowotne sÄ… chronione\ni powiÄ…zane wyÅ‚Ä…cznie z Twoim kontem osobistym.';

  @override
  String get navCalculator => 'Kalkulator';

  @override
  String get navFoods => 'Produkty';

  @override
  String get navGlobal => 'Globalne';

  @override
  String get navHistory => 'Historia';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAdminTooltip => 'Administracja globalna';

  @override
  String get calcTitle => 'Kalkulator i talerz';

  @override
  String get calcGramsMode => 'Znam gramy\n(ChcÄ™ wymienniki)';

  @override
  String get calcRationsMode => 'ChcÄ™ wymienniki\n(Podaj gramy)';

  @override
  String get calcSearchFood => 'Dotknij, aby wyszukaÄ‡ produkt...';

  @override
  String get calcSearchFoodAccessibility => 'Szukaj produktu';

  @override
  String get calcFoodAccessibility => 'Produkt';

  @override
  String calcSelectedFood(String foodName) {
    return 'Wybrany produkt: $foodName. Dotknij, aby zmieniÄ‡.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g wÄ™gl. / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Szybkie ulubione';

  @override
  String get calcInputGramsLabel => 'IloÅ›Ä‡ w gramach';

  @override
  String get calcInputRationsLabel => 'Wymienniki do spoÅ¼ycia';

  @override
  String get calcInputGramsSuffix => 'gramÃ³w';

  @override
  String get calcInputRationsSuffix => 'wymiennikÃ³w';

  @override
  String get calcResultTitle => 'WYNIK';

  @override
  String get calcResultInverseTitle => 'MUSISZ ODWAÅ»YÄ†';

  @override
  String get calcGramsHC => 'WÄ™glowodany (g)';

  @override
  String get calcRations => 'Wymienniki';

  @override
  String calcOfFood(String foodName) {
    return 'z $foodName';
  }

  @override
  String get calcAddToPlate => 'Dodaj do talerza';

  @override
  String get calcMyPlate => 'MÃ³j obecny talerz';

  @override
  String get calcClear => 'WyczyÅ›Ä‡';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g spoÅ¼yte';
  }

  @override
  String calcRacShort(String rac) {
    return '$rac WW';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g wÄ™gl.';
  }

  @override
  String get calcDeleteFromPlate => 'UsuÅ„ z talerza';

  @override
  String get calcTotalPlate => 'SUMA TALERZA:';

  @override
  String calcTotalRac(String rac) {
    return '$rac WW';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g wÄ™gl.';
  }

  @override
  String get calcMealTypeLabel => 'Rodzaj posiÅ‚ku:';

  @override
  String get calcTimeLabel => 'Godzina';

  @override
  String get calcDateLabel => 'Data';

  @override
  String get calcBolusTitle => 'Bolus insuliny';

  @override
  String get calcGlucoseLabel => 'Aktualna glikemia (opcjonalnie)';

  @override
  String get calcGlucoseHint => 'Np.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Bolus posiÅ‚kowy';

  @override
  String get calcBolusCorrection => 'Korekta';

  @override
  String get calcBolusTotal => 'Razem';

  @override
  String get calcBolusUnitSuffix => 'jednostek';

  @override
  String get calcNoFoodsMessage =>
      'Dodaj produkty do talerza, aby zobaczyÄ‡ bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'Wybierz rodzaj posiÅ‚ku, aby obliczyÄ‡ bolus.';

  @override
  String get calcCalculating => 'Obliczanie...';

  @override
  String get calcConfigureMessage =>
      'Skonfiguruj ustawienia insuliny, aby zobaczyÄ‡ zalecany bolus.';

  @override
  String get calcConfigureButton => 'Skonfiguruj';

  @override
  String get calcSaveHistory => 'Zapisz w historii dnia';

  @override
  String get calcSaveTitle => 'Zapisz w historii';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Zapisano jako $mealType. Bolus: $bolus jedn.';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Zapisano jako $mealType pomyÅ›lnie';
  }

  @override
  String calcSaveError(String error) {
    return 'BÅ‚Ä…d zapisu: $error';
  }

  @override
  String get calcUndo => 'Cofnij';

  @override
  String calcItemRemoved(Object name) {
    return '$name usuniÄ™to';
  }

  @override
  String get calcMustLogin => 'Musisz siÄ™ zalogowaÄ‡';

  @override
  String get calcGramsModeAccessibility => 'Znam gramy, oblicz wymienniki';

  @override
  String get calcRationsModeAccessibility =>
      'ChcÄ™ zjeÅ›Ä‡ wymienniki, oblicz gramy';

  @override
  String get mealTypeBreakfast => 'Åšniadanie';

  @override
  String get mealTypeMidMorning => 'Drugie Å›niadanie';

  @override
  String get mealTypeLunch => 'Obiad';

  @override
  String get mealTypeAfternoonSnack => 'Podwieczorek';

  @override
  String get mealTypeDinner => 'Kolacja';

  @override
  String get mealTypeSnack => 'PrzekÄ…ska / Inne';

  @override
  String get historyDaily => 'Dzienny';

  @override
  String get historyWeekly => 'Tygodniowy';

  @override
  String get historyExportButton => 'Eksportuj';

  @override
  String get historyExportAccessibility => 'Eksportuj historiÄ™ do CSV';

  @override
  String get historyPrevDay => 'Poprzedni dzieÅ„';

  @override
  String get historyNextDay => 'NastÄ™pny dzieÅ„';

  @override
  String get historyToday => 'DZIÅš';

  @override
  String get historyDailyAccessibility => 'Widok dzienny';

  @override
  String get historyWeeklyAccessibility => 'Widok tygodniowy';

  @override
  String get historyLoading => 'Åadowanie historii';

  @override
  String historyErrorLoading(String error) {
    return 'BÅ‚Ä…d: $error';
  }

  @override
  String get historyNoRecords => 'Brak wpisÃ³w na ten dzieÅ„.';

  @override
  String get historyMustLogin => 'Musisz siÄ™ zalogowaÄ‡';

  @override
  String get historyTotalRations => 'Suma wymiennikÃ³w';

  @override
  String get historyTotalCarbs => 'Suma wÄ™glowodanÃ³w';

  @override
  String get historySubtotal => 'SUMA CZÄ˜ÅšCIOWA:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac WW (${carbs}g wÄ™gl.)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus jednostek insuliny';
  }

  @override
  String get historyDeleteTitle => 'UsuÅ„ posiÅ‚ek';

  @override
  String get historyDeleteConfirm =>
      'Czy na pewno chcesz usunÄ…Ä‡ ten wpis z historii?';

  @override
  String get historyDeleteButton => 'UsuÅ„';

  @override
  String get historyCancelButton => 'Anuluj';

  @override
  String get historyDeleteSuccess => 'Wpis usuniÄ™ty';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'UsuÅ„ $mealType';
  }

  @override
  String get historyEditButton => 'Edytuj';

  @override
  String get historyEditTitle => 'Edytuj wpis';

  @override
  String get historyEditSave => 'Zapisz zmiany';

  @override
  String get historyEditSuccess => 'Wpis zaktualizowany';

  @override
  String get historyEditGramsLabel => 'Gramy';

  @override
  String get historyNoData7Days => 'Brak danych z ostatnich 7 dni.';

  @override
  String get historyLast7Days => 'Ostatnie 7 dni';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g wÄ™gl.';
  }

  @override
  String get historyExportEmpty => 'Brak danych do eksportu.';

  @override
  String get historyCsvHeader =>
      'Data,Godzina,Rodzaj posiÅ‚ku,Produkt,Gramy,Wymienniki,WÄ™glowodany (g)';

  @override
  String get historyShareSubject => 'Historia Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'BÅ‚Ä…d eksportu: $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g $name';
  }

  @override
  String historyRacShort(String rac) {
    return '$rac WW';
  }

  @override
  String get profileNotLoggedIn => 'Niezalogowany';

  @override
  String profilePhotoAccessibility(String name) {
    return 'ZdjÄ™cie profilowe uÅ¼ytkownika $name';
  }

  @override
  String get profileDefaultName => 'UÅ¼ytkownik';

  @override
  String get profileAboutTitle => 'O aplikacji Libreta Dulce';

  @override
  String get profileAboutSubtitle =>
      'Stworzona z miÅ‚oÅ›ciÄ… przez diabetykÃ³w i dla diabetykÃ³w';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'CzeÅ›Ä‡, jestem niezaleÅ¼nym programistÄ… i stworzyÅ‚em tÄ™ aplikacjÄ™, aby uÅ‚atwiÄ‡ codzienne zarzÄ…dzanie wÄ™glowodanami i wymiennikami. JeÅ›li masz sugestie lub znajdziesz bÅ‚Ä™dy, podziel siÄ™ nimi proszÄ™.';

  @override
  String get profileAboutDialogClose => 'Zamknij';

  @override
  String get profileInsulinSettings => 'Ustawienia insuliny';

  @override
  String get profileInsulinSettingsDesc =>
      'Przelicznik, wspÃ³Å‚czynnik korekty i docelowa glikemia';

  @override
  String get profileLogout => 'Wyloguj siÄ™';

  @override
  String get profileLogoutConfirm => 'Czy na pewno chcesz siÄ™ wylogowaÄ‡?';

  @override
  String get profileLogoutCancel => 'Anuluj';

  @override
  String get profileLogoutButton => 'Wyloguj siÄ™';

  @override
  String get profileLogoutDialogTitle => 'Wyloguj siÄ™';

  @override
  String get adminTitle => 'ZgÅ‚oszenia i panel globalny';

  @override
  String get adminTabRequests => 'Nowe zgÅ‚oszenia';

  @override
  String get adminTabGlobal => 'Baza globalna';

  @override
  String get adminApproved => 'Produkt zatwierdzony i opublikowany';

  @override
  String get adminRejected => 'ZgÅ‚oszenie odrzucone';

  @override
  String get adminDeleted => 'Produkt usuniÄ™ty globalnie';

  @override
  String get adminEditTitle => 'Edytuj produkt globalny';

  @override
  String get adminNameLabel => 'Nazwa';

  @override
  String get adminCarbsLabel => 'WÄ™glowodany na 100g';

  @override
  String get adminCancelButton => 'Anuluj';

  @override
  String get adminSaveButton => 'Zapisz';

  @override
  String get adminUpdated => 'Produkt zaktualizowany';

  @override
  String get adminNoRequests =>
      'Wszystko czyste! Brak nowych zgÅ‚oszeÅ„ produktÃ³w.';

  @override
  String get adminNoName => 'Bez nazwy';

  @override
  String adminCarbsInfo(String carbs) {
    return 'WÄ™glowodany: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Link/Dodatkowe info: $url';
  }

  @override
  String get adminRejectButton => 'OdrzuÄ‡';

  @override
  String get adminApproveButton => 'ZatwierdÅº';

  @override
  String get adminEmptyGlobal => 'Baza globalna jest pusta.';

  @override
  String get adminGlobalFood => 'Produkt globalny';

  @override
  String get adminEditGlobal => 'Edytuj globalny';

  @override
  String get adminDeleteGlobal => 'UsuÅ„ produkt globalny';

  @override
  String get adminDeleteConfirm => 'UsunÄ…Ä‡ produkt?';

  @override
  String get adminDeleteWarning =>
      'Spowoduje to usuniÄ™cie go z publicznej bazy danych. UÅ¼ytkownicy nie bÄ™dÄ… juÅ¼ mogli go wyszukaÄ‡.';

  @override
  String get adminDeleteButton => 'UsuÅ„';

  @override
  String get adminLoadingRequests => 'Åadowanie zgÅ‚oszeÅ„';

  @override
  String get globalSearch => 'Szukaj w bazie globalnej...';

  @override
  String get globalLoading => 'Åadowanie produktÃ³w globalnych';

  @override
  String get globalNoResults => 'Brak produktÃ³w lub nie znaleziono.';

  @override
  String get globalGlobalFood => 'Produkt globalny';

  @override
  String get globalCopyToMyFoods => 'Kopiuj do Moich ProduktÃ³w';

  @override
  String get globalSuggestProduct => 'Zaproponuj produkt';

  @override
  String get globalScanning => 'Szukanie w OpenFoodFacts...';

  @override
  String get globalFound => 'Produkt znaleziony!';

  @override
  String get globalNotFound => 'Nie znaleziono produktu';

  @override
  String get globalRequestTitle => 'Nowy produkt';

  @override
  String get globalRequestDesc =>
      'Twoje zgÅ‚oszenie zostanie sprawdzone przez czÅ‚owieka przed dodaniem do bazy globalnej.';

  @override
  String get globalRequestName => 'Nazwa produktu';

  @override
  String get globalRequestBrand => 'Marka lub opis';

  @override
  String get globalRequestCarbs => 'WÄ™glowodany na 100g';

  @override
  String get globalRequestUrl => 'Link do produktu (opcjonalnie)';

  @override
  String get globalRequestCancel => 'Anuluj';

  @override
  String get globalRequestSent => 'ZgÅ‚oszenie wysÅ‚ane. DziÄ™kujemy!';

  @override
  String get globalRequestSend => 'WyÅ›lij zgÅ‚oszenie';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name dodano do Twoich produktÃ³w';
  }

  @override
  String get globalScanTooltip => 'Skanuj kod kreskowy';

  @override
  String get globalNotFoundDB => 'Produkt nie znaleziony w bazie';

  @override
  String get globalConnectionError => 'BÅ‚Ä…d poÅ‚Ä…czenia';

  @override
  String globalErrorFirebase(String error) {
    return 'BÅ‚Ä…d Firebase: $error';
  }

  @override
  String get foodsAddTitle => 'Dodaj produkt';

  @override
  String get foodsScanTooltip => 'Skanuj kod kreskowy';

  @override
  String get foodsNameLabel => 'Nazwa (np. JabÅ‚ko)';

  @override
  String get foodsBrandLabel => 'Marka lub opis (opcjonalnie)';

  @override
  String get foodsCarbsLabel => 'WÄ™glowodany na 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'BiaÅ‚ko';

  @override
  String get foodsFatLabel => 'TÅ‚uszcz';

  @override
  String get foodsCancel => 'Anuluj';

  @override
  String get foodsSave => 'Zapisz';

  @override
  String get foodsNameRequired => 'Nazwa produktu jest wymagana.';

  @override
  String get foodsCarbsRequired => 'WÄ™glowodany na 100g sÄ… wymagane.';

  @override
  String get foodsCarbsInvalid =>
      'WartoÅ›Ä‡ wÄ™glowodanÃ³w nie jest prawidÅ‚owÄ… liczbÄ….';

  @override
  String get foodsSearch => 'Szukaj produktu...';

  @override
  String get foodsMustLogin => 'Musisz siÄ™ zalogowaÄ‡';

  @override
  String get foodsLoadingError => 'BÅ‚Ä…d Å‚adowania bazy danych.';

  @override
  String get foodsEmpty =>
      'Nie masz jeszcze Å¼adnych zapisanych produktÃ³w.\nDodaj swÃ³j pierwszy!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Czy na pewno chcesz usunÄ…Ä‡ \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'Dodaj do ulubionych';

  @override
  String get foodsRemoveFromFavorites => 'UsuÅ„ z ulubionych';

  @override
  String foodsDeleteTooltip(String name) {
    return 'UsuÅ„ $name';
  }

  @override
  String get foodsDetailTitle => 'WartoÅ›ci na 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'WÄ™glowodany: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Kalorie: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'BiaÅ‚ko: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'TÅ‚uszcz: ${value}g';
  }

  @override
  String get foodsDetailClose => 'Zamknij';

  @override
  String get foodsNewFood => 'Nowy produkt';

  @override
  String get foodsFavoriteAccessibility => 'Ulubiony';

  @override
  String get foodsFoodAccessibility => 'Produkt';

  @override
  String get foodsSearchAccessibility => 'Produkt globalny';

  @override
  String get insulinTitle => 'Ustawienia insuliny';

  @override
  String get insulinDesc =>
      'Te wartoÅ›ci sÄ… osobiste i prywatne. Ich skonfigurowanie pozwala aplikacji obliczyÄ‡ zalecany bolus insuliny.';

  @override
  String get insulinRatioTitle =>
      'Przelicznik insuliny (jednostki na wymiennik)';

  @override
  String get insulinRatioBase => 'Przelicznik bazowy *';

  @override
  String get insulinRatioHint => 'Np.: 1,5';

  @override
  String get insulinRatioSuffix => 'jedn. / WW';

  @override
  String get insulinRatioRequired => 'Przelicznik bazowy jest wymagany';

  @override
  String get insulinInvalidNumber => 'WprowadÅº prawidÅ‚owÄ… liczbÄ™';

  @override
  String get insulinMealRatios =>
      'Przeliczniki dla poszczegÃ³lnych posiÅ‚kÃ³w (opcjonalnie)';

  @override
  String get insulinFactorTitle => 'WspÃ³Å‚czynnik korekty';

  @override
  String get insulinFactorLabel => 'WspÃ³Å‚czynnik korekty *';

  @override
  String get insulinFactorHint => 'Np.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL na jednostkÄ™';

  @override
  String get insulinFactorRequired => 'WspÃ³Å‚czynnik korekty jest wymagany';

  @override
  String get insulinMustBePositive => 'WartoÅ›Ä‡ musi byÄ‡ wiÄ™ksza od 0';

  @override
  String get insulinGlucoseTargetTitle => 'Docelowa glikemia *';

  @override
  String get insulinGlucoseTargetLabel => 'Docelowa glikemia *';

  @override
  String get insulinGlucoseTargetHint => 'Np.: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired => 'Docelowa glikemia jest wymagana';

  @override
  String get insulinHalfUnits => 'Pen z dawkÄ… 0,5 jedn.';

  @override
  String get insulinHalfUnitsDesc =>
      'UmoÅ¼liwia dawkowanie z dokÅ‚adnoÅ›ciÄ… do 0,5 jednostki';

  @override
  String get insulinRoundDown => 'ZaokrÄ…glaj bolus w dÃ³Å‚';

  @override
  String get insulinRoundDownDesc =>
      'Obcina bolus zamiast zaokrÄ…glaÄ‡ do najbliÅ¼szej wartoÅ›ci. Przydatne przy dawkowaniu zakresowym (np. 1 jedn. na 50 mg/dL)';

  @override
  String get insulinSaving => 'Zapisywanie...';

  @override
  String get insulinSave => 'Zapisz ustawienia';

  @override
  String get insulinSaved => 'Ustawienia insuliny zapisane';

  @override
  String get insulinOptionalHint =>
      'Pozostaw puste, aby uÅ¼yÄ‡ przelicznika bazowego';

  @override
  String get foodSearchTitle => 'Szukaj produktu';

  @override
  String get foodSearchClose => 'Zamknij wyszukiwanie';

  @override
  String get foodSearchHint => 'Np. JabÅ‚ko, chleb, ryÅ¼...';

  @override
  String get foodSearchEmptyList =>
      'Nie masz jeszcze Å¼adnych produktÃ³w na swojej liÅ›cie.';

  @override
  String foodSearchNoResults(String query) {
    return 'Brak wynikÃ³w dla \"$query\"';
  }

  @override
  String get barcodeTitle => 'Skanuj kod kreskowy';

  @override
  String get barcodeScannedFood => 'Zeskanowany produkt';

  @override
  String get confirmDeleteTitle => 'PotwierdÅº usuniÄ™cie';

  @override
  String get confirmDeleteCancel => 'Anuluj';

  @override
  String get confirmDeleteButton => 'UsuÅ„';

  @override
  String get updateAvailable => 'DostÄ™pna aktualizacja';

  @override
  String updateVersion(String version) {
    return 'Wersja $version';
  }

  @override
  String get updateLater => 'PÃ³Åºniej';

  @override
  String get updateDownload => 'Pobierz';

  @override
  String get updateDownloading => 'Pobieranie aktualizacji...';

  @override
  String get updateError =>
      'Pobieranie nie powiodÅ‚o siÄ™. OdwiedÅº github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Co nowego';

  @override
  String get profileThemeLabel => 'Motyw aplikacji';

  @override
  String get profileThemeSystem => 'Systemowy';

  @override
  String get profileThemeLight => 'Jasny';

  @override
  String get profileThemeDark => 'Ciemny';

  @override
  String get profileSettingsSectionApp => 'Aplikacja';

  @override
  String get profileSettingsSectionHealth => 'Zdrowie';

  @override
  String get profileSettings => 'Ustawienia';

  @override
  String get insulinGlucoseUnit => 'Jednostka glukozy';

  @override
  String get insulinGlucoseUnitDesc => 'PrzeÅ‚Ä…cz miÄ™dzy mg/dL a mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'UÅ¼ywaj mmol/L zamiast mg/dL';

  @override
  String get calcTabGrams => 'Gramy';

  @override
  String get calcTabRations => 'Wymienniki';
}
