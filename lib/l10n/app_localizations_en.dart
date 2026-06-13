// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'Loading app';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Your personal assistant for daily carbohydrate and ration tracking.';

  @override
  String get loginButtonGoogle => 'Continue with Google';

  @override
  String get loginIniciandoSesion => 'Signing in';

  @override
  String get loginPrivacyText =>
      'Your health data is protected\nand linked only to your personal account.';

  @override
  String get navCalculator => 'Calculator';

  @override
  String get navFoods => 'Foods';

  @override
  String get navGlobal => 'Global';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get navAdminTooltip => 'Global Administration';

  @override
  String get calcTitle => 'Calculator & Plate';

  @override
  String get calcGramsMode => 'I have the grams\n(I want Rations)';

  @override
  String get calcRationsMode => 'I want Rations\n(Tell me grams)';

  @override
  String get calcSearchFood => 'Tap to search for food...';

  @override
  String get calcSearchFoodAccessibility => 'Search food';

  @override
  String get calcFoodAccessibility => 'Food';

  @override
  String calcSelectedFood(String foodName) {
    return 'Selected food: $foodName. Tap to change.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g carbs / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Quick Favorites';

  @override
  String get calcInputGramsLabel => 'Amount in grams';

  @override
  String get calcInputRationsLabel => 'Rations to eat';

  @override
  String get calcInputGramsSuffix => 'grams';

  @override
  String get calcInputRationsSuffix => 'rations';

  @override
  String get calcResultTitle => 'RESULT';

  @override
  String get calcResultInverseTitle => 'YOU NEED TO WEIGH';

  @override
  String get calcGramsHC => 'Carbs (g)';

  @override
  String get calcRations => 'Rations';

  @override
  String calcOfFood(String foodName) {
    return 'of $foodName';
  }

  @override
  String get calcAddToPlate => 'Add to current plate';

  @override
  String get calcMyPlate => 'My Current Plate';

  @override
  String get calcClear => 'Clear';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g consumed';
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
  String calcFats(String fats) {
    return '${fats}g Fats';
  }

  @override
  String calcProteins(String proteins) {
    return '${proteins}g Proteins';
  }

  @override
  String get calcDeleteFromPlate => 'Remove from plate';

  @override
  String get calcTotalPlate => 'PLATE TOTAL:';

  @override
  String calcTotalRac(String rac) {
    return '$rac Rac.';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g HC';
  }

  @override
  String calcTotalFats(String fats) {
    return '${fats}g Fats';
  }

  @override
  String calcTotalProteins(String proteins) {
    return '${proteins}g Proteins';
  }

  @override
  String get calcMealTypeLabel => 'Meal type:';

  @override
  String get calcTimeLabel => 'Time';

  @override
  String get calcDateLabel => 'Date';

  @override
  String get calcBolusTitle => 'Insulin Bolus';

  @override
  String get calcGlucoseLabel => 'Current glucose (optional)';

  @override
  String get calcGlucoseHint => 'E.g.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Meal bolus';

  @override
  String get calcBolusCorrection => 'Correction';

  @override
  String get calcBolusTotal => 'Total';

  @override
  String get calcBolusUnitSuffix => 'units';

  @override
  String get calcNoFoodsMessage => 'Add foods to the plate to see the bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'Select the meal type to calculate the bolus.';

  @override
  String get calcCalculating => 'Calculating...';

  @override
  String get calcConfigureMessage =>
      'Set up your insulin settings to see the recommended bolus.';

  @override
  String get calcConfigureButton => 'Set up';

  @override
  String get calcSaveHistory => 'Save to Daily History';

  @override
  String get calcSaveTitle => 'Save to History';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Saved as $mealType. Bolus: $bolus units';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Saved as $mealType successfully';
  }

  @override
  String calcSaveError(String error) {
    return 'Error saving: $error';
  }

  @override
  String get calcUndo => 'Undo';

  @override
  String calcItemRemoved(Object name) {
    return '$name removed';
  }

  @override
  String get calcMustLogin => 'You must log in';

  @override
  String get calcGramsModeAccessibility =>
      'I have the grams, calculate rations';

  @override
  String get calcRationsModeAccessibility =>
      'I want to eat rations, calculate grams';

  @override
  String calcRepeatLastMeal(String mealType) {
    return 'Repeat last $mealType';
  }

  @override
  String get calcRepeatLastMealTooltip => 'Repeat last meal';

  @override
  String get calcSaveAsTemplate => 'Save as template';

  @override
  String get calcTemplateNameHint => 'E.g.: My usual breakfast';

  @override
  String get calcTemplateNameRequired => 'Please enter a name for the template';

  @override
  String get calcTemplateSaved => 'Template saved';

  @override
  String get calcLoadTemplate => 'Load template';

  @override
  String get calcNoTemplates => 'No saved templates yet';

  @override
  String calcTemplateLoaded(String name) {
    return 'Template \"$name\" loaded';
  }

  @override
  String get calcDeleteTemplate => 'Delete template';

  @override
  String calcDeleteTemplateConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get mealTypeBreakfast => 'Breakfast';

  @override
  String get mealTypeMidMorning => 'Mid-Morning';

  @override
  String get mealTypeLunch => 'Lunch';

  @override
  String get mealTypeAfternoonSnack => 'Afternoon Snack';

  @override
  String get mealTypeDinner => 'Dinner';

  @override
  String get mealTypeSnack => 'Snack / Other';

  @override
  String get historyDaily => 'Daily';

  @override
  String get historyWeekly => 'Weekly';

  @override
  String get historyExportButton => 'Export';

  @override
  String get historyExportAccessibility => 'Export history to CSV';

  @override
  String get historyPrevDay => 'Previous day';

  @override
  String get historyNextDay => 'Next day';

  @override
  String get historyToday => 'TODAY';

  @override
  String get historyDailyAccessibility => 'Daily view';

  @override
  String get historyWeeklyAccessibility => 'Weekly view';

  @override
  String get historyLoading => 'Loading history';

  @override
  String historyErrorLoading(String error) {
    return 'Error: $error';
  }

  @override
  String get historyNoRecords => 'No records for this day.';

  @override
  String get historyMustLogin => 'You must log in';

  @override
  String get historyTotalRations => 'Total Rations';

  @override
  String get historyTotalCarbs => 'Total Carbs';

  @override
  String get historyTotalFats => 'Fats';

  @override
  String get historyTotalProteins => 'Proteins';

  @override
  String get historySubtotal => 'SUBTOTAL:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac Rations (${carbs}g HC)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus units insulin';
  }

  @override
  String get historyDeleteTitle => 'Delete Meal';

  @override
  String get historyDeleteConfirm =>
      'Are you sure you want to delete this record from history?';

  @override
  String get historyDeleteButton => 'Delete';

  @override
  String get historyCancelButton => 'Cancel';

  @override
  String get historyDeleteSuccess => 'Record deleted';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Delete $mealType';
  }

  @override
  String get historyEditButton => 'Edit';

  @override
  String get historyEditTitle => 'Edit entry';

  @override
  String get historyEditSave => 'Save changes';

  @override
  String get historyEditSuccess => 'Entry updated';

  @override
  String get historyEditGramsLabel => 'Grams';

  @override
  String get historyNoData7Days => 'No data in the last 7 days.';

  @override
  String get historyLast7Days => 'Last 7 days';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g HC';
  }

  @override
  String get historyExportEmpty => 'No data to export.';

  @override
  String get historyCsvHeader =>
      'Date,Time,Meal Type,Food,Grams,Rations,Carbs (g)';

  @override
  String get historyShareSubject => 'Libreta Dulce History';

  @override
  String historyExportError(String error) {
    return 'Error exporting: $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g of $name';
  }

  @override
  String historyRacShort(String rac) {
    return '$rac Rac.';
  }

  @override
  String get profileNotLoggedIn => 'Not logged in';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Profile picture of $name';
  }

  @override
  String get profileDefaultName => 'User';

  @override
  String get profileAboutTitle => 'About Libreta Dulce';

  @override
  String get profileAboutSubtitle => 'Made with love by and for diabetics';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Hi, I\'m an independent developer and I created this app to help manage carbs and rations on a daily basis. If you have suggestions or find bugs, please share them.';

  @override
  String get profileAboutDialogClose => 'Close';

  @override
  String get profileInsulinSettings => 'Insulin Settings';

  @override
  String get profileInsulinSettingsDesc =>
      'Ratio, correction factor and glucose target';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get profileLogoutCancel => 'Cancel';

  @override
  String get profileLogoutButton => 'Log out';

  @override
  String get profileLogoutDialogTitle => 'Log out';

  @override
  String get adminTitle => 'Requests & Global Panel';

  @override
  String get adminTabRequests => 'New Requests';

  @override
  String get adminTabGlobal => 'Global Data';

  @override
  String get adminApproved => 'Food approved and published';

  @override
  String get adminRejected => 'Request rejected';

  @override
  String get adminDeleted => 'Food deleted globally';

  @override
  String get adminEditTitle => 'Edit Global Food';

  @override
  String get adminNameLabel => 'Name';

  @override
  String get adminCarbsLabel => 'Carbs per 100g';

  @override
  String get adminCancelButton => 'Cancel';

  @override
  String get adminSaveButton => 'Save';

  @override
  String get adminUpdated => 'Food updated';

  @override
  String get adminNoRequests => 'All clear! No new pending food requests.';

  @override
  String get adminNoName => 'No name';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Carbs: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Link/Extra info: $url';
  }

  @override
  String get adminRejectButton => 'Reject';

  @override
  String get adminApproveButton => 'Approve';

  @override
  String get adminEmptyGlobal => 'The global database is empty.';

  @override
  String get adminGlobalFood => 'Global food';

  @override
  String get adminEditGlobal => 'Edit global';

  @override
  String get adminDeleteGlobal => 'Delete global food';

  @override
  String get adminDeleteConfirm => 'Delete food?';

  @override
  String get adminDeleteWarning =>
      'This will remove it from the public database. Users will no longer be able to search for it.';

  @override
  String get adminDeleteButton => 'Delete';

  @override
  String get adminLoadingRequests => 'Loading requests';

  @override
  String get globalSearch => 'Search global database...';

  @override
  String get globalLoading => 'Loading global foods';

  @override
  String get globalNoResults => 'No foods or none found.';

  @override
  String get globalGlobalFood => 'Global food';

  @override
  String get globalCopyToMyFoods => 'Copy to My Foods';

  @override
  String get globalSuggestProduct => 'Suggest Product';

  @override
  String get globalScanning => 'Searching OpenFoodFacts...';

  @override
  String get globalFound => 'Food found!';

  @override
  String get globalNotFound => 'Product not found';

  @override
  String get globalRequestTitle => 'New food';

  @override
  String get globalRequestDesc =>
      'Your request will be reviewed by a human before being added to the global database.';

  @override
  String get globalRequestName => 'Product name';

  @override
  String get globalRequestBrand => 'Brand or Description';

  @override
  String get globalRequestCarbs => 'Carbs per 100g';

  @override
  String get globalRequestUrl => 'Product link (Optional)';

  @override
  String get globalRequestCancel => 'Cancel';

  @override
  String get globalRequestSent => 'Request sent. Thank you!';

  @override
  String get globalRequestSend => 'Send Request';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name added to your foods';
  }

  @override
  String get globalScanTooltip => 'Scan barcode';

  @override
  String get globalNotFoundDB => 'Product not found in database';

  @override
  String get globalConnectionError => 'Connection error';

  @override
  String globalErrorFirebase(String error) {
    return 'Firebase error: $error';
  }

  @override
  String get serviceError => 'An error occurred. Please try again.';

  @override
  String get foodsAddTitle => 'Add food';

  @override
  String get foodsScanTooltip => 'Scan barcode';

  @override
  String get foodsNameLabel => 'Name (e.g. Apple)';

  @override
  String get foodsBrandLabel => 'Brand or Desc. (Optional)';

  @override
  String get foodsCarbsLabel => 'Carbs per 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'Protein';

  @override
  String get foodsFatLabel => 'Fat';

  @override
  String get foodsCancel => 'Cancel';

  @override
  String get foodsSave => 'Save';

  @override
  String get foodsNameRequired => 'Food name is required.';

  @override
  String get foodsCarbsRequired => 'Carbs per 100g are required.';

  @override
  String get foodsCarbsInvalid => 'Carbs value is not a valid number.';

  @override
  String get foodsSearch => 'Search food...';

  @override
  String get foodsMustLogin => 'You must log in';

  @override
  String get foodsLoadingError => 'Error loading database.';

  @override
  String get foodsEmpty =>
      'You don\'t have any saved foods yet.\nAdd your first one!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'Add to favorites';

  @override
  String get foodsRemoveFromFavorites => 'Remove from favorites';

  @override
  String foodsDeleteTooltip(String name) {
    return 'Delete $name';
  }

  @override
  String get foodsDetailTitle => 'Values per 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'Carbohydrates: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Calories: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'Protein: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Fat: ${value}g';
  }

  @override
  String get foodsDetailClose => 'Close';

  @override
  String get foodsNewFood => 'New Food';

  @override
  String get foodsFavoriteAccessibility => 'Favorite';

  @override
  String get foodsFoodAccessibility => 'Food';

  @override
  String get foodsSearchAccessibility => 'Global food';

  @override
  String get insulinTitle => 'Insulin Settings';

  @override
  String get insulinDesc =>
      'These values are personal and private. Setting them up allows the app to calculate the recommended insulin bolus.';

  @override
  String get insulinRatioTitle => 'Insulin ratio (units per ration)';

  @override
  String get insulinRatioBase => 'Base ratio *';

  @override
  String get insulinRatioHint => 'E.g.: 1.5';

  @override
  String get insulinRatioSuffix => 'units / ration';

  @override
  String get insulinRatioRequired => 'Base ratio is required';

  @override
  String get insulinInvalidNumber => 'Enter a valid number';

  @override
  String get insulinMealRatios => 'Meal-specific ratios (optional)';

  @override
  String get insulinFactorTitle => 'Correction factor';

  @override
  String get insulinFactorLabel => 'Correction factor *';

  @override
  String get insulinFactorHint => 'E.g.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL per unit';

  @override
  String get insulinFactorRequired => 'Correction factor is required';

  @override
  String get insulinMustBePositive => 'Must be greater than 0';

  @override
  String get insulinGlucoseTargetTitle => 'Target glucose *';

  @override
  String get insulinGlucoseTargetLabel => 'Target glucose *';

  @override
  String get insulinGlucoseTargetHint => 'E.g.: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired => 'Target glucose is required';

  @override
  String get insulinHalfUnits => 'Half-unit pen';

  @override
  String get insulinHalfUnitsDesc => 'Allows 0.5-unit dose increments';

  @override
  String get insulinRoundDown => 'Round bolus down';

  @override
  String get insulinRoundDownDesc =>
      'Truncates the bolus instead of rounding to nearest. Useful if you dose by ranges (e.g.: 1 unit per 50 mg/dL)';

  @override
  String get insulinSaving => 'Saving...';

  @override
  String get insulinSave => 'Save Settings';

  @override
  String get insulinSaved => 'Insulin settings saved';

  @override
  String get insulinOptionalHint => 'Leave empty to use the base ratio';

  @override
  String get foodSearchTitle => 'Search Food';

  @override
  String get foodSearchClose => 'Close search';

  @override
  String get foodSearchHint => 'E.g. Apple, bread, rice...';

  @override
  String get foodSearchEmptyList =>
      'You don\'t have any foods in your list yet.';

  @override
  String foodSearchNoResults(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get barcodeTitle => 'Scan barcode';

  @override
  String get barcodeScannedFood => 'Scanned food';

  @override
  String get confirmDeleteTitle => 'Confirm deletion';

  @override
  String get confirmDeleteCancel => 'Cancel';

  @override
  String get confirmDeleteButton => 'Delete';

  @override
  String get updateAvailable => 'Update available';

  @override
  String updateVersion(String version) {
    return 'Version $version';
  }

  @override
  String get updateLater => 'Later';

  @override
  String get updateDownload => 'Download';

  @override
  String get updateDownloading => 'Downloading update...';

  @override
  String get updateError =>
      'Download failed. Visit github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'What\'s new';

  @override
  String get profileThemeLabel => 'App theme';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileSettingsSectionApp => 'Application';

  @override
  String get profileSettingsSectionHealth => 'Health';

  @override
  String get profileSettings => 'Settings';

  @override
  String get insulinGlucoseUnit => 'Glucose unit';

  @override
  String get insulinGlucoseUnitDesc => 'Switch between mg/dL and mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Use mmol/L instead of mg/dL';

  @override
  String get calcTabGrams => 'Grams';

  @override
  String get calcTabRations => 'Rations';

  @override
  String get photoTitle => 'Analyze plate photo';

  @override
  String get photoTakeButton => 'Take photo of plate';

  @override
  String get photoAnalyzing => 'Analyzing with AI...';

  @override
  String get photoAnalyzingHint =>
      'Gemini is identifying foods and estimating nutritional values';

  @override
  String get photoNoFoodDetected =>
      'Could not analyze the photo. Try a clearer image with good lighting.';

  @override
  String photoError(String error) {
    return 'Error: $error';
  }

  @override
  String get photoRetry => 'Try again';

  @override
  String get photoEmptyHint => 'Take a photo of your plate for AI analysis';

  @override
  String get photoEmptySubtitle =>
      'Gemini will identify foods, estimate portions and calculate nutritional values';

  @override
  String get photoResultsTitle => 'Detected foods';

  @override
  String get photoResultsHint => 'Adjust grams if needed and add to plate';

  @override
  String get photoConfidence => 'confidence';

  @override
  String get photoAddButton => 'Add';

  @override
  String photoAddToPlate(String name) {
    return 'Add $name to plate';
  }

  @override
  String get photoDone => 'Done';

  @override
  String get photoGramsLabel => 'Grams';

  @override
  String get photoNoNutrition => 'No nutritional data';

  @override
  String get photoCameraButton => 'Analyze plate with AI';

  @override
  String get photoApiKeyMissing =>
      'To use AI analysis you need a Gemini API key. It\'s free at aistudio.google.com';

  @override
  String get photoConfigureKey => 'Go to Settings';

  @override
  String get profileGeminiKey => 'Gemini API Key';

  @override
  String get photoPrivacyTitle => 'Privacy';

  @override
  String get photoPrivacyText =>
      'Your plate photo will be sent to the Gemini API (Google) for analysis. It is not stored or used for model training. Do you accept?';

  @override
  String get photoPrivacyCancel => 'Cancel';

  @override
  String get photoPrivacyAccept => 'Accept';

  @override
  String get photoTipTitle => 'Tip for a better photo';

  @override
  String get photoTipBody =>
      'For best results, keep a proper distance from the plate and make sure all foods are visible. A top-down view with good lighting works best.';

  @override
  String get photoTipChecklist =>
      '• Show the full plate\n• Good natural lighting\n• Distance of about 30-40 cm\n• No other objects around';

  @override
  String get photoTipCancel => 'Cancel';

  @override
  String get photoTipContinue => 'Got it, take photo';

  @override
  String get photoTipDontShowAgain => 'Don\'t show this tip again';

  @override
  String get photoGalleryButton => 'Choose from gallery';

  @override
  String get photoDisclaimerTitle => 'AI-estimated values';

  @override
  String get photoDisclaimerText =>
      'These values are AI-generated approximations. For accurate carbohydrate counting, always use a kitchen scale and check product nutrition labels.';

  @override
  String get photoAddFoodsTitle => 'Add each food to your plate:';

  @override
  String get photoTableFood => 'Food';

  @override
  String get photoTableGrams => 'Grams';

  @override
  String get photoTableCarbs => 'Carbs';

  @override
  String get photoTableRations => 'Rations';

  @override
  String get photoTableGI => 'GI';

  @override
  String get photoTableTotal => 'TOTAL';

  @override
  String get photoBolusTitle => 'Estimated insulin bolus';

  @override
  String photoBolusEstimation(String units, String carbs) {
    return 'Based on your settings, for ${carbs}g of carbs you would need $units of insulin. Remember this does not include glucose correction.';
  }

  @override
  String get photoBolusReminder =>
      'This is an estimate. Always check your current blood glucose to apply the necessary correction and consult your doctor about your insulin regimen.';

  @override
  String get profileGeminiKeyHint => 'Paste your API key here';

  @override
  String get profileGeminiKeyDesc =>
      'Required for AI food analysis. Free at aistudio.google.com';

  @override
  String get profileGeminiKeySaved => 'API key saved';
}
