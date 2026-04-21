import '../class/app_parameter.dart';
import '../class/livro.dart';
import '../enum/situacao_livro.dart';
import '../main.dart';

List<Livro> selectListLivroByPaginaAtual(SituacaoLivro situacaoLivro) {
  switch (situacaoLivro.id) {
    case 0:
      return store.state.listLendo;
    case 1:
      return store.state.listParaLer;
    case 2:
      return store.state.listLido;
    default:
      return [];
  }
}

List<AppParameter> selectAppParameters() => store.state.appParameters;

String? selectParameterValueByKey(String key) {
  try {
    return store.state.appParameters
        .firstWhere((element) => element.getKey() == key)
        .getValue();
  } catch (e) {
    return null;
  }
}

bool selectParameterValueByKeyAsBoolean(String key, {bool defaultValue = true}) {
  String? value = selectParameterValueByKey(key);

  if (value == null) {
    return defaultValue;
  }

  return value == "true";
}
