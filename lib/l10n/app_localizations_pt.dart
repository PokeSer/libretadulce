// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Libreta Dulce';

  @override
  String get loadingApp => 'Carregando aplicativo';

  @override
  String get loginTitle => 'Libreta Dulce';

  @override
  String get loginSubtitle =>
      'Seu assistente pessoal para o controle diÃ¡rio de carboidratos e porÃ§Ãµes.';

  @override
  String get loginButtonGoogle => 'Entrar com Google';

  @override
  String get loginIniciandoSesion => 'Entrando';

  @override
  String get loginPrivacyText =>
      'Seus dados de saÃºde estÃ£o protegidos\ne vinculados apenas Ã  sua conta pessoal.';

  @override
  String get navCalculator => 'Calculadora';

  @override
  String get navFoods => 'Alimentos';

  @override
  String get navGlobal => 'Global';

  @override
  String get navHistory => 'HistÃ³rico';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navAdminTooltip => 'AdministraÃ§Ã£o Global';

  @override
  String get calcTitle => 'Calculadora & Prato';

  @override
  String get calcGramsMode => 'Tenho as gramas\n(Quero PorÃ§Ãµes)';

  @override
  String get calcRationsMode => 'Quero PorÃ§Ãµes\n(Diga-me as gramas)';

  @override
  String get calcSearchFood => 'Toque para buscar alimento...';

  @override
  String get calcSearchFoodAccessibility => 'Buscar alimento';

  @override
  String get calcFoodAccessibility => 'Alimento';

  @override
  String calcSelectedFood(String foodName) {
    return 'Alimento selecionado: $foodName. Toque para alterar.';
  }

  @override
  String calcCarbsPer100g(String carbs) {
    return '${carbs}g carboidratos / 100g';
  }

  @override
  String get calcFavoritesTitle => 'Favoritos RÃ¡pidos';

  @override
  String get calcInputGramsLabel => 'Quantidade em gramas';

  @override
  String get calcInputRationsLabel => 'PorÃ§Ãµes a comer';

  @override
  String get calcInputGramsSuffix => 'gramas';

  @override
  String get calcInputRationsSuffix => 'porÃ§Ãµes';

  @override
  String get calcResultTitle => 'RESULTADO';

  @override
  String get calcResultInverseTitle => 'DEVE PESAR';

  @override
  String get calcGramsHC => 'Carboidratos (g)';

  @override
  String get calcRations => 'PorÃ§Ãµes';

  @override
  String calcOfFood(String foodName) {
    return 'de $foodName';
  }

  @override
  String get calcAddToPlate => 'Adicionar ao prato atual';

  @override
  String get calcMyPlate => 'Meu Prato Atual';

  @override
  String get calcClear => 'Limpar';

  @override
  String calcGramsConsumed(String grams) {
    return '${grams}g consumidos';
  }

  @override
  String calcRacShort(String rac) {
    return '$rac PorÃ§.';
  }

  @override
  String calcHC(String carbs) {
    return '${carbs}g CHO';
  }

  @override
  String get calcDeleteFromPlate => 'Remover do prato';

  @override
  String get calcTotalPlate => 'TOTAL DO PRATO:';

  @override
  String calcTotalRac(String rac) {
    return '$rac PorÃ§.';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g CHO';
  }

  @override
  String get calcMealTypeLabel => 'Tipo de refeiÃ§Ã£o:';

  @override
  String get calcTimeLabel => 'Hora';

  @override
  String get calcDateLabel => 'Data';

  @override
  String get calcBolusTitle => 'Bolus de Insulina';

  @override
  String get calcGlucoseLabel => 'Glicemia atual (opcional)';

  @override
  String get calcGlucoseHint => 'Ex.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Bolus refeiÃ§Ã£o';

  @override
  String get calcBolusCorrection => 'CorreÃ§Ã£o';

  @override
  String get calcBolusTotal => 'Total';

  @override
  String get calcBolusUnitSuffix => 'unidades';

  @override
  String get calcNoFoodsMessage =>
      'Adicione alimentos ao prato para ver o bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'Selecione o tipo de refeiÃ§Ã£o para calcular o bolus.';

  @override
  String get calcCalculating => 'Calculando...';

  @override
  String get calcConfigureMessage =>
      'Configure suas definiÃ§Ãµes de insulina para ver o bolus recomendado.';

  @override
  String get calcConfigureButton => 'Configurar';

  @override
  String get calcSaveHistory => 'Salvar no HistÃ³rico DiÃ¡rio';

  @override
  String get calcSaveTitle => 'Salvar no HistÃ³rico';

  @override
  String calcSaveSuccessBolus(String mealType, String bolus) {
    return 'Salvo como $mealType. Bolus: $bolus unidades';
  }

  @override
  String calcSaveSuccess(String mealType) {
    return 'Salvo como $mealType com sucesso';
  }

  @override
  String calcSaveError(String error) {
    return 'Erro ao salvar: $error';
  }

  @override
  String get calcUndo => 'Desfazer';

  @override
  String calcItemRemoved(Object name) {
    return '$name removido';
  }

  @override
  String get calcMustLogin => 'VocÃª precisa iniciar sessÃ£o';

  @override
  String get calcGramsModeAccessibility =>
      'Tenho as gramas, calcular porÃ§Ãµes';

  @override
  String get calcRationsModeAccessibility =>
      'Quero comer porÃ§Ãµes, calcular gramas';

  @override
  String get mealTypeBreakfast => 'CafÃ© da manhÃ£';

  @override
  String get mealTypeMidMorning => 'Lanche da manhÃ£';

  @override
  String get mealTypeLunch => 'AlmoÃ§o';

  @override
  String get mealTypeAfternoonSnack => 'Lanche da tarde';

  @override
  String get mealTypeDinner => 'Jantar';

  @override
  String get mealTypeSnack => 'Lanche / Outro';

  @override
  String get historyDaily => 'DiÃ¡rio';

  @override
  String get historyWeekly => 'Semanal';

  @override
  String get historyExportButton => 'Exportar';

  @override
  String get historyExportAccessibility => 'Exportar histÃ³rico para CSV';

  @override
  String get historyPrevDay => 'Dia anterior';

  @override
  String get historyNextDay => 'Dia seguinte';

  @override
  String get historyToday => 'HOJE';

  @override
  String get historyDailyAccessibility => 'VisualizaÃ§Ã£o diÃ¡ria';

  @override
  String get historyWeeklyAccessibility => 'VisualizaÃ§Ã£o semanal';

  @override
  String get historyLoading => 'Carregando histÃ³rico';

  @override
  String historyErrorLoading(String error) {
    return 'Erro: $error';
  }

  @override
  String get historyNoRecords => 'Nenhum registro para este dia.';

  @override
  String get historyMustLogin => 'VocÃª precisa iniciar sessÃ£o';

  @override
  String get historyTotalRations => 'Total de PorÃ§Ãµes';

  @override
  String get historyTotalCarbs => 'Total de Carboidratos';

  @override
  String get historySubtotal => 'SUBTOTAL:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac PorÃ§Ãµes (${carbs}g CHO)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus unidades de insulina';
  }

  @override
  String get historyDeleteTitle => 'Excluir RefeiÃ§Ã£o';

  @override
  String get historyDeleteConfirm =>
      'Tem certeza que deseja excluir este registro do histÃ³rico?';

  @override
  String get historyDeleteButton => 'Excluir';

  @override
  String get historyCancelButton => 'Cancelar';

  @override
  String get historyDeleteSuccess => 'Registro excluÃ­do';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Excluir $mealType';
  }

  @override
  String get historyEditButton => 'Editar';

  @override
  String get historyEditTitle => 'Editar entrada';

  @override
  String get historyEditSave => 'Salvar alteraÃ§Ãµes';

  @override
  String get historyEditSuccess => 'Entrada atualizada';

  @override
  String get historyEditGramsLabel => 'Gramas';

  @override
  String get historyNoData7Days => 'Sem dados nos Ãºltimos 7 dias.';

  @override
  String get historyLast7Days => 'Ãšltimos 7 dias';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g CHO';
  }

  @override
  String get historyExportEmpty => 'Sem dados para exportar.';

  @override
  String get historyCsvHeader =>
      'Data,Hora,Tipo de RefeiÃ§Ã£o,Alimento,Gramas,PorÃ§Ãµes,Carboidratos (g)';

  @override
  String get historyShareSubject => 'HistÃ³rico Libreta Dulce';

  @override
  String historyExportError(String error) {
    return 'Erro ao exportar: $error';
  }

  @override
  String historyGramsFood(String grams, String name) {
    return '${grams}g de $name';
  }

  @override
  String historyRacShort(String rac) {
    return '$rac PorÃ§.';
  }

  @override
  String get profileNotLoggedIn => 'NÃ£o conectado';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Foto de perfil de $name';
  }

  @override
  String get profileDefaultName => 'UsuÃ¡rio';

  @override
  String get profileAboutTitle => 'Sobre o Libreta Dulce';

  @override
  String get profileAboutSubtitle => 'Feito com amor por e para diabÃ©ticos';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'OlÃ¡, sou um desenvolvedor independente e criei este aplicativo para ajudar no controle diÃ¡rio de carboidratos e porÃ§Ãµes. Se tiver sugestÃµes ou encontrar erros, por favor compartilhe.';

  @override
  String get profileAboutDialogClose => 'Fechar';

  @override
  String get profileInsulinSettings => 'ConfiguraÃ§Ãµes de Insulina';

  @override
  String get profileInsulinSettingsDesc =>
      'ProporÃ§Ã£o, fator de correÃ§Ã£o e meta de glicose';

  @override
  String get profileLogout => 'Sair';

  @override
  String get profileLogoutConfirm => 'Tem certeza que deseja sair?';

  @override
  String get profileLogoutCancel => 'Cancelar';

  @override
  String get profileLogoutButton => 'Sair';

  @override
  String get profileLogoutDialogTitle => 'Sair';

  @override
  String get adminTitle => 'SolicitaÃ§Ãµes & Painel Global';

  @override
  String get adminTabRequests => 'Novas SolicitaÃ§Ãµes';

  @override
  String get adminTabGlobal => 'Dados Globais';

  @override
  String get adminApproved => 'Alimento aprovado e publicado';

  @override
  String get adminRejected => 'SolicitaÃ§Ã£o rejeitada';

  @override
  String get adminDeleted => 'Alimento excluÃ­do globalmente';

  @override
  String get adminEditTitle => 'Editar Alimento Global';

  @override
  String get adminNameLabel => 'Nome';

  @override
  String get adminCarbsLabel => 'Carboidratos por 100g';

  @override
  String get adminCancelButton => 'Cancelar';

  @override
  String get adminSaveButton => 'Salvar';

  @override
  String get adminUpdated => 'Alimento atualizado';

  @override
  String get adminNoRequests =>
      'Tudo certo! Nenhuma nova solicitaÃ§Ã£o pendente.';

  @override
  String get adminNoName => 'Sem nome';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Carboidratos: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Link/InformaÃ§Ãµes extras: $url';
  }

  @override
  String get adminRejectButton => 'Rejeitar';

  @override
  String get adminApproveButton => 'Aprovar';

  @override
  String get adminEmptyGlobal => 'O banco de dados global estÃ¡ vazio.';

  @override
  String get adminGlobalFood => 'Alimento global';

  @override
  String get adminEditGlobal => 'Editar global';

  @override
  String get adminDeleteGlobal => 'Excluir alimento global';

  @override
  String get adminDeleteConfirm => 'Excluir alimento?';

  @override
  String get adminDeleteWarning =>
      'Isso removerÃ¡ o alimento do banco de dados pÃºblico. Os usuÃ¡rios nÃ£o poderÃ£o mais buscÃ¡-lo.';

  @override
  String get adminDeleteButton => 'Excluir';

  @override
  String get adminLoadingRequests => 'Carregando solicitaÃ§Ãµes';

  @override
  String get globalSearch => 'Buscar no banco de dados global...';

  @override
  String get globalLoading => 'Carregando alimentos globais';

  @override
  String get globalNoResults => 'Nenhum alimento encontrado.';

  @override
  String get globalGlobalFood => 'Alimento global';

  @override
  String get globalCopyToMyFoods => 'Copiar para Meus Alimentos';

  @override
  String get globalSuggestProduct => 'Sugerir Produto';

  @override
  String get globalScanning => 'Buscando OpenFoodFacts...';

  @override
  String get globalFound => 'Alimento encontrado!';

  @override
  String get globalNotFound => 'Produto nÃ£o encontrado';

  @override
  String get globalRequestTitle => 'Novo alimento';

  @override
  String get globalRequestDesc =>
      'Sua solicitaÃ§Ã£o serÃ¡ revisada por uma pessoa antes de ser adicionada ao banco de dados global.';

  @override
  String get globalRequestName => 'Nome do produto';

  @override
  String get globalRequestBrand => 'Marca ou DescriÃ§Ã£o';

  @override
  String get globalRequestCarbs => 'Carboidratos por 100g';

  @override
  String get globalRequestUrl => 'Link do produto (Opcional)';

  @override
  String get globalRequestCancel => 'Cancelar';

  @override
  String get globalRequestSent => 'SolicitaÃ§Ã£o enviada. Obrigado!';

  @override
  String get globalRequestSend => 'Enviar SolicitaÃ§Ã£o';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name adicionado aos seus alimentos';
  }

  @override
  String get globalScanTooltip => 'Escanear cÃ³digo de barras';

  @override
  String get globalNotFoundDB => 'Produto nÃ£o encontrado no banco de dados';

  @override
  String get globalConnectionError => 'Erro de conexÃ£o';

  @override
  String globalErrorFirebase(String error) {
    return 'Erro do Firebase: $error';
  }

  @override
  String get foodsAddTitle => 'Adicionar alimento';

  @override
  String get foodsScanTooltip => 'Escanear cÃ³digo de barras';

  @override
  String get foodsNameLabel => 'Nome (ex.: MaÃ§Ã£)';

  @override
  String get foodsBrandLabel => 'Marca ou Desc. (Opcional)';

  @override
  String get foodsCarbsLabel => 'Carboidratos por 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'ProteÃ­na';

  @override
  String get foodsFatLabel => 'Gordura';

  @override
  String get foodsCancel => 'Cancelar';

  @override
  String get foodsSave => 'Salvar';

  @override
  String get foodsNameRequired => 'O nome do alimento Ã© obrigatÃ³rio.';

  @override
  String get foodsCarbsRequired => 'Carboidratos por 100g sÃ£o obrigatÃ³rios.';

  @override
  String get foodsCarbsInvalid =>
      'O valor de carboidratos nÃ£o Ã© um nÃºmero vÃ¡lido.';

  @override
  String get foodsSearch => 'Buscar alimento...';

  @override
  String get foodsMustLogin => 'VocÃª precisa iniciar sessÃ£o';

  @override
  String get foodsLoadingError => 'Erro ao carregar banco de dados.';

  @override
  String get foodsEmpty =>
      'VocÃª ainda nÃ£o tem alimentos salvos.\nAdicione o primeiro!';

  @override
  String foodsDeleteConfirm(String name) {
    return 'Tem certeza que deseja excluir \"$name\"?';
  }

  @override
  String get foodsAddToFavorites => 'Adicionar aos favoritos';

  @override
  String get foodsRemoveFromFavorites => 'Remover dos favoritos';

  @override
  String foodsDeleteTooltip(String name) {
    return 'Excluir $name';
  }

  @override
  String get foodsDetailTitle => 'Valores por 100g:';

  @override
  String foodsDetailCarbs(String value) {
    return 'Carboidratos: ${value}g';
  }

  @override
  String foodsDetailCalories(String value) {
    return 'Calorias: ${value}kcal';
  }

  @override
  String foodsDetailProtein(String value) {
    return 'ProteÃ­na: ${value}g';
  }

  @override
  String foodsDetailFat(String value) {
    return 'Gordura: ${value}g';
  }

  @override
  String get foodsDetailClose => 'Fechar';

  @override
  String get foodsNewFood => 'Novo Alimento';

  @override
  String get foodsFavoriteAccessibility => 'Favorito';

  @override
  String get foodsFoodAccessibility => 'Alimento';

  @override
  String get foodsSearchAccessibility => 'Alimento global';

  @override
  String get insulinTitle => 'ConfiguraÃ§Ãµes de Insulina';

  @override
  String get insulinDesc =>
      'Estes valores sÃ£o pessoais e privados. ConfigurÃ¡-los permite que o aplicativo calcule o bolus de insulina recomendado.';

  @override
  String get insulinRatioTitle =>
      'ProporÃ§Ã£o de insulina (unidades por porÃ§Ã£o)';

  @override
  String get insulinRatioBase => 'ProporÃ§Ã£o base *';

  @override
  String get insulinRatioHint => 'Ex.: 1,5';

  @override
  String get insulinRatioSuffix => 'unidades / porÃ§Ã£o';

  @override
  String get insulinRatioRequired => 'A proporÃ§Ã£o base Ã© obrigatÃ³ria';

  @override
  String get insulinInvalidNumber => 'Insira um nÃºmero vÃ¡lido';

  @override
  String get insulinMealRatios => 'ProporÃ§Ãµes por refeiÃ§Ã£o (opcional)';

  @override
  String get insulinFactorTitle => 'Fator de correÃ§Ã£o';

  @override
  String get insulinFactorLabel => 'Fator de correÃ§Ã£o *';

  @override
  String get insulinFactorHint => 'Ex.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL por unidade';

  @override
  String get insulinFactorRequired => 'O fator de correÃ§Ã£o Ã© obrigatÃ³rio';

  @override
  String get insulinMustBePositive => 'Deve ser maior que 0';

  @override
  String get insulinGlucoseTargetTitle => 'Meta de glicose *';

  @override
  String get insulinGlucoseTargetLabel => 'Meta de glicose *';

  @override
  String get insulinGlucoseTargetHint => 'Ex.: 100';

  @override
  String get insulinGlucoseTargetSuffix => 'mg/dL';

  @override
  String get insulinGlucoseTargetRequired =>
      'A meta de glicose Ã© obrigatÃ³ria';

  @override
  String get insulinHalfUnits => 'Caneta de meia unidade';

  @override
  String get insulinHalfUnitsDesc =>
      'Permite doses com incrementos de 0,5 unidade';

  @override
  String get insulinRoundDown => 'Arredondar bolus para baixo';

  @override
  String get insulinRoundDownDesc =>
      'Trunca o bolus em vez de arredondar para o valor mais prÃ³ximo. Ãštil para dosagem por faixas (ex.: 1 unidade por 50 mg/dL)';

  @override
  String get insulinSaving => 'Salvando...';

  @override
  String get insulinSave => 'Salvar ConfiguraÃ§Ãµes';

  @override
  String get insulinSaved => 'ConfiguraÃ§Ãµes de insulina salvas';

  @override
  String get insulinOptionalHint => 'Deixe vazio para usar a proporÃ§Ã£o base';

  @override
  String get foodSearchTitle => 'Buscar Alimento';

  @override
  String get foodSearchClose => 'Fechar busca';

  @override
  String get foodSearchHint => 'Ex.: MaÃ§Ã£, pÃ£o, arroz...';

  @override
  String get foodSearchEmptyList =>
      'VocÃª ainda nÃ£o tem alimentos na sua lista.';

  @override
  String foodSearchNoResults(String query) {
    return 'Nenhum resultado para \"$query\"';
  }

  @override
  String get barcodeTitle => 'Escanear cÃ³digo de barras';

  @override
  String get barcodeScannedFood => 'Alimento escaneado';

  @override
  String get confirmDeleteTitle => 'Confirmar exclusÃ£o';

  @override
  String get confirmDeleteCancel => 'Cancelar';

  @override
  String get confirmDeleteButton => 'Excluir';

  @override
  String get updateAvailable => 'AtualizaÃ§Ã£o disponÃ­vel';

  @override
  String updateVersion(String version) {
    return 'VersÃ£o $version';
  }

  @override
  String get updateLater => 'Depois';

  @override
  String get updateDownload => 'Baixar';

  @override
  String get updateDownloading => 'Baixando atualizaÃ§Ã£o...';

  @override
  String get updateError =>
      'Falha no download. Visite github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Novidades';

  @override
  String get profileThemeLabel => 'Tema da app';

  @override
  String get profileThemeSystem => 'Sistema';

  @override
  String get profileThemeLight => 'Claro';

  @override
  String get profileThemeDark => 'Escuro';

  @override
  String get profileSettingsSectionApp => 'AplicaÃ§Ã£o';

  @override
  String get profileSettingsSectionHealth => 'SaÃºde';

  @override
  String get profileSettings => 'ConfiguraÃ§Ãµes';

  @override
  String get insulinGlucoseUnit => 'Unidade de glicemia';

  @override
  String get insulinGlucoseUnitDesc => 'Alternar entre mg/dL e mmol/L';

  @override
  String get insulinGlucoseUnitLabel => 'Usar mmol/L em vez de mg/dL';

  @override
  String get calcTabGrams => 'Gramas';

  @override
  String get calcTabRations => 'Rações';
}
