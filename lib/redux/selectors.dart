import '../class/app_parameter.dart';
import '../class/livro.dart';
import '../enum/situacao_livro.dart';
import 'app_state.dart';

List<Livro> selectListLivroByPaginaAtual(AppState state, SituacaoLivro situacaoLivro) {
  switch (situacaoLivro) {
    case SituacaoLivro.LENDO:
      return state.listLendo;
    case SituacaoLivro.PARA_LER:
      return state.listParaLer;
    case SituacaoLivro.LIDO:
      return state.listLido;
  }
}

SituacaoLivro selectCurrentTab(AppState state) => state.currentTab;

List<AppParameter> selectAppParameters(AppState state) => state.appParameters;

String? selectParameterValueByKey(AppState state, String key) {
  try {
    return state.appParameters
        .firstWhere((element) => element.getKey() == key)
        .getValue();
  } catch (e) {
    return null;
  }
}

bool selectParameterValueByKeyAsBoolean(AppState state, String key, {bool defaultValue = true}) {
  String? value = selectParameterValueByKey(state, key);

  if (value == null) {
    return defaultValue;
  }

  return value == "true";
}
