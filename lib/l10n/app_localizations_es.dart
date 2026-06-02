// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'Cargando aplicaciÃ³n';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Tu asistente personal para el control diario de carbohidratos y raciones.';

  @override
  String get loginButtonGoogle => 'Continuar con Google';

  @override
  String get loginIniciandoSesion => 'Iniciando sesiÃ³n';

  @override
  String get loginPrivacyText =>
      'Tus datos de salud estÃ¡n protegidos\ny vinculados Ãºnicamente a tu cuenta personal.';

  @override
  String get navCalculator => 'Calculadora';

  @override
  String get navFoods => 'Alimentos';

  @override
  String get navGlobal => 'Global';

  @override
  String get navHistory => 'Historial';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navAdminTooltip => 'AdministraciÃ³n Global';

  @override
  String get calcTitle => 'Calculadora & Plato';

  @override
  String get calcGramsMode => 'Tengo los gramos\n(Quiero Raciones)';

  @override
  String get calcRationsMode => 'Quiero comer Raciones\n(Dime los gramos)';

  @override
  String get calcSearchFood => 'Toca para buscar alimento...';

  @override
  String get calcSearchFoodAccessibility => 'Buscar alimento';

  @override
  String get calcFoodAccessibility => 'Alimento';

  @override
  String calcSelectedFood(String foodName) {
    return 'Alimento seleccionado: $foodName. Toca para cambiar.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g HC / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Favoritos rÃ¡pidos';

  @override
  String get calcInputGramsLabel => 'Cantidad en gramos';

  @override
  String get calcInputRationsLabel => 'Raciones a comer';

  @override
  String get calcInputGramsSuffix => 'gramos';

  @override
  String get calcInputRationsSuffix => 'raciones';

  @override
  String get calcResultTitle => 'RESULTADO';

  @override
  String get calcResultInverseTitle => 'TIENES QUE PESAR';

  @override
  String get calcGramsHC => 'Gramos HC';

  @override
  String get calcRations => 'Raciones';

  @override
  String calcOfFood(String foodName) {
    return 'de $foodName';
  }

  @override
  String get calcAddToPlate => 'AÃ±adir al plato actual';

  @override
  String get calcMyPlate => 'Mi Plato Actual';

  @override
  String get calcClear => 'Limpiar';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g consumidos';
  }

  @override
  String calcRacShort(String rac) {
    return '${rac}Rac.';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g HC';
  }

  @override
  String get calcDeleteFromPlate => 'Eliminar del plato';

  @override
  String get calcTotalPlate => 'TOTAL DEL PLATO:';

  @override
  String calcTotalRac(String rac) {
    return '${rac}Rac.';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g HC';
  }

  @override
  String get calcMealTypeLabel => 'Tipo de comida:';

  @override
  String get calcTimeLabel => 'Hora';

  @override
  String get calcDateLabel => 'Fecha';

  @override
  String get calcBolusTitle => 'Bolo de Insulina';

  @override
  String get calcGlucoseLabel => 'Glucemia actual (opcional)';

  @override
  String get calcGlucoseHint => 'Ej: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Bolo comida';

  @override
  String get calcBolusCorrection => 'CorrecciÃ³n';

  @override
  String get calcBolusTotal => 'Total';

  @override
  String get calcBolusUnitSuffix => 'uds';

  @override
  String get calcNoFoodsMessage =>
      'AÃ±ade alimentos al plato para ver el bolo.';

  @override
  String get calcNoMealTypeMessage =>
      'Selecciona el tipo de comida para calcular el bolo.';

  @override
  String get calcCalculating => 'Calculando...';

  @override
  String get calcConfigureMessage =>
      'Configura tus ajustes de insulina para ver el bolo recomendado.';

  @override
  String get calcConfigureButton => 'Configurar';

  @override
  String get calcSaveHistory => 'Guardar en Historial Diario';

  @override
  String get calcSaveTitle => 'Guardar en Historial';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Guardado como $mealType. Bolo: $bolus uds';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Guardado como $mealType exitosamente';
  }

  @override
  String calcSaveError(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get calcUndo => 'Deshacer';

  @override
  String calcItemRemoved(Object name) {
    return '$name eliminado';
  }

  @override
  String get calcMustLogin => 'Debes iniciar sesiÃ³n';

  @override
  String get calcGramsModeAccessibility =>
      'Tengo los gramos, calcular raciones';

  @override
  String get calcRationsModeAccessibility =>
      'Quiero comer raciones, calcular gramos';

  @override
  String get mealTypeBreakfast => 'Desayuno';

  @override
  String get mealTypeMidMorning => 'Media MaÃ±ana';

  @override
  String get mealTypeLunch => 'Almuerzo';

  @override
  String get mealTypeAfternoonSnack => 'Merienda';

  @override
  String get mealTypeDinner => 'Cena';

  @override
  String get mealTypeSnack => 'Snack / Otro';

  @override
  String get historyDaily => 'Diario';

  @override
  String get historyWeekly => 'Semanal';

  @override
  String get historyExportButton => 'Exportar';

  @override
  String get historyExportAccessibility => 'Exportar historial a CSV';

  @override
  String get historyPrevDay => 'DÃ­a anterior';

  @override
  String get historyNextDay => 'DÃ­a siguiente';

  @override
  String get historyToday => 'HOY';

  @override
  String get historyDailyAccessibility => 'Vista diaria';

  @override
  String get historyWeeklyAccessibility => 'Vista semanal';

  @override
  String get historyLoading => 'Cargando historial';

  @override
  String historyErrorLoading(String error) {
    return 'Error: $error';
  }

  @override
  String get historyNoRecords => 'No hay registros este dÃ­a.';

  @override
  String get historyMustLogin => 'Debes iniciar sesiÃ³n';

  @override
  String get historyTotalRations => 'Total Raciones';

  @override
  String get historyTotalCarbs => 'Total Carbohidratos';

  @override
  String get historySubtotal => 'SUBTOTAL:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '${rac}Raciones (${carbs}g HC)';
  }

  @override
  String get historyBolus => 'BOLO:';

  @override
  String historyBolusUnits(String bolus) {
    return '${bolus}uds insulina';
  }

  @override
  String get historyDeleteTitle => 'Eliminar Comida';

  @override
  String get historyDeleteConfirm =>
      'Â¿EstÃ¡s seguro de que deseas eliminar este registro del historial?';

  @override
  String get historyDeleteButton => 'Eliminar';

  @override
  String get historyCancelButton => 'Cancelar';

  @override
  String get historyDeleteSuccess => 'Registro eliminado';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Eliminar $mealType';
  }

  @override
  String get historyEditButton => 'Editar';

  @override
  String get historyEditTitle => 'Editar entrada';

  @override
  String get historyEditSave => 'Guardar cambios';

  @override
  String get historyEditSuccess => 'Entrada actualizada';

  @override
  String get historyEditGramsLabel => 'Gramos a editar';

  @override
  String get historyNoData7Days => 'No hay datos en los Ãºltimos 7 dÃ­as.';

  @override
  String get historyLast7Days => 'Ãšltimos 7 dÃ­as';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g HC';
  }

  @override
  String get historyExportEmpty => 'No hay datos para exportar.';

  @override
  String get historyCsvHeader =>
      'Fecha,Hora,Tipo de comida,Alimento,Gramos,Raciones,Carbohidratos (g)';

  @override
  String get historyShareSubject => 'Historial Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'Error al exportar: $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g de $name';
  }

  @override
  String historyRacShort(String rac) {
    return '${rac}Rac.';
  }

  @override
  String get profileNotLoggedIn => 'SesiÃ³n no iniciada';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Foto de perfil de $name';
  }

  @override
  String get profileDefaultName => 'Usuario';

  @override
  String get profileAboutTitle => 'Sobre Libreta Dulce';

  @override
  String get profileAboutSubtitle => 'Hecho con cariÃ±o por y para diabÃ©ticos';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Hola, soy un desarrollador independiente y he creado esta app para ayudar a gestionar los carbohidratos y raciones en el dÃ­a a dÃ­a. Si tienes sugerencias o encuentras errores, por favor compÃ¡rtelos.';

  @override
  String get profileAboutDialogClose => 'Cerrar';

  @override
  String get profileInsulinSettings => 'Ajustes de Insulina';

  @override
  String get profileInsulinSettingsDesc =>
      'Ratio, factor de correcciÃ³n y glucemia objetivo';

  @override
  String get profileLogout => 'Cerrar SesiÃ³n';

  @override
  String get profileLogoutConfirm => 'Â¿EstÃ¡s seguro de que quieres salir?';

  @override
  String get profileLogoutCancel => 'Cancelar';

  @override
  String get profileLogoutButton => 'Salir';

  @override
  String get profileLogoutDialogTitle => 'Cerrar sesiÃ³n';

  @override
  String get adminTitle => 'Panel Peticiones & Global';

  @override
  String get adminTabRequests => 'Nuevas Peticiones';

  @override
  String get adminTabGlobal => 'Datos Globales';

  @override
  String get adminApproved => 'Alimento aprobado y publicado';

  @override
  String get adminRejected => 'PeticiÃ³n rechazada';

  @override
  String get adminDeleted => 'Alimento eliminado globalmente';

  @override
  String get adminEditTitle => 'Editar Alimento Global';

  @override
  String get adminNameLabel => 'Nombre';

  @override
  String get adminCarbsLabel => 'Hidratos por 100g';

  @override
  String get adminCancelButton => 'Cancelar';

  @override
  String get adminSaveButton => 'Guardar';

  @override
  String get adminUpdated => 'Alimento actualizado';

  @override
  String get adminNoRequests =>
      'Â¡Todo al dÃ­a! No hay nuevas peticiones de alimentos pendientes.';

  @override
  String get adminNoName => 'Sin nombre';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Hidratos: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Enlace/Info extra: $url';
  }

  @override
  String get adminRejectButton => 'Rechazar';

  @override
  String get adminApproveButton => 'Aprobar';

  @override
  String get adminEmptyGlobal => 'La base global estÃ¡ vacÃ­a.';

  @override
  String get adminGlobalFood => 'Alimento global';

  @override
  String get adminEditGlobal => 'Editar global';

  @override
  String get adminDeleteGlobal => 'Eliminar alimento global';

  @override
  String get adminDeleteConfirm => 'Â¿Eliminar alimento?';

  @override
  String get adminDeleteWarning =>
      'Esto lo borrarÃ¡ de la base pÃºblica. Los usuarios no podrÃ¡n buscarlo mÃ¡s.';

  @override
  String get adminDeleteButton => 'Eliminar';

  @override
  String get adminLoadingRequests => 'Cargando peticiones';

  @override
  String get globalSearch => 'Buscar en base global...';

  @override
  String get globalLoading => 'Cargando alimentos globales';

  @override
  String get globalNoResults => 'No hay alimentos o no se encontraron.';

  @override
  String get globalGlobalFood => 'Alimento global';

  @override
  String get globalCopyToMyFoods => 'Copiar a Mis Alimentos';

  @override
  String get globalSuggestProduct => 'Sugerir Producto';

  @override
  String get globalScanning => 'Buscando en OpenFoodFacts...';

  @override
  String get globalFound => 'Â¡Alimento encontrado!';

  @override
  String get globalNotFound => 'Producto no encontrado';

  @override
  String get globalRequestTitle => 'Nuevo alimento';

  @override
  String get globalRequestDesc =>
      'Tu peticiÃ³n serÃ¡ revisada por un humano antes de aÃ±adirse a la base global.';

  @override
  String get globalRequestName => 'Nombre del producto';

  @override
  String get globalRequestBrand => 'Marca o DescripciÃ³n';

  @override
  String get globalRequestCarbs => 'Hidratos por 100g';

  @override
  String get globalRequestUrl => 'Enlace al producto (Opcional)';

  @override
  String get globalRequestCancel => 'Cancelar';

  @override
  String get globalRequestSent => 'Â¡PeticiÃ³n enviada. Gracias!';

  @override
  String get globalRequestSend => 'Enviar PeticiÃ³n';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name aÃ±adido a tus alimentos';
  }

  @override
  String get globalScanTooltip => 'Escanear cÃ³digo';

  @override
  String get globalNotFoundDB => 'Producto no encontrado en la base de datos';

  @override
  String get globalConnectionError => 'Error de conexiÃ³n';

  @override
  String globalErrorFirebase(String error) {
    return 'Error de Firebase: $error';
  }

  @override
  String get foodsAddTitle => 'AÃ±adir alimento';

  @override
  String get foodsScanTooltip => 'Escanear cÃ³digo';

  @override
  String get foodsNameLabel => 'Nombre (ej. Manzana)';

  @override
  String get foodsBrandLabel => 'Marca o Descr. (Opcional)';

  @override
  String get foodsCarbsLabel => 'Carbohidratos por 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'Prot.';

  @override
  String get foodsFatLabel => 'Grasas';

  @override
  String get foodsCancel => 'Cancelar';

  @override
  String get foodsSave => 'Guardar';

  @override
  String get foodsNameRequired => 'El nombre del alimento es obligatorio.';

  @override
  String get foodsCarbsRequired =>
      'Los carbohidratos por 100g son obligatorios.';

  @override
  String get foodsCarbsInvalid =>
      'El valor de carbohidratos no es un nÃºmero vÃ¡lido.';

  @override
  String get foodsSearch => 'Buscar alimento...';

  @override
  String get foodsMustLogin => 'Debes iniciar sesiÃ³n';

  @override
  String get foodsLoadingError => 'Error al cargar la base de datos.';

  @override
  String get foodsEmpty =>
      'AÃºn no tienes alimentos guardados.\nÂ¡AÃ±ade el primero!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Â¿Seguro que quieres eliminar \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'Marcar como favorito';

  @override
  String get foodsRemoveFromFavorites => 'Quitar de favoritos';

  @override
  String foodsDeleteTooltip(String name) {
    return 'Eliminar $name';
  }

  @override
  String get foodsDetailTitle => 'Valores por cada 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'Carbohidratos: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'CalorÃ­as: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'ProteÃ­nas: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Grasas: ${value}g';
  }

  @override
  String get foodsDetailClose => 'Cerrar';

  @override
  String get foodsNewFood => 'Nuevo Alimento';

  @override
  String get foodsFavoriteAccessibility => 'Favorito';

  @override
  String get foodsFoodAccessibility => 'Alimento';

  @override
  String get foodsSearchAccessibility => 'Alimento global';

  @override
  String get insulinTitle => 'Ajustes de Insulina';

  @override
  String get insulinDesc =>
      'Estos valores son personales y privados. Configurarlos permite a la app calcular el bolo de insulina recomendado.';

  @override
  String get insulinRatioTitle => 'Ratio de insulina (unidades por raciÃ³n)';

  @override
  String get insulinRatioBase => 'Ratio base *';

  @override
  String get insulinRatioHint => 'Ej: 1.5';

  @override
  String get insulinRatioSuffix => 'uds / raciÃ³n';

  @override
  String get insulinRatioRequired => 'El ratio base es obligatorio';

  @override
  String get insulinInvalidNumber => 'Introduce un nÃºmero vÃ¡lido';

  @override
  String get insulinMealRatios => 'Ratios especÃ­ficos por comida (opcional)';

  @override
  String get insulinFactorTitle => 'Factor de correcciÃ³n';

  @override
  String get insulinFactorLabel => 'Factor de correcciÃ³n *';

  @override
  String get insulinFactorHint => 'Ej: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL por ud';

  @override
  String get insulinFactorRequired => 'El factor de correcciÃ³n es obligatorio';

  @override
  String get insulinMustBePositive => 'Debe ser mayor que 0';

  @override
  String get insulinGlucoseTargetTitle => 'Glucemia objetivo *';

  @override
  String get insulinGlucoseTargetLabel => 'Glucemia objetivo *';

  @override
  String get insulinGlucoseTargetHint => 'Ej: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired =>
      'La glucemia objetivo es obligatoria';

  @override
  String get insulinHalfUnits => 'Pluma con medias unidades';

  @override
  String get insulinHalfUnitsDesc => 'Permite dosis de 0.5 en 0.5 unidades';

  @override
  String get insulinRoundDown => 'Redondear bolo hacia abajo';

  @override
  String get insulinRoundDownDesc =>
      'Trunca el bolo en lugar de redondear al mÃ¡s cercano. Ãštil si dosificas por rangos (ej: 1 ud por cada 50 mg/dL)';

  @override
  String get insulinSaving => 'Guardando...';

  @override
  String get insulinSave => 'Guardar Ajustes';

  @override
  String get insulinSaved => 'Ajustes de insulina guardados';

  @override
  String get insulinOptionalHint => 'Si no pones nada, usa el ratio base';

  @override
  String get foodSearchTitle => 'Buscar Alimento';

  @override
  String get foodSearchClose => 'Cerrar bÃºsqueda';

  @override
  String get foodSearchHint => 'Ej. Manzana, pan, arroz...';

  @override
  String get foodSearchEmptyList => 'AÃºn no tienes alimentos en tu lista.';

  @override
  String foodSearchNoResults(String query) {
    return 'No hay resultados para \"$query\"';
  }

  @override
  String get barcodeTitle => 'Escanea el cÃ³digo de barras';

  @override
  String get barcodeScannedFood => 'Alimento escaneado';

  @override
  String get confirmDeleteTitle => 'Confirmar eliminaciÃ³n';

  @override
  String get confirmDeleteCancel => 'Cancelar';

  @override
  String get confirmDeleteButton => 'Eliminar';

  @override
  String get updateAvailable => 'ActualizaciÃ³n disponible';

  @override
  String updateVersion(String version) {
    return 'VersiÃ³n $version';
  }

  @override
  String get updateLater => 'Ahora no';

  @override
  String get updateDownload => 'Descargar';

  @override
  String get updateDownloading => 'Descargando actualizaciÃ³n...';

  @override
  String get updateError =>
      'Error al descargar. Visita github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Novedades';

  @override
  String get profileThemeLabel => 'Tema de la app';

  @override
  String get profileThemeSystem => 'Sistema';

  @override
  String get profileThemeLight => 'Claro';

  @override
  String get profileThemeDark => 'Oscuro';

  @override
  String get profileSettingsSectionApp => 'AplicaciÃ³n';

  @override
  String get profileSettingsSectionHealth => 'Salud';

  @override
  String get profileSettings => 'Ajustes';

  @override
  String get insulinGlucoseUnit => 'Unidad de glucemia';

  @override
  String get insulinGlucoseUnitDesc => 'Alternar entre mg/dL y mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Usar mmol/L en lugar de mg/dL';

  @override
  String get calcTabGrams => 'Gramos';

  @override
  String get calcTabRations => 'Raciones';
}
