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
      'Vos données de santé sont protégées\net liées uniquement à votre compte personnel.';

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
    return 'Aliment sélectionné : $foodName. Appuyez pour changer.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g de glucides / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Favoris Rapides';

  @override
  String get calcInputGramsLabel => 'Quantité en grammes';

  @override
  String get calcInputRationsLabel => 'Rations à consommer';

  @override
  String get calcInputGramsSuffix => 'grammes';

  @override
  String get calcInputRationsSuffix => 'rations';

  @override
  String get calcResultTitle => 'RÉSULTAT';

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
  String get calcAddToPlate => 'Ajouter à l\'assiette';

  @override
  String get calcMyPlate => 'Mon Assiette Actuelle';

  @override
  String get calcClear => 'Vider';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g consommés';
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
  String get calcGlucoseLabel => 'Glycémie actuelle (optionnel)';

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
  String get calcBolusUnitSuffix => 'unités';

  @override
  String get calcNoFoodsMessage =>
      'Ajoutez des aliments à l\'assiette pour voir le bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'Sélectionnez le type de repas pour calculer le bolus.';

  @override
  String get calcCalculating => 'Calcul en cours...';

  @override
  String get calcConfigureMessage =>
      'Configurez vos paramètres d\'insuline pour voir le bolus recommandé.';

  @override
  String get calcConfigureButton => 'Configurer';

  @override
  String get calcSaveHistory => 'Enregistrer dans l\'Historique Quotidien';

  @override
  String get calcSaveTitle => 'Enregistrer dans l\'Historique';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Enregistré comme $mealType. Bolus : $bolus unités';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Enregistré comme $mealType avec succès';
  }

  @override
  String calcSaveError(String error) {
    return 'Erreur lors de l\'enregistrement : $error';
  }

  @override
  String get calcUndo => 'Annuler';

  @override
  String calcItemRemoved(Object name) {
    return '$name supprimé';
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
  String get mealTypeBreakfast => 'Petit-déjeuner';

  @override
  String get mealTypeMidMorning => 'Collation du matin';

  @override
  String get mealTypeLunch => 'Déjeuner';

  @override
  String get mealTypeAfternoonSnack => 'Goûter';

  @override
  String get mealTypeDinner => 'Dîner';

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
  String get historyPrevDay => 'Jour précédent';

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
    return '$bolus unités d\'insuline';
  }

  @override
  String get historyDeleteTitle => 'Supprimer le Repas';

  @override
  String get historyDeleteConfirm =>
      'Êtes-vous sûr de vouloir supprimer cet enregistrement de l\'historique ?';

  @override
  String get historyDeleteButton => 'Supprimer';

  @override
  String get historyCancelButton => 'Annuler';

  @override
  String get historyDeleteSuccess => 'Enregistrement supprimé';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Supprimer $mealType';
  }

  @override
  String get historyNoData7Days => 'Aucune donnée dans les 7 derniers jours.';

  @override
  String get historyLast7Days => '7 derniers jours';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g HC';
  }

  @override
  String get historyExportEmpty => 'Aucune donnée à exporter.';

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
  String get profileNotLoggedIn => 'Non connecté';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Photo de profil de $name';
  }

  @override
  String get profileDefaultName => 'Utilisateur';

  @override
  String get profileAboutTitle => 'À propos de Libreta Dulce';

  @override
  String get profileAboutSubtitle =>
      'Fait avec amour par et pour les diabétiques';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Bonjour, je suis un développeur indépendant et j\'ai créé cette appli pour aider à gérer les glucides et les rations au quotidien. Si vous avez des suggestions ou trouvez des bugs, n\'hésitez pas à les partager.';

  @override
  String get profileAboutDialogClose => 'Fermer';

  @override
  String get profileInsulinSettings => 'Paramètres d\'Insuline';

  @override
  String get profileInsulinSettingsDesc =>
      'Ratio, facteur de correction et glycémie cible';

  @override
  String get profileLogout => 'Déconnexion';

  @override
  String get profileLogoutConfirm =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get profileLogoutCancel => 'Annuler';

  @override
  String get profileLogoutButton => 'Se déconnecter';

  @override
  String get profileLogoutDialogTitle => 'Déconnexion';

  @override
  String get adminTitle => 'Demandes et Panneau Global';

  @override
  String get adminTabRequests => 'Nouvelles Demandes';

  @override
  String get adminTabGlobal => 'Données Globales';

  @override
  String get adminApproved => 'Aliment approuvé et publié';

  @override
  String get adminRejected => 'Demande rejetée';

  @override
  String get adminDeleted => 'Aliment supprimé globalement';

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
  String get adminUpdated => 'Aliment mis à jour';

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
  String get adminEmptyGlobal => 'La base de données globale est vide.';

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
      'Cela le retirera de la base de données publique. Les utilisateurs ne pourront plus le rechercher.';

  @override
  String get adminDeleteButton => 'Supprimer';

  @override
  String get adminLoadingRequests => 'Chargement des demandes';

  @override
  String get globalSearch => 'Rechercher dans la base globale...';

  @override
  String get globalLoading => 'Chargement des aliments globaux';

  @override
  String get globalNoResults => 'Aucun aliment trouvé.';

  @override
  String get globalGlobalFood => 'Aliment global';

  @override
  String get globalCopyToMyFoods => 'Copier dans Mes Aliments';

  @override
  String get globalSuggestProduct => 'Suggérer un Produit';

  @override
  String get globalScanning => 'Recherche OpenFoodFacts...';

  @override
  String get globalFound => 'Produit trouvé !';

  @override
  String get globalNotFound => 'Produit introuvable';

  @override
  String get globalRequestTitle => 'Nouvel aliment';

  @override
  String get globalRequestDesc =>
      'Votre demande sera examinée par un humain avant d\'être ajoutée à la base de données globale.';

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
  String get globalRequestSent => 'Demande envoyée. Merci !';

  @override
  String get globalRequestSend => 'Envoyer la Demande';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name ajouté à vos aliments';
  }

  @override
  String get globalScanTooltip => 'Scanner le code-barres';

  @override
  String get globalNotFoundDB => 'Produit introuvable dans la base de données';

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
  String get foodsProteinLabel => 'Protéines';

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
      'Erreur lors du chargement de la base de données.';

  @override
  String get foodsEmpty =>
      'Vous n\'avez pas encore d\'aliments enregistrés.\nAjoutez votre premier !';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ?';
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
    return 'Protéines : ${value}g';
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
  String get insulinTitle => 'Paramètres d\'Insuline';

  @override
  String get insulinDesc =>
      'Ces valeurs sont personnelles et privées. Les configurer permet à l\'appli de calculer le bolus d\'insuline recommandé.';

  @override
  String get insulinRatioTitle => 'Ratio d\'insuline (unités par ration)';

  @override
  String get insulinRatioBase => 'Ratio de base *';

  @override
  String get insulinRatioHint => 'Ex. : 1,5';

  @override
  String get insulinRatioSuffix => 'unités / ration';

  @override
  String get insulinRatioRequired => 'Le ratio de base est requis';

  @override
  String get insulinInvalidNumber => 'Saisissez un nombre valide';

  @override
  String get insulinMealRatios => 'Ratios spécifiques par repas (optionnel)';

  @override
  String get insulinFactorTitle => 'Facteur de correction';

  @override
  String get insulinFactorLabel => 'Facteur de correction *';

  @override
  String get insulinFactorHint => 'Ex. : 40';

  @override
  String get insulinFactorSuffix => 'mg/dL par unité';

  @override
  String get insulinFactorRequired => 'Le facteur de correction est requis';

  @override
  String get insulinMustBePositive => 'Doit être supérieur à 0';

  @override
  String get insulinGlucoseTargetTitle => 'Glycémie cible *';

  @override
  String get insulinGlucoseTargetLabel => 'Glycémie cible *';

  @override
  String get insulinGlucoseTargetHint => 'Ex. : 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired => 'La glycémie cible est requise';

  @override
  String get insulinHalfUnits => 'Stylo demi-unités';

  @override
  String get insulinHalfUnitsDesc =>
      'Permet des doses par incréments de 0,5 unité';

  @override
  String get insulinRoundDown => 'Arrondir le bolus à l\'inférieur';

  @override
  String get insulinRoundDownDesc =>
      'Tronque le bolus au lieu d\'arrondir au plus proche. Utile si vous dosez par paliers (ex. : 1 unité par 50 mg/dL)';

  @override
  String get insulinSaving => 'Enregistrement...';

  @override
  String get insulinSave => 'Enregistrer les Paramètres';

  @override
  String get insulinSaved => 'Paramètres d\'insuline enregistrés';

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
    return 'Aucun résultat pour \"$query\"';
  }

  @override
  String get barcodeTitle => 'Scanner le code-barres';

  @override
  String get barcodeScannedFood => 'Aliment scanné';

  @override
  String get confirmDeleteTitle => 'Confirmer la suppression';

  @override
  String get confirmDeleteCancel => 'Annuler';

  @override
  String get confirmDeleteButton => 'Supprimer';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String updateVersion(String version) {
    return 'Version $version';
  }

  @override
  String get updateLater => 'Plus tard';

  @override
  String get updateDownload => 'Télécharger';

  @override
  String get updateDownloading => 'Téléchargement de la mise à jour...';

  @override
  String get updateError =>
      'Échec du téléchargement. Visitez github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Nouveautés';

  @override
  String get profileThemeLabel => 'Thème de l\'app';

  @override
  String get profileThemeSystem => 'Système';

  @override
  String get profileThemeLight => 'Clair';

  @override
  String get profileThemeDark => 'Sombre';

  @override
  String get profileSettingsSectionApp => 'Application';

  @override
  String get profileSettingsSectionHealth => 'Santé';

  @override
  String get profileSettings => 'Paramètres';

  @override
  String get insulinGlucoseUnit => 'Unité de glycémie';

  @override
  String get insulinGlucoseUnitDesc => 'Basculer entre mg/dL et mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Utiliser mmol/L au lieu de mg/dL';
}
