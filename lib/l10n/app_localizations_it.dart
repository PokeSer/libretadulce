// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'Caricamento app';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Il tuo assistente personale per il monitoraggio quotidiano di carboidrati e razioni.';

  @override
  String get loginButtonGoogle => 'Accedi con Google';

  @override
  String get loginIniciandoSesion => 'Accesso in corso';

  @override
  String get loginPrivacyText =>
      'I tuoi dati sanitari sono protetti\ne collegati solo al tuo account personale.';

  @override
  String get navCalculator => 'Calcolatrice';

  @override
  String get navFoods => 'Alimenti';

  @override
  String get navGlobal => 'Globale';

  @override
  String get navHistory => 'Cronologia';

  @override
  String get navProfile => 'Profilo';

  @override
  String get navAdminTooltip => 'Amministrazione Globale';

  @override
  String get calcTitle => 'Calcolatrice e Piatto';

  @override
  String get calcGramsMode => 'Ho i grammi\n(Voglio le Razioni)';

  @override
  String get calcRationsMode => 'Voglio le Razioni\n(Dammi i grammi)';

  @override
  String get calcSearchFood => 'Tocca per cercare un alimento...';

  @override
  String get calcSearchFoodAccessibility => 'Cerca alimento';

  @override
  String get calcFoodAccessibility => 'Alimento';

  @override
  String calcSelectedFood(String foodName) {
    return 'Alimento selezionato: $foodName. Tocca per cambiare.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g carboidrati / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Preferiti Rapidi';

  @override
  String get calcInputGramsLabel => 'Quantità in grammi';

  @override
  String get calcInputRationsLabel => 'Razioni da consumare';

  @override
  String get calcInputGramsSuffix => 'grammi';

  @override
  String get calcInputRationsSuffix => 'razioni';

  @override
  String get calcResultTitle => 'RISULTATO';

  @override
  String get calcResultInverseTitle => 'DEVI PESARE';

  @override
  String get calcGramsHC => 'Carboidrati (g)';

  @override
  String get calcRations => 'Razioni';

  @override
  String calcOfFood(String foodName) {
    return 'di $foodName';
  }

  @override
  String get calcAddToPlate => 'Aggiungi al piatto';

  @override
  String get calcMyPlate => 'Il Mio Piatto Attuale';

  @override
  String get calcClear => 'Svuota';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g consumati';
  }

  @override
  String calcRacShort(String rac) {
    return '$rac Raz.';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g HC';
  }

  @override
  String calcFats(String fats) {
    return '${fats}g grassi';
  }

  @override
  String calcProteins(String proteins) {
    return '${proteins}g proteine';
  }

  @override
  String get calcDeleteFromPlate => 'Rimuovi dal piatto';

  @override
  String get calcTotalPlate => 'TOTALE PIATTO:';

  @override
  String calcTotalRac(String rac) {
    return '$rac Raz.';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g HC';
  }

  @override
  String calcTotalFats(String fats) {
    return '${fats}g grassi';
  }

  @override
  String calcTotalProteins(String proteins) {
    return '${proteins}g proteine';
  }

  @override
  String get calcMealTypeLabel => 'Tipo di pasto:';

  @override
  String get calcTimeLabel => 'Ora';

  @override
  String get calcDateLabel => 'Data';

  @override
  String get calcBolusTitle => 'Bolo di Insulina';

  @override
  String get calcGlucoseLabel => 'Glicemia attuale (opzionale)';

  @override
  String get calcGlucoseHint => 'Es.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Bolo pasto';

  @override
  String get calcBolusCorrection => 'Correzione';

  @override
  String get calcBolusTotal => 'Totale';

  @override
  String get calcBolusUnitSuffix => 'unità';

  @override
  String get calcNoFoodsMessage =>
      'Aggiungi alimenti al piatto per vedere il bolo.';

  @override
  String get calcNoMealTypeMessage =>
      'Seleziona il tipo di pasto per calcolare il bolo.';

  @override
  String get calcCalculating => 'Calcolo in corso...';

  @override
  String get calcConfigureMessage =>
      'Configura i tuoi parametri di insulina per vedere il bolo consigliato.';

  @override
  String get calcConfigureButton => 'Configura';

  @override
  String get calcSaveHistory => 'Salva nella Cronologia Giornaliera';

  @override
  String get calcSaveTitle => 'Salva nella Cronologia';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Salvato come $mealType. Bolo: $bolus unità';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Salvato come $mealType con successo';
  }

  @override
  String calcSaveError(String error) {
    return 'Errore durante il salvataggio: $error';
  }

  @override
  String get calcUndo => 'Annulla';

  @override
  String calcItemRemoved(Object name) {
    return '$name rimosso';
  }

  @override
  String get calcMustLogin => 'Devi accedere';

  @override
  String get calcGramsModeAccessibility => 'Ho i grammi, calcola le razioni';

  @override
  String get calcRationsModeAccessibility =>
      'Voglio mangiare razioni, calcola i grammi';

  @override
  String calcRepeatLastMeal(String mealType) {
    return 'Ripeti ultimo $mealType';
  }

  @override
  String get calcRepeatLastMealTooltip => 'Ripeti pasto';

  @override
  String get calcSaveAsTemplate => 'Salva come modello';

  @override
  String get calcTemplateNameHint => 'Es: La mia colazione abituale';

  @override
  String get calcTemplateNameRequired => 'Inserisci un nome per il modello';

  @override
  String get calcTemplateSaved => 'Modello salvato';

  @override
  String get calcLoadTemplate => 'Carica modello';

  @override
  String get calcNoTemplates => 'Nessun modello salvato';

  @override
  String calcTemplateLoaded(String name) {
    return 'Modello \"$name\" caricato';
  }

  @override
  String get calcDeleteTemplate => 'Elimina modello';

  @override
  String calcDeleteTemplateConfirm(String name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get mealTypeBreakfast => 'Colazione';

  @override
  String get mealTypeMidMorning => 'Spuntino di metà mattina';

  @override
  String get mealTypeLunch => 'Pranzo';

  @override
  String get mealTypeAfternoonSnack => 'Merenda';

  @override
  String get mealTypeDinner => 'Cena';

  @override
  String get mealTypeSnack => 'Spuntino / Altro';

  @override
  String get historyDaily => 'Giornaliera';

  @override
  String get historyWeekly => 'Settimanale';

  @override
  String get historyExportButton => 'Esporta';

  @override
  String get historyExportOptionsTitle => 'Esporta dati';

  @override
  String get historyPdfExportOption => 'Report PDF';

  @override
  String get historyPdfExportSubtitle =>
      'Documento professionale per il medico';

  @override
  String get historyCsvExportOption => 'Foglio CSV';

  @override
  String get historyCsvExportSubtitle => 'Per analisi in Excel o Google Sheets';

  @override
  String get historyPdfButton => 'Report PDF';

  @override
  String get historyPdfTitle => 'Report di Controllo Glicemico';

  @override
  String historyPdfSubtitle(String name, String date) {
    return 'Paziente: $name · Generato: $date';
  }

  @override
  String get historyPdfFileName => 'report_libretadulce.pdf';

  @override
  String get historyPdfAvgCarbs => 'Media HC/giorno';

  @override
  String get historyPdfAvgGlucose => 'Glicemia media';

  @override
  String get historyPdfAvgInsulin => 'Media insulina/dose';

  @override
  String get historyPdfDays => 'Giorni';

  @override
  String get historyPdfMeals => 'Pasti';

  @override
  String get historyPdfPeriod => 'Periodo';

  @override
  String get historyPdfFood => 'Alimento';

  @override
  String get historyPdfMealType => 'Tipo';

  @override
  String get historyPdfGlucose => 'Glicemia';

  @override
  String get historyPdfDateRangeTitle => 'Seleziona date';

  @override
  String get historyPdfFrom => 'Da';

  @override
  String get historyPdfTo => 'A';

  @override
  String get historyPdfGenerate => 'Genera PDF';

  @override
  String get historyPdfDisclaimer =>
      'Questo report è stato generato da Libreta Dulce. I dati provengono dai registri dell\'utente e non sostituiscono il giudizio medico professionale. Consultare sempre il proprio team sanitario.';

  @override
  String get historyPdfError => 'Errore durante la generazione del PDF';

  @override
  String get historyPdfEmpty => 'Nessun dato per generare il report';

  @override
  String get historyExportAccessibility => 'Esporta cronologia in CSV';

  @override
  String get historyPrevDay => 'Giorno precedente';

  @override
  String get historyNextDay => 'Giorno successivo';

  @override
  String get historyToday => 'OGGI';

  @override
  String get historyDailyAccessibility => 'Vista giornaliera';

  @override
  String get historyWeeklyAccessibility => 'Vista settimanale';

  @override
  String get historyLoading => 'Caricamento cronologia';

  @override
  String historyErrorLoading(String error) {
    return 'Errore: $error';
  }

  @override
  String get historyNoRecords => 'Nessun registro per questo giorno.';

  @override
  String get historyMustLogin => 'Devi accedere';

  @override
  String get historyTotalRations => 'Totale Razioni';

  @override
  String get historyTotalCarbs => 'Totale Carboidrati';

  @override
  String get historyTotalFats => 'Grassi';

  @override
  String get historyTotalProteins => 'Proteine';

  @override
  String get historySubtotal => 'SUBTOTALE:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac Razioni (${carbs}g HC)';
  }

  @override
  String get historyBolus => 'BOLO:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus unità di insulina';
  }

  @override
  String get historyDeleteTitle => 'Elimina Pasto';

  @override
  String get historyDeleteConfirm =>
      'Sei sicuro di voler eliminare questo registro dalla cronologia?';

  @override
  String get historyDeleteButton => 'Elimina';

  @override
  String get historyCancelButton => 'Annulla';

  @override
  String get historyDeleteSuccess => 'Registro eliminato';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Elimina $mealType';
  }

  @override
  String get historyEditButton => 'Modifica';

  @override
  String get historyEditTitle => 'Modifica voce';

  @override
  String get historyEditSave => 'Salva modifiche';

  @override
  String get historyEditSuccess => 'Voce aggiornata';

  @override
  String get historyEditGramsLabel => 'Grammi';

  @override
  String get historyNoData7Days => 'Nessun dato negli ultimi 7 giorni.';

  @override
  String get historyLast7Days => 'Ultimi 7 giorni';

  @override
  String get historyGlucoseInRange => 'In range';

  @override
  String get historyGlucoseHigh => 'Alta';

  @override
  String get historyGlucoseLow => 'Bassa';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g HC';
  }

  @override
  String get historyExportEmpty => 'Nessun dato da esportare.';

  @override
  String get historyCsvHeader =>
      'Data,Ora,Tipo pasto,Alimento,Grammi,Razioni,Carboidrati (g)';

  @override
  String get historyShareSubject => 'Cronologia Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'Errore durante l\'esportazione: $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g di $name';
  }

  @override
  String historyRacShort(String rac) {
    return '$rac Raz.';
  }

  @override
  String get profileNotLoggedIn => 'Non connesso';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Foto profilo di $name';
  }

  @override
  String get profileDefaultName => 'Utente';

  @override
  String get profileAboutTitle => 'Informazioni su Libreta Dulce';

  @override
  String get profileAboutSubtitle => 'Fatto con amore da e per diabetici';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Ciao, sono uno sviluppatore indipendente e ho creato quest\'app per aiutare a gestire carboidrati e razioni quotidianamente. Se hai suggerimenti o trovi bug, condividili pure.';

  @override
  String get profileAboutDialogClose => 'Chiudi';

  @override
  String get profileInsulinSettings => 'Parametri Insulina';

  @override
  String get profileInsulinSettingsDesc =>
      'Rapporto, fattore di correzione e glicemia target';

  @override
  String get profileLogout => 'Disconnetti';

  @override
  String get profileLogoutConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get profileLogoutCancel => 'Annulla';

  @override
  String get profileLogoutButton => 'Disconnetti';

  @override
  String get profileLogoutDialogTitle => 'Disconnetti';

  @override
  String get adminTitle => 'Richieste e Pannello Globale';

  @override
  String get adminTabRequests => 'Nuove Richieste';

  @override
  String get adminTabGlobal => 'Dati Globali';

  @override
  String get adminApproved => 'Alimento approvato e pubblicato';

  @override
  String get adminRejected => 'Richiesta rifiutata';

  @override
  String get adminDeleted => 'Alimento eliminato globalmente';

  @override
  String get adminEditTitle => 'Modifica Alimento Globale';

  @override
  String get adminNameLabel => 'Nome';

  @override
  String get adminCarbsLabel => 'Carboidrati per 100g';

  @override
  String get adminCancelButton => 'Annulla';

  @override
  String get adminSaveButton => 'Salva';

  @override
  String get adminUpdated => 'Alimento aggiornato';

  @override
  String get adminNoRequests =>
      'Tutto a posto! Nessuna nuova richiesta di alimenti in sospeso.';

  @override
  String get adminNoName => 'Senza nome';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Carboidrati: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Link/Info extra: $url';
  }

  @override
  String get adminRejectButton => 'Rifiuta';

  @override
  String get adminApproveButton => 'Approva';

  @override
  String get adminEmptyGlobal => 'Il database globale è vuoto.';

  @override
  String get adminGlobalFood => 'Alimento globale';

  @override
  String get adminEditGlobal => 'Modifica globale';

  @override
  String get adminDeleteGlobal => 'Elimina alimento globale';

  @override
  String get adminDeleteConfirm => 'Eliminare alimento?';

  @override
  String get adminDeleteWarning =>
      'Questo lo rimuoverà dal database pubblico. Gli utenti non potranno più cercarlo.';

  @override
  String get adminDeleteButton => 'Elimina';

  @override
  String get adminLoadingRequests => 'Caricamento richieste';

  @override
  String get globalSearch => 'Cerca nel database globale...';

  @override
  String get globalLoading => 'Caricamento alimenti globali';

  @override
  String get globalNoResults => 'Nessun alimento trovato.';

  @override
  String get globalGlobalFood => 'Alimento globale';

  @override
  String get globalCopyToMyFoods => 'Copia nei Miei Alimenti';

  @override
  String get globalSuggestProduct => 'Suggerisci Prodotto';

  @override
  String get globalScanning => 'Ricerca OpenFoodFacts...';

  @override
  String get globalFound => 'Prodotto trovato!';

  @override
  String get globalNotFound => 'Prodotto non trovato';

  @override
  String get globalRequestTitle => 'Nuovo alimento';

  @override
  String get globalRequestDesc =>
      'La tua richiesta sarà esaminata da una persona prima di essere aggiunta al database globale.';

  @override
  String get globalRequestName => 'Nome del prodotto';

  @override
  String get globalRequestBrand => 'Marca o Descrizione';

  @override
  String get globalRequestCarbs => 'Carboidrati per 100g';

  @override
  String get globalRequestUrl => 'Link del prodotto (Opzionale)';

  @override
  String get globalRequestCancel => 'Annulla';

  @override
  String get globalRequestSent => 'Richiesta inviata. Grazie!';

  @override
  String get globalRequestSend => 'Invia Richiesta';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name aggiunto ai tuoi alimenti';
  }

  @override
  String get globalScanTooltip => 'Scansiona codice a barre';

  @override
  String get globalNotFoundDB => 'Prodotto non trovato nel database';

  @override
  String get globalConnectionError => 'Errore di connessione';

  @override
  String globalErrorFirebase(String error) {
    return 'Errore Firebase: $error';
  }

  @override
  String get serviceError => 'Si è verificato un errore. Riprova.';

  @override
  String get foodsAddTitle => 'Aggiungi alimento';

  @override
  String get foodsScanTooltip => 'Scansiona codice a barre';

  @override
  String get foodsNameLabel => 'Nome (es. Mela)';

  @override
  String get foodsBrandLabel => 'Marca o Desc. (Opzionale)';

  @override
  String get foodsCarbsLabel => 'Carboidrati per 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'Proteine';

  @override
  String get foodsFatLabel => 'Grassi';

  @override
  String get foodsCancel => 'Annulla';

  @override
  String get foodsSave => 'Salva';

  @override
  String get foodsNameRequired => 'Il nome dell\'alimento è obbligatorio.';

  @override
  String get foodsCarbsRequired => 'I carboidrati per 100g sono obbligatori.';

  @override
  String get foodsCarbsInvalid =>
      'Il valore dei carboidrati non è un numero valido.';

  @override
  String get foodsSearch => 'Cerca alimento...';

  @override
  String get foodsMustLogin => 'Devi accedere';

  @override
  String get foodsLoadingError => 'Errore nel caricamento del database.';

  @override
  String get foodsEmpty =>
      'Non hai ancora alimenti salvati.\nAggiungi il primo!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Sei sicuro di voler eliminare \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'Aggiungi ai preferiti';

  @override
  String get foodsRemoveFromFavorites => 'Rimuovi dai preferiti';

  @override
  String foodsDeleteTooltip(String name) {
    return 'Elimina $name';
  }

  @override
  String get foodsDetailTitle => 'Valori per 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'Carboidrati: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Calorie: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'Proteine: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Grassi: ${value}g';
  }

  @override
  String get foodsDetailClose => 'Chiudi';

  @override
  String get foodsNewFood => 'Nuovo Alimento';

  @override
  String get foodsFavoriteAccessibility => 'Preferito';

  @override
  String get foodsFoodAccessibility => 'Alimento';

  @override
  String get foodsSearchAccessibility => 'Alimento globale';

  @override
  String get insulinTitle => 'Parametri Insulina';

  @override
  String get insulinDesc =>
      'Questi valori sono personali e privati. Configurarli consente all\'app di calcolare il bolo di insulina consigliato.';

  @override
  String get insulinRatioTitle => 'Rapporto insulina (unità per razione)';

  @override
  String get insulinRatioBase => 'Rapporto base *';

  @override
  String get insulinRatioHint => 'Es.: 1,5';

  @override
  String get insulinRatioSuffix => 'unità / razione';

  @override
  String get insulinRatioRequired => 'Il rapporto base è obbligatorio';

  @override
  String get insulinInvalidNumber => 'Inserisci un numero valido';

  @override
  String get insulinMealRatios => 'Rapporti specifici per pasto (opzionale)';

  @override
  String get insulinFactorTitle => 'Fattore di correzione';

  @override
  String get insulinFactorLabel => 'Fattore di correzione *';

  @override
  String get insulinFactorHint => 'Es.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL per unità';

  @override
  String get insulinFactorRequired => 'Il fattore di correzione è obbligatorio';

  @override
  String get insulinMustBePositive => 'Deve essere maggiore di 0';

  @override
  String get insulinGlucoseTargetTitle => 'Glicemia target *';

  @override
  String get insulinGlucoseTargetLabel => 'Glicemia target *';

  @override
  String get insulinGlucoseTargetHint => 'Es.: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired =>
      'La glicemia target è obbligatoria';

  @override
  String get insulinHalfUnits => 'Penna mezza unità';

  @override
  String get insulinHalfUnitsDesc =>
      'Consente dosi con incrementi di 0,5 unità';

  @override
  String get insulinRoundDown => 'Arrotonda bolo per difetto';

  @override
  String get insulinRoundDownDesc =>
      'Tronca il bolo invece di arrotondare al più vicino. Utile se dosi per fasce (es.: 1 unità ogni 50 mg/dL)';

  @override
  String get insulinSaving => 'Salvataggio...';

  @override
  String get insulinSave => 'Salva Parametri';

  @override
  String get insulinSaved => 'Parametri insulina salvati';

  @override
  String get insulinOptionalHint => 'Lascia vuoto per usare il rapporto base';

  @override
  String get foodSearchTitle => 'Cerca Alimento';

  @override
  String get foodSearchClose => 'Chiudi ricerca';

  @override
  String get foodSearchHint => 'Es. Mela, pane, riso...';

  @override
  String get foodSearchEmptyList => 'Non hai ancora alimenti nella tua lista.';

  @override
  String foodSearchNoResults(String query) {
    return 'Nessun risultato per \"$query\"';
  }

  @override
  String get barcodeTitle => 'Scansiona codice a barre';

  @override
  String get barcodeScannedFood => 'Alimento scansionato';

  @override
  String get confirmDeleteTitle => 'Conferma eliminazione';

  @override
  String get confirmDeleteCancel => 'Annulla';

  @override
  String get confirmDeleteButton => 'Elimina';

  @override
  String get updateAvailable => 'Aggiornamento disponibile';

  @override
  String updateVersion(String version) {
    return 'Versione $version';
  }

  @override
  String get updateLater => 'Dopo';

  @override
  String get updateDownload => 'Scarica';

  @override
  String get updateDownloading => 'Scaricamento aggiornamento...';

  @override
  String get updateError =>
      'Download fallito. Visita github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Novità';

  @override
  String get profileThemeLabel => 'Tema dell\'app';

  @override
  String get profileThemeSystem => 'Sistema';

  @override
  String get profileThemeLight => 'Chiaro';

  @override
  String get profileThemeDark => 'Scuro';

  @override
  String get profileSettingsSectionApp => 'Applicazione';

  @override
  String get profileSettingsSectionHealth => 'Salute';

  @override
  String get profileSettings => 'Impostazioni';

  @override
  String get insulinGlucoseUnit => 'Unità glicemica';

  @override
  String get insulinGlucoseUnitDesc => 'Passa da mg/dL a mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Usa mmol/L invece di mg/dL';

  @override
  String get calcTabGrams => 'Grammi';

  @override
  String get calcTabRations => 'Razioni';

  @override
  String get photoTitle => 'Analizza foto del piatto';

  @override
  String get photoTakeButton => 'Scatta foto al piatto';

  @override
  String get photoAnalyzing => 'Analisi IA in corso...';

  @override
  String get photoAnalyzingHint =>
      'Gemini sta identificando gli alimenti e stimando i valori nutrizionali';

  @override
  String get photoNoFoodDetected =>
      'Impossibile analizzare la foto. Prova con un\'immagine più nitida e una buona illuminazione.';

  @override
  String photoError(String error) {
    return 'Errore: $error';
  }

  @override
  String get photoRetry => 'Riprova';

  @override
  String get photoEmptyHint =>
      'Scatta una foto al tuo piatto per l\'analisi IA';

  @override
  String get photoEmptySubtitle =>
      'Gemini identificherà gli alimenti, stimerà le porzioni e calcolerà i valori nutrizionali';

  @override
  String get photoResultsTitle => 'Alimenti rilevati';

  @override
  String get photoResultsHint =>
      'Regola i grammi se necessario e aggiungi al piatto';

  @override
  String get photoConfidence => 'affidabilità';

  @override
  String get photoAddButton => 'Aggiungi';

  @override
  String photoAddToPlate(String name) {
    return 'Aggiungi $name al piatto';
  }

  @override
  String get photoDone => 'Fatto';

  @override
  String get photoGramsLabel => 'Grammi';

  @override
  String get photoNoNutrition => 'Nessun dato nutrizionale';

  @override
  String get photoCameraButton => 'Analizza piatto con IA';

  @override
  String get photoApiKeyMissing =>
      'Per usare l\'analisi IA serve una chiave API Gemini. Gratuita su aistudio.google.com';

  @override
  String get photoConfigureKey => 'Vai alle impostazioni';

  @override
  String get profileGeminiKey => 'Chiave API Gemini';

  @override
  String get photoPrivacyTitle => 'Privacy';

  @override
  String get photoPrivacyText =>
      'La foto del tuo piatto sarà inviata all\'API Gemini (Google) per l\'analisi. Non viene archiviata né usata per l\'addestramento. Accetti?';

  @override
  String get photoPrivacyCancel => 'Annulla';

  @override
  String get photoPrivacyAccept => 'Accetta';

  @override
  String get photoTipTitle => 'Consiglio per una foto migliore';

  @override
  String get photoTipBody =>
      'Per risultati migliori, mantieni una distanza adeguata dal piatto e assicurati che tutti gli alimenti siano visibili. Una vista dall\'alto con una buona illuminazione funziona meglio.';

  @override
  String get photoTipChecklist =>
      '• Mostra l\'intero piatto\n• Buona illuminazione naturale\n• Distanza di circa 30-40 cm\n• Nessun altro oggetto intorno';

  @override
  String get photoTipCancel => 'Annulla';

  @override
  String get photoTipContinue => 'Capito, scatta foto';

  @override
  String get photoTipDontShowAgain => 'Non mostrare più questo avviso';

  @override
  String get photoGalleryButton => 'Scegli dalla galleria';

  @override
  String get photoAiNotesTitle => 'Nota su questo piatto';

  @override
  String get photoDisclaimerTitle => 'Valori stimati dall\'IA';

  @override
  String get photoDisclaimerText =>
      'Questi valori sono approssimazioni generate dall\'IA. Per un conteggio preciso dei carboidrati, usa sempre una bilancia da cucina e controlla le etichette nutrizionali.';

  @override
  String get photoAddFoodsTitle => 'Aggiungi ogni alimento al tuo piatto:';

  @override
  String get photoTableFood => 'Alimento';

  @override
  String get photoTableGrams => 'Grammi';

  @override
  String get photoTableCarbs => 'Carboidrati';

  @override
  String get photoTableRations => 'Razioni';

  @override
  String get photoTableGI => 'IG';

  @override
  String get photoTableProtein => 'Proteine';

  @override
  String get photoTableFat => 'Grassi';

  @override
  String get photoTableFiber => 'Fibre';

  @override
  String get photoTableTotal => 'TOTALE';

  @override
  String get photoAddAllToPlate => 'Aggiungi tutto al piatto';

  @override
  String get photoAllAdded => 'Tutto aggiunto';

  @override
  String get photoAddedToPlate => 'Aggiunto';

  @override
  String get photoBolusTitle => 'Bolo di insulina stimato';

  @override
  String photoBolusEstimation(String units, String carbs) {
    return 'In base alle tue impostazioni, per ${carbs}g di carboidrati avresti bisogno di $units di insulina. Ricorda che questo calcolo non include la correzione glicemica.';
  }

  @override
  String get photoBolusReminder =>
      'Questa è una stima. Controlla sempre la glicemia attuale per applicare la correzione necessaria e consulta il medico per qualsiasi dubbio sulla terapia insulinica.';

  @override
  String get profileGeminiKeyHint => 'Incolla qui la tua chiave API';

  @override
  String get profileGeminiKeyDesc =>
      'Necessaria per l\'analisi IA degli alimenti. Gratuita su aistudio.google.com';

  @override
  String get profileGeminiKeySaved => 'Chiave API salvata';

  @override
  String get historyAiAnalyzeButton => 'Analizza con IA';

  @override
  String get historyAiAnalyzing => 'Analisi del pasto...';

  @override
  String get historyAiGlycemicProfile => 'Profilo glicemico';

  @override
  String get historyAiGlycemicHigh => 'ALTO';

  @override
  String get historyAiGlycemicMedium => 'MODERATO';

  @override
  String get historyAiGlycemicLow => 'BASSO';

  @override
  String get historyAiInsulinTiming => 'Timing insulina';

  @override
  String get historyAiTips => 'Consigli';

  @override
  String get historyAiPostMeal => 'Dopo il pasto';

  @override
  String get historyAiDeleteAnalysis => 'Elimina analisi';

  @override
  String get historyAiError => 'Analisi fallita. Riprovare.';

  @override
  String get historyAiNoKey =>
      'Configura la tua chiave Gemini nelle impostazioni per usare questa funzione.';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get aiErrorNoApiKey =>
      'Nessuna chiave API Gemini configurata. Aggiungine una nelle impostazioni.';

  @override
  String get aiErrorImageTooLarge =>
      'Immagine troppo grande. Usa una foto più piccola.';

  @override
  String get aiErrorInvalidApiKey =>
      'Chiave API non valida. Controlla la tua chiave nelle impostazioni.';

  @override
  String get aiErrorQuotaExceeded =>
      'Limite giornaliero di richieste raggiunto. Riprova domani.';

  @override
  String get aiErrorNoModelAccess =>
      'La tua chiave API non ha accesso a questo modello. Controlla aistudio.google.com.';

  @override
  String get aiErrorServiceUnavailable =>
      'Servizio temporaneamente non disponibile. Riprova tra un momento.';

  @override
  String get aiErrorTimeout =>
      'L\'analisi sta impiegando troppo tempo. Riprova.';

  @override
  String get aiErrorNetwork =>
      'Errore di rete. Controlla la connessione e riprova.';

  @override
  String get aiErrorBlockedContent =>
      'Impossibile analizzare la foto. Assicurati che mostri cibo, non persone o contenuti sensibili.';

  @override
  String get aiErrorNoFood =>
      'Nessun alimento rilevato. Prova con una foto più nitida del piatto intero dall\'alto.';

  @override
  String get aiErrorCouldNotProcess =>
      'Impossibile elaborare il risultato. Riprova con una foto più nitida.';

  @override
  String get aiErrorEmptyResponse => 'Nessuna risposta ricevuta. Riprova.';

  @override
  String get aiErrorUnknown => 'Qualcosa è andato storto. Riprova.';
}
