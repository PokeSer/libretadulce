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
  String get loadingApp => 'Ładowanie aplikacji';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Twój osobisty asystent do codziennego śledzenia węglowodanów i wymienników węglowodanowych.';

  @override
  String get loginButtonGoogle => 'Kontynuuj przez Google';

  @override
  String get loginIniciandoSesion => 'Logowanie';

  @override
  String get loginPrivacyText =>
      'Twoje dane zdrowotne są chronione\ni powiązane wyłącznie z Twoim kontem osobistym.';

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
  String get calcGramsMode => 'Znam gramy\n(Chcę wymienniki)';

  @override
  String get calcRationsMode => 'Chcę wymienniki\n(Podaj gramy)';

  @override
  String get calcSearchFood => 'Dotknij, aby wyszukać produkt...';

  @override
  String get calcSearchFoodAccessibility => 'Szukaj produktu';

  @override
  String get calcFoodAccessibility => 'Produkt';

  @override
  String calcSelectedFood(String foodName) {
    return 'Wybrany produkt: $foodName. Dotknij, aby zmienić.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g węgl. / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Szybkie ulubione';

  @override
  String get calcInputGramsLabel => 'Ilość w gramach';

  @override
  String get calcInputRationsLabel => 'Wymienniki do spożycia';

  @override
  String get calcInputGramsSuffix => 'gramów';

  @override
  String get calcInputRationsSuffix => 'wymienników';

  @override
  String get calcResultTitle => 'WYNIK';

  @override
  String get calcResultInverseTitle => 'MUSISZ ODWAŻYĆ';

  @override
  String get calcGramsHC => 'Węglowodany (g)';

  @override
  String get calcRations => 'Wymienniki';

  @override
  String calcOfFood(String foodName) {
    return 'z $foodName';
  }

  @override
  String get calcAddToPlate => 'Dodaj do talerza';

  @override
  String get calcMyPlate => 'Mój obecny talerz';

  @override
  String get calcClear => 'Wyczyść';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g spożyte';
  }

  @override
  String calcRacShort(String rac) {
    return '$rac WW';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g węgl.';
  }

  @override
  String calcFats(String fats) {
    return '${fats}g tłuszczu';
  }

  @override
  String calcProteins(String proteins) {
    return '${proteins}g białka';
  }

  @override
  String get calcDeleteFromPlate => 'Usuń z talerza';

  @override
  String get calcTotalPlate => 'SUMA TALERZA:';

  @override
  String calcTotalRac(String rac) {
    return '$rac WW';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g węgl.';
  }

  @override
  String calcTotalFats(String fats) {
    return '${fats}g tłuszczu';
  }

  @override
  String calcTotalProteins(String proteins) {
    return '${proteins}g białka';
  }

  @override
  String get calcMealTypeLabel => 'Rodzaj posiłku:';

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
  String get calcBolusMeal => 'Bolus posiłkowy';

  @override
  String get calcBolusCorrection => 'Korekta';

  @override
  String get calcBolusTotal => 'Razem';

  @override
  String get calcBolusUnitSuffix => 'jednostek';

  @override
  String get calcNoFoodsMessage =>
      'Dodaj produkty do talerza, aby zobaczyć bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'Wybierz rodzaj posiłku, aby obliczyć bolus.';

  @override
  String get calcCalculating => 'Obliczanie...';

  @override
  String get calcConfigureMessage =>
      'Skonfiguruj ustawienia insuliny, aby zobaczyć zalecany bolus.';

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
    return 'Zapisano jako $mealType pomyślnie';
  }

  @override
  String calcSaveError(String error) {
    return 'Błąd zapisu: $error';
  }

  @override
  String get calcUndo => 'Cofnij';

  @override
  String calcItemRemoved(Object name) {
    return '$name usunięto';
  }

  @override
  String get calcMustLogin => 'Musisz się zalogować';

  @override
  String get calcGramsModeAccessibility => 'Znam gramy, oblicz wymienniki';

  @override
  String get calcRationsModeAccessibility =>
      'Chcę zjeść wymienniki, oblicz gramy';

  @override
  String calcRepeatLastMeal(String mealType) {
    return 'Powtórz ostatni $mealType';
  }

  @override
  String get calcRepeatLastMealTooltip => 'Powtórz posiłek';

  @override
  String get calcSaveAsTemplate => 'Zapisz jako szablon';

  @override
  String get calcTemplateNameHint => 'Np: Moje zwykłe śniadanie';

  @override
  String get calcTemplateNameRequired => 'Wprowadź nazwę szablonu';

  @override
  String get calcTemplateSaved => 'Szablon zapisany';

  @override
  String get calcLoadTemplate => 'Załaduj szablon';

  @override
  String get calcNoTemplates => 'Brak zapisanych szablonów';

  @override
  String calcTemplateLoaded(String name) {
    return 'Szablon \"$name\" załadowany';
  }

  @override
  String get calcDeleteTemplate => 'Usuń szablon';

  @override
  String calcDeleteTemplateConfirm(String name) {
    return 'Usunąć \"$name\"?';
  }

  @override
  String get mealTypeBreakfast => 'Śniadanie';

  @override
  String get mealTypeMidMorning => 'Drugie śniadanie';

  @override
  String get mealTypeLunch => 'Obiad';

  @override
  String get mealTypeAfternoonSnack => 'Podwieczorek';

  @override
  String get mealTypeDinner => 'Kolacja';

  @override
  String get mealTypeSnack => 'Przekąska / Inne';

  @override
  String get historyDaily => 'Dzienny';

  @override
  String get historyWeekly => 'Tygodniowy';

  @override
  String get historyExportButton => 'Eksportuj';

  @override
  String get historyExportOptionsTitle => 'Eksportuj dane';

  @override
  String get historyPdfExportOption => 'Raport PDF';

  @override
  String get historyPdfExportSubtitle => 'Profesjonalny dokument dla lekarza';

  @override
  String get historyCsvExportOption => 'Arkusz CSV';

  @override
  String get historyCsvExportSubtitle =>
      'Do analizy w Excelu lub Google Sheets';

  @override
  String get historyPdfButton => 'Raport PDF';

  @override
  String get historyPdfTitle => 'Raport Kontroli Glikemii';

  @override
  String historyPdfSubtitle(String name, String date) {
    return 'Pacjent: $name · Wygenerowano: $date';
  }

  @override
  String get historyPdfFileName => 'raport_libretadulce.pdf';

  @override
  String get historyPdfAvgCarbs => 'Śr. węglow./dzień';

  @override
  String get historyPdfAvgGlucose => 'Śr. glikemia';

  @override
  String get historyPdfAvgInsulin => 'Śr. insulina/dawka';

  @override
  String get historyPdfDays => 'Dni';

  @override
  String get historyPdfMeals => 'Posiłki';

  @override
  String get historyPdfPeriod => 'Okres';

  @override
  String get historyPdfFood => 'Produkt';

  @override
  String get historyPdfMealType => 'Typ';

  @override
  String get historyPdfGlucose => 'Glikemia';

  @override
  String get historyPdfDateRangeTitle => 'Wybierz daty';

  @override
  String get historyPdfFrom => 'Od';

  @override
  String get historyPdfTo => 'Do';

  @override
  String get historyPdfGenerate => 'Generuj PDF';

  @override
  String get historyPdfDisclaimer =>
      'Ten raport został wygenerowany przez Libreta Dulce. Dane pochodzą z rejestrów użytkownika i nie zastępują profesjonalnej oceny medycznej. Zawsze konsultuj się z zespołem medycznym.';

  @override
  String get historyPdfError => 'Błąd podczas generowania PDF';

  @override
  String get historyPdfEmpty => 'Brak danych do wygenerowania raportu';

  @override
  String get historyExportAccessibility => 'Eksportuj historię do CSV';

  @override
  String get historyPrevDay => 'Poprzedni dzień';

  @override
  String get historyNextDay => 'Następny dzień';

  @override
  String get historyToday => 'DZIŚ';

  @override
  String get historyDailyAccessibility => 'Widok dzienny';

  @override
  String get historyWeeklyAccessibility => 'Widok tygodniowy';

  @override
  String get historyLoading => 'Ładowanie historii';

  @override
  String historyErrorLoading(String error) {
    return 'Błąd: $error';
  }

  @override
  String get historyNoRecords => 'Brak wpisów na ten dzień.';

  @override
  String get historyMustLogin => 'Musisz się zalogować';

  @override
  String get historyTotalRations => 'Suma wymienników';

  @override
  String get historyTotalCarbs => 'Suma węglowodanów';

  @override
  String get historyTotalFats => 'Tłuszczu';

  @override
  String get historyTotalProteins => 'Białka';

  @override
  String get historySubtotal => 'SUMA CZĘŚCIOWA:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac WW (${carbs}g węgl.)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus jednostek insuliny';
  }

  @override
  String get historyDeleteTitle => 'Usuń posiłek';

  @override
  String get historyDeleteConfirm =>
      'Czy na pewno chcesz usunąć ten wpis z historii?';

  @override
  String get historyDeleteButton => 'Usuń';

  @override
  String get historyCancelButton => 'Anuluj';

  @override
  String get historyDeleteSuccess => 'Wpis usunięty';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Usuń $mealType';
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
  String get historyGlucoseInRange => 'W normie';

  @override
  String get historyGlucoseHigh => 'Wysoki';

  @override
  String get historyGlucoseLow => 'Niski';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g węgl.';
  }

  @override
  String get historyExportEmpty => 'Brak danych do eksportu.';

  @override
  String get historyCsvHeader =>
      'Data,Godzina,Rodzaj posiłku,Produkt,Gramy,Wymienniki,Węglowodany (g)';

  @override
  String get historyShareSubject => 'Historia Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'Błąd eksportu: $error';
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
    return 'Zdjęcie profilowe użytkownika $name';
  }

  @override
  String get profileDefaultName => 'Użytkownik';

  @override
  String get profileAboutTitle => 'O aplikacji Libreta Dulce';

  @override
  String get profileAboutSubtitle =>
      'Stworzona z miłością przez diabetyków i dla diabetyków';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Cześć, jestem niezależnym programistą i stworzyłem tę aplikację, aby ułatwić codzienne zarządzanie węglowodanami i wymiennikami. Jeśli masz sugestie lub znajdziesz błędy, podziel się nimi proszę.';

  @override
  String get profileAboutDialogClose => 'Zamknij';

  @override
  String get profileInsulinSettings => 'Ustawienia insuliny';

  @override
  String get profileInsulinSettingsDesc =>
      'Przelicznik, współczynnik korekty i docelowa glikemia';

  @override
  String get profileLogout => 'Wyloguj się';

  @override
  String get profileLogoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get profileLogoutCancel => 'Anuluj';

  @override
  String get profileLogoutButton => 'Wyloguj się';

  @override
  String get profileLogoutDialogTitle => 'Wyloguj się';

  @override
  String get adminTitle => 'Zgłoszenia i panel globalny';

  @override
  String get adminTabRequests => 'Nowe zgłoszenia';

  @override
  String get adminTabGlobal => 'Baza globalna';

  @override
  String get adminApproved => 'Produkt zatwierdzony i opublikowany';

  @override
  String get adminRejected => 'Zgłoszenie odrzucone';

  @override
  String get adminDeleted => 'Produkt usunięty globalnie';

  @override
  String get adminEditTitle => 'Edytuj produkt globalny';

  @override
  String get adminNameLabel => 'Nazwa';

  @override
  String get adminCarbsLabel => 'Węglowodany na 100g';

  @override
  String get adminCancelButton => 'Anuluj';

  @override
  String get adminSaveButton => 'Zapisz';

  @override
  String get adminUpdated => 'Produkt zaktualizowany';

  @override
  String get adminNoRequests =>
      'Wszystko czyste! Brak nowych zgłoszeń produktów.';

  @override
  String get adminNoName => 'Bez nazwy';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Węglowodany: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Link/Dodatkowe info: $url';
  }

  @override
  String get adminRejectButton => 'Odrzuć';

  @override
  String get adminApproveButton => 'Zatwierdź';

  @override
  String get adminEmptyGlobal => 'Baza globalna jest pusta.';

  @override
  String get adminGlobalFood => 'Produkt globalny';

  @override
  String get adminEditGlobal => 'Edytuj globalny';

  @override
  String get adminDeleteGlobal => 'Usuń produkt globalny';

  @override
  String get adminDeleteConfirm => 'Usunąć produkt?';

  @override
  String get adminDeleteWarning =>
      'Spowoduje to usunięcie go z publicznej bazy danych. Użytkownicy nie będą już mogli go wyszukać.';

  @override
  String get adminDeleteButton => 'Usuń';

  @override
  String get adminLoadingRequests => 'Ładowanie zgłoszeń';

  @override
  String get globalSearch => 'Szukaj w bazie globalnej...';

  @override
  String get globalLoading => 'Ładowanie produktów globalnych';

  @override
  String get globalNoResults => 'Brak produktów lub nie znaleziono.';

  @override
  String get globalGlobalFood => 'Produkt globalny';

  @override
  String get globalCopyToMyFoods => 'Kopiuj do Moich Produktów';

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
      'Twoje zgłoszenie zostanie sprawdzone przez człowieka przed dodaniem do bazy globalnej.';

  @override
  String get globalRequestName => 'Nazwa produktu';

  @override
  String get globalRequestBrand => 'Marka lub opis';

  @override
  String get globalRequestCarbs => 'Węglowodany na 100g';

  @override
  String get globalRequestUrl => 'Link do produktu (opcjonalnie)';

  @override
  String get globalRequestCancel => 'Anuluj';

  @override
  String get globalRequestSent => 'Zgłoszenie wysłane. Dziękujemy!';

  @override
  String get globalRequestSend => 'Wyślij zgłoszenie';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name dodano do Twoich produktów';
  }

  @override
  String get globalScanTooltip => 'Skanuj kod kreskowy';

  @override
  String get globalNotFoundDB => 'Produkt nie znaleziony w bazie';

  @override
  String get globalConnectionError => 'Błąd połączenia';

  @override
  String globalErrorFirebase(String error) {
    return 'Błąd Firebase: $error';
  }

  @override
  String get serviceError => 'Wystąpił błąd. Spróbuj ponownie.';

  @override
  String get foodsAddTitle => 'Dodaj produkt';

  @override
  String get foodsScanTooltip => 'Skanuj kod kreskowy';

  @override
  String get foodsNameLabel => 'Nazwa (np. Jabłko)';

  @override
  String get foodsBrandLabel => 'Marka lub opis (opcjonalnie)';

  @override
  String get foodsCarbsLabel => 'Węglowodany na 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'Białko';

  @override
  String get foodsFatLabel => 'Tłuszcz';

  @override
  String get foodsCancel => 'Anuluj';

  @override
  String get foodsSave => 'Zapisz';

  @override
  String get foodsNameRequired => 'Nazwa produktu jest wymagana.';

  @override
  String get foodsCarbsRequired => 'Węglowodany na 100g są wymagane.';

  @override
  String get foodsCarbsInvalid =>
      'Wartość węglowodanów nie jest prawidłową liczbą.';

  @override
  String get foodsSearch => 'Szukaj produktu...';

  @override
  String get foodsMustLogin => 'Musisz się zalogować';

  @override
  String get foodsLoadingError => 'Błąd ładowania bazy danych.';

  @override
  String get foodsEmpty =>
      'Nie masz jeszcze żadnych zapisanych produktów.\nDodaj swój pierwszy!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Czy na pewno chcesz usunąć \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'Dodaj do ulubionych';

  @override
  String get foodsRemoveFromFavorites => 'Usuń z ulubionych';

  @override
  String foodsDeleteTooltip(String name) {
    return 'Usuń $name';
  }

  @override
  String get foodsDetailTitle => 'Wartości na 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'Węglowodany: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Kalorie: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'Białko: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Tłuszcz: ${value}g';
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
      'Te wartości są osobiste i prywatne. Ich skonfigurowanie pozwala aplikacji obliczyć zalecany bolus insuliny.';

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
  String get insulinInvalidNumber => 'Wprowadź prawidłową liczbę';

  @override
  String get insulinMealRatios =>
      'Przeliczniki dla poszczególnych posiłków (opcjonalnie)';

  @override
  String get insulinFactorTitle => 'Współczynnik korekty';

  @override
  String get insulinFactorLabel => 'Współczynnik korekty *';

  @override
  String get insulinFactorHint => 'Np.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL na jednostkę';

  @override
  String get insulinFactorRequired => 'Współczynnik korekty jest wymagany';

  @override
  String get insulinMustBePositive => 'Wartość musi być większa od 0';

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
  String get insulinHalfUnits => 'Pen z dawką 0,5 jedn.';

  @override
  String get insulinHalfUnitsDesc =>
      'Umożliwia dawkowanie z dokładnością do 0,5 jednostki';

  @override
  String get insulinRoundDown => 'Zaokrąglaj bolus w dół';

  @override
  String get insulinRoundDownDesc =>
      'Obcina bolus zamiast zaokrąglać do najbliższej wartości. Przydatne przy dawkowaniu zakresowym (np. 1 jedn. na 50 mg/dL)';

  @override
  String get insulinSaving => 'Zapisywanie...';

  @override
  String get insulinSave => 'Zapisz ustawienia';

  @override
  String get insulinSaved => 'Ustawienia insuliny zapisane';

  @override
  String get insulinOptionalHint =>
      'Pozostaw puste, aby użyć przelicznika bazowego';

  @override
  String get foodSearchTitle => 'Szukaj produktu';

  @override
  String get foodSearchClose => 'Zamknij wyszukiwanie';

  @override
  String get foodSearchHint => 'Np. Jabłko, chleb, ryż...';

  @override
  String get foodSearchEmptyList =>
      'Nie masz jeszcze żadnych produktów na swojej liście.';

  @override
  String foodSearchNoResults(String query) {
    return 'Brak wyników dla \"$query\"';
  }

  @override
  String get barcodeTitle => 'Skanuj kod kreskowy';

  @override
  String get barcodeScannedFood => 'Zeskanowany produkt';

  @override
  String get confirmDeleteTitle => 'Potwierdź usunięcie';

  @override
  String get confirmDeleteCancel => 'Anuluj';

  @override
  String get confirmDeleteButton => 'Usuń';

  @override
  String get updateAvailable => 'Dostępna aktualizacja';

  @override
  String updateVersion(String version) {
    return 'Wersja $version';
  }

  @override
  String get updateLater => 'Później';

  @override
  String get updateDownload => 'Pobierz';

  @override
  String get updateDownloading => 'Pobieranie aktualizacji...';

  @override
  String get updateError =>
      'Pobieranie nie powiodło się. Odwiedź github.com/PokeSer/libretadulce/releases';

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
  String get insulinGlucoseUnitDesc => 'Przełącz między mg/dL a mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Używaj mmol/L zamiast mg/dL';

  @override
  String get calcTabGrams => 'Gramy';

  @override
  String get calcTabRations => 'Wymienniki';

  @override
  String get photoTitle => 'Analiza zdjęcia talerza';

  @override
  String get photoTakeButton => 'Zrób zdjęcie talerza';

  @override
  String get photoAnalyzing => 'Analiza AI...';

  @override
  String get photoAnalyzingHint =>
      'Gemini identyfikuje żywność i szacuje wartości odżywcze';

  @override
  String get photoNoFoodDetected =>
      'Nie udało się przeanalizować zdjęcia. Spróbuj zrobić wyraźniejsze zdjęcie przy dobrym oświetleniu.';

  @override
  String photoError(String error) {
    return 'Błąd: $error';
  }

  @override
  String get photoRetry => 'Spróbuj ponownie';

  @override
  String get photoEmptyHint => 'Zrób zdjęcie swojego talerza do analizy AI';

  @override
  String get photoEmptySubtitle =>
      'Gemini zidentyfikuje żywność, oszacuje porcje i obliczy wartości odżywcze';

  @override
  String get photoResultsTitle => 'Wykryte produkty';

  @override
  String get photoResultsHint =>
      'W razie potrzeby dostosuj gramy i dodaj do talerza';

  @override
  String get photoConfidence => 'pewność';

  @override
  String get photoAddButton => 'Dodaj';

  @override
  String photoAddToPlate(String name) {
    return 'Dodaj $name do talerza';
  }

  @override
  String get photoDone => 'Gotowe';

  @override
  String get photoGramsLabel => 'Gramy';

  @override
  String get photoNoNutrition => 'Brak danych żywieniowych';

  @override
  String get photoCameraButton => 'Analizuj talerz z AI';

  @override
  String get photoApiKeyMissing =>
      'Do analizy AI potrzebny jest klucz API Gemini. Darmowy na aistudio.google.com';

  @override
  String get photoConfigureKey => 'Przejdź do ustawień';

  @override
  String get profileGeminiKey => 'Klucz API Gemini';

  @override
  String get photoPrivacyTitle => 'Prywatność';

  @override
  String get photoPrivacyText =>
      'Zdjęcie twojego talerza zostanie wysłane do Gemini API (Google) w celu analizy. Nie jest przechowywane ani używane do trenowania modeli. Akceptujesz?';

  @override
  String get photoPrivacyCancel => 'Anuluj';

  @override
  String get photoPrivacyAccept => 'Akceptuję';

  @override
  String get photoTipTitle => 'Wskazówka dla lepszego zdjęcia';

  @override
  String get photoTipBody =>
      'Dla najlepszych rezultatów zachowaj odpowiednią odległość od talerza i upewnij się, że wszystkie produkty są widoczne. Najlepiej sprawdza się widok z góry przy dobrym oświetleniu.';

  @override
  String get photoTipChecklist =>
      '• Pokaż cały talerz\n• Dobre naturalne oświetlenie\n• Odległość około 30-40 cm\n• Brak innych przedmiotów wokół';

  @override
  String get photoTipCancel => 'Anuluj';

  @override
  String get photoTipContinue => 'Rozumiem, zrób zdjęcie';

  @override
  String get photoTipDontShowAgain => 'Nie pokazuj więcej tej wskazówki';

  @override
  String get photoGalleryButton => 'Wybierz z galerii';

  @override
  String get photoAiNotesTitle => 'Uwaga dotycząca tego talerza';

  @override
  String get photoDisclaimerTitle => 'Wartości oszacowane przez AI';

  @override
  String get photoDisclaimerText =>
      'Te wartości są przybliżeniami generowanymi przez AI. Do dokładnego liczenia węglowodanów zawsze używaj wagi kuchennej i sprawdzaj etykiety żywieniowe produktów.';

  @override
  String get photoAddFoodsTitle => 'Dodaj każdy produkt do talerza:';

  @override
  String get photoTableFood => 'Produkt';

  @override
  String get photoTableGrams => 'Gramy';

  @override
  String get photoTableCarbs => 'Węglowod.';

  @override
  String get photoTableRations => 'Wymienniki';

  @override
  String get photoTableGI => 'IG';

  @override
  String get photoTableProtein => 'Białko';

  @override
  String get photoTableFat => 'Tłuszcz';

  @override
  String get photoTableFiber => 'Błonnik';

  @override
  String get photoTableTotal => 'RAZEM';

  @override
  String get photoAddAllToPlate => 'Dodaj wszystko do talerza';

  @override
  String get photoAllAdded => 'Wszystko dodane';

  @override
  String get photoAddedToPlate => 'Dodano';

  @override
  String get photoBolusTitle => 'Szacowany bolus insuliny';

  @override
  String photoBolusEstimation(String units, String carbs) {
    return 'Zgodnie z Twoimi ustawieniami, na ${carbs}g węglowodanów potrzebowałbyś $units insuliny. Pamiętaj, że to obliczenie nie uwzględnia korekty glikemii.';
  }

  @override
  String get photoBolusReminder =>
      'To jest wartość szacunkowa. Zawsze sprawdzaj aktualny poziom glukozy, aby zastosować niezbędną korektę i skonsultuj się z lekarzem w sprawie dawek insuliny.';

  @override
  String get profileGeminiKeyHint => 'Wklej tutaj swój klucz API';

  @override
  String get profileGeminiKeyDesc =>
      'Wymagany do analizy żywności AI. Darmowy na aistudio.google.com';

  @override
  String get profileGeminiKeySaved => 'Klucz API zapisany';
}
