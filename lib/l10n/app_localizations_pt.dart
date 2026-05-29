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
      'Seu assistente pessoal para o controle diário de carboidratos e porções.';

  @override
  String get loginButtonGoogle => 'Entrar com Google';

  @override
  String get loginIniciandoSesion => 'Entrando';

  @override
  String get loginPrivacyText =>
      'Seus dados de saúde estão protegidos\ne vinculados apenas à sua conta pessoal.';

  @override
  String get navCalculator => 'Calculadora';

  @override
  String get navFoods => 'Alimentos';

  @override
  String get navGlobal => 'Global';

  @override
  String get navHistory => 'Histórico';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navAdminTooltip => 'Administração Global';

  @override
  String get calcTitle => 'Calculadora & Prato';

  @override
  String get calcGramsMode => 'Tenho as gramas\n(Quero Porções)';

  @override
  String get calcRationsMode => 'Quero Porções\n(Diga-me as gramas)';

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
  String get calcFavoritesTitle => 'Favoritos Rápidos';

  @override
  String get calcInputGramsLabel => 'Quantidade em gramas';

  @override
  String get calcInputRationsLabel => 'Porções a comer';

  @override
  String get calcInputGramsSuffix => 'gramas';

  @override
  String get calcInputRationsSuffix => 'porções';

  @override
  String get calcResultTitle => 'RESULTADO';

  @override
  String get calcResultInverseTitle => 'DEVE PESAR';

  @override
  String get calcGramsHC => 'Carboidratos (g)';

  @override
  String get calcRations => 'Porções';

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
    return '$rac Porç.';
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
    return '$rac Porç.';
  }

  @override
  String calcTotalHC(String carbs) {
    return '${carbs}g CHO';
  }

  @override
  String get calcMealTypeLabel => 'Tipo de refeição:';

  @override
  String get calcBolusTitle => 'Bolus de Insulina';

  @override
  String get calcGlucoseLabel => 'Glicemia atual (opcional)';

  @override
  String get calcGlucoseHint => 'Ex.: 145';

  @override
  String get calcGlucoseSuffix => 'mg/dL';

  @override
  String get calcBolusMeal => 'Bolus refeição';

  @override
  String get calcBolusCorrection => 'Correção';

  @override
  String get calcBolusTotal => 'Total';

  @override
  String get calcBolusUnitSuffix => 'unidades';

  @override
  String get calcNoFoodsMessage =>
      'Adicione alimentos ao prato para ver o bolus.';

  @override
  String get calcNoMealTypeMessage =>
      'Selecione o tipo de refeição para calcular o bolus.';

  @override
  String get calcCalculating => 'Calculando...';

  @override
  String get calcConfigureMessage =>
      'Configure suas definições de insulina para ver o bolus recomendado.';

  @override
  String get calcConfigureButton => 'Configurar';

  @override
  String get calcSaveHistory => 'Salvar no Histórico Diário';

  @override
  String get calcSaveTitle => 'Salvar no Histórico';

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
  String get calcMustLogin => 'Você precisa iniciar sessão';

  @override
  String get calcGramsModeAccessibility => 'Tenho as gramas, calcular porções';

  @override
  String get calcRationsModeAccessibility =>
      'Quero comer porções, calcular gramas';

  @override
  String get mealTypeBreakfast => 'Café da manhã';

  @override
  String get mealTypeMidMorning => 'Lanche da manhã';

  @override
  String get mealTypeLunch => 'Almoço';

  @override
  String get mealTypeAfternoonSnack => 'Lanche da tarde';

  @override
  String get mealTypeDinner => 'Jantar';

  @override
  String get mealTypeSnack => 'Lanche / Outro';

  @override
  String get historyDaily => 'Diário';

  @override
  String get historyWeekly => 'Semanal';

  @override
  String get historyExportButton => 'Exportar';

  @override
  String get historyExportAccessibility => 'Exportar histórico para CSV';

  @override
  String get historyPrevDay => 'Dia anterior';

  @override
  String get historyNextDay => 'Dia seguinte';

  @override
  String get historyToday => 'HOJE';

  @override
  String get historyDailyAccessibility => 'Visualização diária';

  @override
  String get historyWeeklyAccessibility => 'Visualização semanal';

  @override
  String get historyLoading => 'Carregando histórico';

  @override
  String historyErrorLoading(String error) {
    return 'Erro: $error';
  }

  @override
  String get historyNoRecords => 'Nenhum registro para este dia.';

  @override
  String get historyMustLogin => 'Você precisa iniciar sessão';

  @override
  String get historyTotalRations => 'Total de Porções';

  @override
  String get historyTotalCarbs => 'Total de Carboidratos';

  @override
  String get historySubtotal => 'SUBTOTAL:';

  @override
  String historyRationsCarbs(String rac, String carbs) {
    return '$rac Porções (${carbs}g CHO)';
  }

  @override
  String get historyBolus => 'BOLUS:';

  @override
  String historyBolusUnits(String bolus) {
    return '$bolus unidades de insulina';
  }

  @override
  String get historyDeleteTitle => 'Excluir Refeição';

  @override
  String get historyDeleteConfirm =>
      'Tem certeza que deseja excluir este registro do histórico?';

  @override
  String get historyDeleteButton => 'Excluir';

  @override
  String get historyCancelButton => 'Cancelar';

  @override
  String get historyDeleteSuccess => 'Registro excluído';

  @override
  String historyDeleteTooltip(String mealType) {
    return 'Excluir $mealType';
  }

  @override
  String get historyNoData7Days => 'Sem dados nos últimos 7 dias.';

  @override
  String get historyLast7Days => 'Últimos 7 dias';

  @override
  String historyChartTooltip(String day, String carbs) {
    return '$day\n${carbs}g CHO';
  }

  @override
  String get historyExportEmpty => 'Sem dados para exportar.';

  @override
  String get historyCsvHeader =>
      'Data,Hora,Tipo de Refeição,Alimento,Gramas,Porções,Carboidratos (g)';

  @override
  String get historyShareSubject => 'Histórico Libreta Dulce';

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
    return '$rac Porç.';
  }

  @override
  String get profileNotLoggedIn => 'Não conectado';

  @override
  String profilePhotoAccessibility(String name) {
    return 'Foto de perfil de $name';
  }

  @override
  String get profileDefaultName => 'Usuário';

  @override
  String get profileAboutTitle => 'Sobre o Libreta Dulce';

  @override
  String get profileAboutSubtitle => 'Feito com amor por e para diabéticos';

  @override
  String get profileAboutDialogTitle => 'Libreta Dulce';

  @override
  String get profileAboutDialogText =>
      'Olá, sou um desenvolvedor independente e criei este aplicativo para ajudar no controle diário de carboidratos e porções. Se tiver sugestões ou encontrar erros, por favor compartilhe.';

  @override
  String get profileAboutDialogClose => 'Fechar';

  @override
  String get profileInsulinSettings => 'Configurações de Insulina';

  @override
  String get profileInsulinSettingsDesc =>
      'Proporção, fator de correção e meta de glicose';

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
  String get adminTitle => 'Solicitações & Painel Global';

  @override
  String get adminTabRequests => 'Novas Solicitações';

  @override
  String get adminTabGlobal => 'Dados Globais';

  @override
  String get adminApproved => 'Alimento aprovado e publicado';

  @override
  String get adminRejected => 'Solicitação rejeitada';

  @override
  String get adminDeleted => 'Alimento excluído globalmente';

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
      'Tudo certo! Nenhuma nova solicitação pendente.';

  @override
  String get adminNoName => 'Sem nome';

  @override
  String adminCarbsInfo(String carbs) {
    return 'Carboidratos: ${carbs}g / 100g';
  }

  @override
  String adminUrlInfo(String url) {
    return 'Link/Informações extras: $url';
  }

  @override
  String get adminRejectButton => 'Rejeitar';

  @override
  String get adminApproveButton => 'Aprovar';

  @override
  String get adminEmptyGlobal => 'O banco de dados global está vazio.';

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
      'Isso removerá o alimento do banco de dados público. Os usuários não poderão mais buscá-lo.';

  @override
  String get adminDeleteButton => 'Excluir';

  @override
  String get adminLoadingRequests => 'Carregando solicitações';

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
  String get globalNotFound => 'Produto não encontrado';

  @override
  String get globalRequestTitle => 'Novo alimento';

  @override
  String get globalRequestDesc =>
      'Sua solicitação será revisada por uma pessoa antes de ser adicionada ao banco de dados global.';

  @override
  String get globalRequestName => 'Nome do produto';

  @override
  String get globalRequestBrand => 'Marca ou Descrição';

  @override
  String get globalRequestCarbs => 'Carboidratos por 100g';

  @override
  String get globalRequestUrl => 'Link do produto (Opcional)';

  @override
  String get globalRequestCancel => 'Cancelar';

  @override
  String get globalRequestSent => 'Solicitação enviada. Obrigado!';

  @override
  String get globalRequestSend => 'Enviar Solicitação';

  @override
  String globalAddedToMyFoods(String name) {
    return '$name adicionado aos seus alimentos';
  }

  @override
  String get globalScanTooltip => 'Escanear código de barras';

  @override
  String get globalNotFoundDB => 'Produto não encontrado no banco de dados';

  @override
  String get globalConnectionError => 'Erro de conexão';

  @override
  String globalErrorFirebase(String error) {
    return 'Erro do Firebase: $error';
  }

  @override
  String get foodsAddTitle => 'Adicionar alimento';

  @override
  String get foodsScanTooltip => 'Escanear código de barras';

  @override
  String get foodsNameLabel => 'Nome (ex.: Maçã)';

  @override
  String get foodsBrandLabel => 'Marca ou Desc. (Opcional)';

  @override
  String get foodsCarbsLabel => 'Carboidratos por 100g *';

  @override
  String get foodsCarbsSuffix => 'g';

  @override
  String get foodsKcalLabel => 'Kcal';

  @override
  String get foodsProteinLabel => 'Proteína';

  @override
  String get foodsFatLabel => 'Gordura';

  @override
  String get foodsCancel => 'Cancelar';

  @override
  String get foodsSave => 'Salvar';

  @override
  String get foodsNameRequired => 'O nome do alimento é obrigatório.';

  @override
  String get foodsCarbsRequired => 'Carboidratos por 100g são obrigatórios.';

  @override
  String get foodsCarbsInvalid =>
      'O valor de carboidratos não é um número válido.';

  @override
  String get foodsSearch => 'Buscar alimento...';

  @override
  String get foodsMustLogin => 'Você precisa iniciar sessão';

  @override
  String get foodsLoadingError => 'Erro ao carregar banco de dados.';

  @override
  String get foodsEmpty =>
      'Você ainda não tem alimentos salvos.\nAdicione o primeiro!';

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
    return 'Proteína: ${value}g';
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
  String get insulinTitle => 'Configurações de Insulina';

  @override
  String get insulinDesc =>
      'Estes valores são pessoais e privados. Configurá-los permite que o aplicativo calcule o bolus de insulina recomendado.';

  @override
  String get insulinRatioTitle => 'Proporção de insulina (unidades por porção)';

  @override
  String get insulinRatioBase => 'Proporção base *';

  @override
  String get insulinRatioHint => 'Ex.: 1,5';

  @override
  String get insulinRatioSuffix => 'unidades / porção';

  @override
  String get insulinRatioRequired => 'A proporção base é obrigatória';

  @override
  String get insulinInvalidNumber => 'Insira um número válido';

  @override
  String get insulinMealRatios => 'Proporções por refeição (opcional)';

  @override
  String get insulinFactorTitle => 'Fator de correção';

  @override
  String get insulinFactorLabel => 'Fator de correção *';

  @override
  String get insulinFactorHint => 'Ex.: 40';

  @override
  String get insulinFactorSuffix => 'mg/dL por unidade';

  @override
  String get insulinFactorRequired => 'O fator de correção é obrigatório';

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
  String get insulinGlucoseTargetRequired => 'A meta de glicose é obrigatória';

  @override
  String get insulinHalfUnits => 'Caneta de meia unidade';

  @override
  String get insulinHalfUnitsDesc =>
      'Permite doses com incrementos de 0,5 unidade';

  @override
  String get insulinRoundDown => 'Arredondar bolus para baixo';

  @override
  String get insulinRoundDownDesc =>
      'Trunca o bolus em vez de arredondar para o valor mais próximo. Útil para dosagem por faixas (ex.: 1 unidade por 50 mg/dL)';

  @override
  String get insulinSaving => 'Salvando...';

  @override
  String get insulinSave => 'Salvar Configurações';

  @override
  String get insulinSaved => 'Configurações de insulina salvas';

  @override
  String get insulinOptionalHint => 'Deixe vazio para usar a proporção base';

  @override
  String get foodSearchTitle => 'Buscar Alimento';

  @override
  String get foodSearchClose => 'Fechar busca';

  @override
  String get foodSearchHint => 'Ex.: Maçã, pão, arroz...';

  @override
  String get foodSearchEmptyList =>
      'Você ainda não tem alimentos na sua lista.';

  @override
  String foodSearchNoResults(String query) {
    return 'Nenhum resultado para \"$query\"';
  }

  @override
  String get barcodeTitle => 'Escanear código de barras';

  @override
  String get barcodeScannedFood => 'Alimento escaneado';

  @override
  String get confirmDeleteTitle => 'Confirmar exclusão';

  @override
  String get confirmDeleteCancel => 'Cancelar';

  @override
  String get confirmDeleteButton => 'Excluir';

  @override
  String get updateAvailable => 'Atualização disponível';

  @override
  String updateVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get updateLater => 'Depois';

  @override
  String get updateDownload => 'Baixar';

  @override
  String get updateDownloading => 'Baixando atualização...';

  @override
  String get updateError =>
      'Falha no download. Visite github.com/PokeSer/libretadulce/releases';

  @override
  String get updateWhatIsNew => 'Novidades';
}
