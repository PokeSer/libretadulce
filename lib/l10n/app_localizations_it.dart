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
  String get calcMealTypeLabel => 'Tipo di pasto:';

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
  String get calcMustLogin => 'Devi accedere';

  @override
  String get calcGramsModeAccessibility => 'Ho i grammi, calcola le razioni';

  @override
  String get calcRationsModeAccessibility =>
      'Voglio mangiare razioni, calcola i grammi';

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
  String get historyNoData7Days => 'Nessun dato negli ultimi 7 giorni.';

  @override
  String get historyLast7Days => 'Ultimi 7 giorni';

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
}
