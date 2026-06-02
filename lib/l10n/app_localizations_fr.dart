// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'Chargement de l\'appli';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Votre assistant personnel pour le suivi quotidien des glucides et des rations.';

  @override
  String get loginButtonGoogle => 'Continuer avec Google';

  @override
  String get loginIniciandoSesion => 'Connexion en cours';

  @override
  String get loginPrivacyText =>
      'Vos donnÃ©es de santÃ© sont protÃ©gÃ©es\net liÃ©es uniquement Ã  votre compte personnel.';

  @override
  String get navCalculator => 'Calculateur';

  @override
  String get navFoods => 'Aliments';

  @override
  String get navGlobal => 'Global';

  @override
  String get navHistory => 'Historique';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAdminTooltip => 'Administration Globale';

  @override
  String get calcTitle => 'Calculateur et Assiette';

  @override
  String get calcGramsMode => 'J\'ai les grammes\n(Je veux les Rations)';

  @override
  String get calcRationsMode => 'Je veux des Rations\n(Donnez-moi les grammes)';

  @override
  String get calcSearchFood => 'Appuyez pour chercher un aliment...';

  @override
  String get calcSearchFoodAccessibility => 'Chercher un aliment';

  @override
  String get calcFoodAccessibility => 'Aliment';

  @override
  String calcSelectedFood(String foodName) {
    return 'Aliment sÃ©lectionnÃ© : $foodName. Appuyez pour changer.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g de glucides / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Favoris Rapides';

  @override
  String get calcInputGramsLabel => 'QuantitÃ© en grammes';

  @override
  String get calcInputRationsLabel => 'Rations Ã  consommer';

  @override
  String get calcInputGramsSuffix => 'grammes';

  @override
  String get calcInputRationsSuffix => 'rations';

  @override
  String get calcResultTitle => 'RÃ‰SULTAT';

  @override
  String get calcResultInverseTitle => 'VOUS DEVEZ PESER';

  @override
  String get calcGramsHC => 'Glucides (g)';

  @override
  String get calcRations => 'Rations';

  @override
  String calcOfFood(String foodName) {
    return 'de $foodName';
  }

  @override
  String get calcAddToPlate => 'Ajouter Ã  l\'assiette';

  @override
  String get calcMyPlate => 'Mon Assiette Actuelle';

  @override
  String get calcClear => 'Vider';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g consommÃ©s';
  }

  @override
  String calcRacShort(String rac) {
    return '$rac Rac.';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g HC';
  }

  @override
  String get calcDeleteFromPlate => 'Retirer de l\'assiette';

  @override
  String get calcTotalPlate => 'TOTAL ASSIETTE :';

  @override
  String calcTotalRac(String rac) {
    return '$rac Rac.';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g HC';
  }

  @override
  String get calcMealTypeLabel => 'Type de repas :';

  @override
  String get calcTimeLabel => 'Heure';

  @override
  String get calcDateLabel => 'Date';

  @override
  String get calcBolusTitle => 'Bolus d\'Insuline';

  @override
  String get calcGlucoseLabel => 'GlycÃ©mie actuelle (optionnel)';

  @override
  String get calcGlucoseHint => 'Ex. : 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Bolus repas';

  @override
  String get calcBolusCorrection => 'Correction';

  @override
  String get calcBolusTotal => 'Total';

  @override
  String get calcBolusUnitSuffix => 'unitÃ©s';

  @override
  String get calcNoFoodsMessage =>
      'Ajoutez des aliments Ã  l\'assiette pour voir le bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'SÃ©lectionnez le type de repas pour calculer le bolus.';

  @override
  String get calcCalculating => 'Calcul en cours...';

  @override
  String get calcConfigureMessage =>
      'Configurez vos paramÃ¨tres d\'insuline pour voir le bolus recommandÃ©.';

  @override
  String get calcConfigureButton => 'Configurer';

  @override
  String get calcSaveHistory => 'Enregistrer dans l\'Historique Quotidien';

  @override
  String get calcSaveTitle => 'Enregistrer dans l\'Historique';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'EnregistrÃ© comme $mealType. Bolus : $bolus unitÃ©s';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'EnregistrÃ© comme $mealType avec succÃ¨s';
  }

  @override
  String calcSaveError(String error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String get calcUndo => 'Annuler';

  @override
  String calcItemRemoved(Object name) {
    return '$name supprimÃ©';
  }

  @override
  String get calcMustLogin => 'Vous devez vous connecter';

  @override
  String get calcGramsModeAccessibility =>
      'J\'ai les grammes, calculer les rations';

  @override
  String get calcRationsModeAccessibility =>
      'Je veux manger des rations, calculer les grammes';

  @override
  String get mealTypeBreakfast => 'Petit-dÃ©jeuner';

  @override
  String get mealTypeMidMorning => 'Collation du matin';

  @override
  String get mealTypeLunch => 'DÃ©jeuner';

  @override
  String get mealTypeAfternoonSnack => 'GoÃ»ter';

  @override
  String get mealTypeDinner => 'DÃ®ner';

  @override
  String get mealTypeSnack => 'Collation / Autre';

  @override
  String get historyDaily => 'Quotidien';

  @override
  String get historyWeekly => 'Hebdomadaire';

  @override
  String get historyExportButton => 'Exporter';

  @override
  String get historyExportAccessibility => 'Exporter l\'historique en CSV';

  @override
  String get historyPrevDay => 'Jour prÃ©cÃ©dent';

  @override
  String get historyNextDay => 'Jour suivant';

  @override
  String get historyToday => 'AUJOURD\'HUI';

  @override
  String get historyDailyAccessibility => 'Vue quotidienne';

  @override
  String get historyWeeklyAccessibility => 'Vue hebdomadaire';

  @override
  String get historyLoading => 'Chargement de l\'historique';

  @override
  String historyErrorLoading(String error) {
    return 'Erreur : $error';
  }

  @override
  String get historyNoRecords => 'Aucun enregistrement pour ce jour.';

  @override
  String get historyMustLogin => 'Vous devez vous connecter';

  @override
  String get historyTotalRations => 'Total Rations';

  @override
  String get historyTotalCarbs => 'Total Glucides';

  @override
  String get historySubtotal => 'SOUS-TOTAL :';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac Rations (${carbs}g HC)';
  }

  @override
  String get historyBolus => 'BOLUS :';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus unitÃ©s d\'insuline';
  }

  @override
  String get historyDeleteTitle => 'Supprimer le Repas';

  @override
  String get historyDeleteConfirm =>
      'ÃŠtes-vous sÃ»r de vouloir supprimer cet enregistrement de l\'historique ?';

  @override
  String get historyDeleteButton => 'Supprimer';

  @override
  String get historyCancelButton => 'Annuler';

  @override
  String get historyDeleteSuccess => 'Enregistrement supprimÃ©';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Supprimer $mealType';
  }

  @override
  String get historyEditButton => 'Modifier';

  @override
  String get historyEditTitle => 'Modifier l\'entrÃ©e';

  @override
  String get historyEditSave => 'Enregistrer';

  @override
  String get historyEditSuccess => 'EntrÃ©e mise Ã  jour';

  @override
  String get historyEditGramsLabel => 'Grammes';

  @override
  String get historyNoData7Days => 'Aucune donnÃ©e dans les 7 derniers jours.';

  @override
  String get historyLast7Days => '7 derniers jours';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g HC';
  }

  @override
  String get historyExportEmpty => 'Aucune donnÃ©e Ã  exporter.';

  @override
  String get historyCsvHeader =>
      'Date,Heure,Type de repas,Aliment,Grammes,Rations,Glucides (g)';

  @override
  String get historyShareSubject => 'Historique Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'Erreur lors de l\'export : $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g de $name';
  }

  @override
  String historyRacShort(String rac) {
    return '$rac Rac.';
  }

  @override
  String get profileNotLoggedIn => 'Non connectÃ©';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Photo de profil de $name';
  }

  @override
  String get profileDefaultName => 'Utilisateur';

  @override
  String get profileAboutTitle => 'Ã€ propos de Libreta Dulce';

  @override
  String get profileAboutSubtitle =>
      'Fait avec amour par et pour les diabÃ©tiques';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Bonjour, je suis un dÃ©veloppeur indÃ©pendant et j\'ai crÃ©Ã© cette appli pour aider Ã  gÃ©rer les glucides et les rations au quotidien. Si vous avez des suggestions ou trouvez des bugs, n\'hÃ©sitez pas Ã  les partager.';

  @override
  String get profileAboutDialogClose => 'Fermer';

  @override
  String get profileInsulinSettings => 'ParamÃ¨tres d\'Insuline';

  @override
  String get profileInsulinSettingsDesc =>
      'Ratio, facteur de correction et glycÃ©mie cible';

  @override
  String get profileLogout => 'DÃ©connexion';

  @override
  String get profileLogoutConfirm =>
      'ÃŠtes-vous sÃ»r de vouloir vous dÃ©connecter ?';

  @override
  String get profileLogoutCancel => 'Annuler';

  @override
  String get profileLogoutButton => 'Se dÃ©connecter';

  @override
  String get profileLogoutDialogTitle => 'DÃ©connexion';

  @override
  String get adminTitle => 'Demandes et Panneau Global';

  @override
  String get adminTabRequests => 'Nouvelles Demandes';

  @override
  String get adminTabGlobal => 'DonnÃ©es Globales';

  @override
  String get adminApproved => 'Aliment approuvÃ© et publiÃ©';

  @override
  String get adminRejected => 'Demande rejetÃ©e';

  @override
  String get adminDeleted => 'Aliment supprimÃ© globalement';

  @override
  String get adminEditTitle => 'Modifier l\'Aliment Global';

  @override
  String get adminNameLabel => 'Nom';

  @override
  String get adminCarbsLabel => 'Glucides pour 100g';

  @override
  String get adminCancelButton => 'Annuler';

  @override
  String get adminSaveButton => 'Enregistrer';

  @override
  String get adminUpdated => 'Aliment mis Ã  jour';

  @override
  String get adminNoRequests =>
      'Tout est bon ! Aucune nouvelle demande d\'aliment en attente.';

  @override
  String get adminNoName => 'Sans nom';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Glucides : ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Lien/Info suppl. : $url';
  }

  @override
  String get adminRejectButton => 'Rejeter';

  @override
  String get adminApproveButton => 'Approuver';

  @override
  String get adminEmptyGlobal => 'La base de donnÃ©es globale est vide.';

  @override
  String get adminGlobalFood => 'Aliment global';

  @override
  String get adminEditGlobal => 'Modifier global';

  @override
  String get adminDeleteGlobal => 'Supprimer l\'aliment global';

  @override
  String get adminDeleteConfirm => 'Supprimer l\'aliment ?';

  @override
  String get adminDeleteWarning =>
      'Cela le retirera de la base de donnÃ©es publique. Les utilisateurs ne pourront plus le rechercher.';

  @override
  String get adminDeleteButton => 'Supprimer';

  @override
  String get adminLoadingRequests => 'Chargement des demandes';

  @override
  String get globalSearch => 'Rechercher dans la base globale...';

  @override
  String get globalLoading => 'Chargement des aliments globaux';

  @override
  String get globalNoResults => 'Aucun aliment trouvÃ©.';

  @override
  String get globalGlobalFood => 'Aliment global';

  @override
  String get globalCopyToMyFoods => 'Copier dans Mes Aliments';

  @override
  String get globalSuggestProduct => 'SuggÃ©rer un Produit';

  @override
  String get globalScanning => 'Recherche OpenFoodFacts...';

  @override
  String get globalFound => 'Produit trouvÃ© !';

  @override
  String get globalNotFound => 'Produit introuvable';

  @override
  String get globalRequestTitle => 'Nouvel aliment';

  @override
  String get globalRequestDesc =>
      'Votre demande sera examinÃ©e par un humain avant d\'Ãªtre ajoutÃ©e Ã  la base de donnÃ©es globale.';

  @override
  String get globalRequestName => 'Nom du produit';

  @override
  String get globalRequestBrand => 'Marque ou Description';

  @override
  String get globalRequestCarbs => 'Glucides pour 100g';

  @override
  String get globalRequestUrl => 'Lien du produit (Optionnel)';

  @override
  String get globalRequestCancel => 'Annuler';

  @override
  String get globalRequestSent => 'Demande envoyÃ©e. Merci !';

  @override
  String get globalRequestSend => 'Envoyer la Demande';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name ajoutÃ© Ã  vos aliments';
  }

  @override
  String get globalScanTooltip => 'Scanner le code-barres';

  @override
  String get globalNotFoundDB => 'Produit introuvable dans la base de donnÃ©es';

  @override
  String get globalConnectionError => 'Erreur de connexion';

  @override
  String globalErrorFirebase(String error) {
    return 'Erreur Firebase : $error';
  }

  @override
  String get foodsAddTitle => 'Ajouter un aliment';

  @override
  String get foodsScanTooltip => 'Scanner le code-barres';

  @override
  String get foodsNameLabel => 'Nom (ex. Pomme)';

  @override
  String get foodsBrandLabel => 'Marque ou Desc. (Optionnel)';

  @override
  String get foodsCarbsLabel => 'Glucides pour 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'ProtÃ©ines';

  @override
  String get foodsFatLabel => 'Lipides';

  @override
  String get foodsCancel => 'Annuler';

  @override
  String get foodsSave => 'Enregistrer';

  @override
  String get foodsNameRequired => 'Le nom de l\'aliment est requis.';

  @override
  String get foodsCarbsRequired => 'Les glucides pour 100g sont requis.';

  @override
  String get foodsCarbsInvalid =>
      'La valeur des glucides n\'est pas un nombre valide.';

  @override
  String get foodsSearch => 'Chercher un aliment...';

  @override
  String get foodsMustLogin => 'Vous devez vous connecter';

  @override
  String get foodsLoadingError =>
      'Erreur lors du chargement de la base de donnÃ©es.';

  @override
  String get foodsEmpty =>
      'Vous n\'avez pas encore d\'aliments enregistrÃ©s.\nAjoutez votre premier !';

  @override
  String foodsDeleteConfirm(String name) {
    return 'ÃŠtes-vous sÃ»r de vouloir supprimer \"$name\" ?';
  }

  @override
  String get foodsAddToFavorites => 'Ajouter aux favoris';

  @override
  String get foodsRemoveFromFavorites => 'Retirer des favoris';

  @override
  String foodsDeleteTooltip(String name) {
    return 'Supprimer $name';
  }

  @override
  String get foodsDetailTitle => 'Valeurs pour 100g :';

  @override
  String foodsDetailCarbs(String value) {
    return 'Glucides : ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Calories : ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'ProtÃ©ines : ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Lipides : ${value}g';
  }

  @override
  String get foodsDetailClose => 'Fermer';

  @override
  String get foodsNewFood => 'Nouvel Aliment';

  @override
  String get foodsFavoriteAccessibility => 'Favori';

  @override
  String get foodsFoodAccessibility => 'Aliment';

  @override
  String get foodsSearchAccessibility => 'Aliment global';

  @override
  String get insulinTitle => 'ParamÃ¨tres d\'Insuline';

  @override
  String get insulinDesc =>
      'Ces valeurs sont personnelles et privÃ©es. Les configurer permet Ã  l\'appli de calculer le bolus d\'insuline recommandÃ©.';

  @override
  String get insulinRatioTitle => 'Ratio d\'insuline (unitÃ©s par ration)';

  @override
  String get insulinRatioBase => 'Ratio de base *';

  @override
  String get insulinRatioHint => 'Ex. : 1,5';

  @override
  String get insulinRatioSuffix => 'unitÃ©s / ration';

  @override
  String get insulinRatioRequired => 'Le ratio de base est requis';

  @override
  String get insulinInvalidNumber => 'Saisissez un nombre valide';

  @override
  String get insulinMealRatios => 'Ratios spÃ©cifiques par repas (optionnel)';

  @override
  String get insulinFactorTitle => 'Facteur de correction';

  @override
  String get insulinFactorLabel => 'Facteur de correction *';

  @override
  String get insulinFactorHint => 'Ex. : 40';

  @override
  String get insulinFactorSuffix => 'mg/dL par unitÃ©';

  @override
  String get insulinFactorRequired => 'Le facteur de correction est requis';

  @override
  String get insulinMustBePositive => 'Doit Ãªtre supÃ©rieur Ã  0';

  @override
  String get insulinGlucoseTargetTitle => 'GlycÃ©mie cible *';

  @override
  String get insulinGlucoseTargetLabel => 'GlycÃ©mie cible *';

  @override
  String get insulinGlucoseTargetHint => 'Ex. : 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired => 'La glycÃ©mie cible est requise';

  @override
  String get insulinHalfUnits => 'Stylo demi-unitÃ©s';

  @override
  String get insulinHalfUnitsDesc =>
      'Permet des doses par incrÃ©ments de 0,5 unitÃ©';

  @override
  String get insulinRoundDown => 'Arrondir le bolus Ã  l\'infÃ©rieur';

  @override
  String get insulinRoundDownDesc =>
      'Tronque le bolus au lieu d\'arrondir au plus proche. Utile si vous dosez par paliers (ex. : 1 unitÃ© par 50 mg/dL)';

  @override
  String get insulinSaving => 'Enregistrement...';

  @override
  String get insulinSave => 'Enregistrer les ParamÃ¨tres';

  @override
  String get insulinSaved => 'ParamÃ¨tres d\'insuline enregistrÃ©s';

  @override
  String get insulinOptionalHint =>
      'Laissez vide pour utiliser le ratio de base';

  @override
  String get foodSearchTitle => 'Chercher un Aliment';

  @override
  String get foodSearchClose => 'Fermer la recherche';

  @override
  String get foodSearchHint => 'Ex. Pomme, pain, riz...';

  @override
  String get foodSearchEmptyList =>
      'Vous n\'avez pas encore d\'aliments dans votre liste.';

  @override
  String foodSearchNoResults(String query) {
    return 'Aucun rÃ©sultat pour \"$query\"';
  }

  @override
  String get barcodeTitle => 'Scanner le code-barres';

  @override
  String get barcodeScannedFood => 'Aliment scannÃ©';

  @override
  String get confirmDeleteTitle => 'Confirmer la suppression';

  @override
  String get confirmDeleteCancel => 'Annuler';

  @override
  String get confirmDeleteButton => 'Supprimer';

  @override
  String get updateAvailable => 'Mise Ã  jour disponible';

  @override
  String updateVersion(String version) {
    return 'Version $version';
  }

  @override
  String get updateLater => 'Plus tard';

  @override
  String get updateDownload => 'TÃ©lÃ©charger';

  @override
  String get updateDownloading => 'TÃ©lÃ©chargement de la mise Ã  jour...';

  @override
  String get updateError =>
      'Ã‰chec du tÃ©lÃ©chargement. Visitez github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'NouveautÃ©s';

  @override
  String get profileThemeLabel => 'ThÃ¨me de l\'app';

  @override
  String get profileThemeSystem => 'SystÃ¨me';

  @override
  String get profileThemeLight => 'Clair';

  @override
  String get profileThemeDark => 'Sombre';

  @override
  String get profileSettingsSectionApp => 'Application';

  @override
  String get profileSettingsSectionHealth => 'SantÃ©';

  @override
  String get profileSettings => 'ParamÃ¨tres';

  @override
  String get insulinGlucoseUnit => 'UnitÃ© de glycÃ©mie';

  @override
  String get insulinGlucoseUnitDesc => 'Basculer entre mg/dL et mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Utiliser mmol/L au lieu de mg/dL';

  @override
  String get calcTabGrams => 'Grammes';

  @override
  String get calcTabRations => 'Rations';
}
