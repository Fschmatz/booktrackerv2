import 'package:booktrackerv2/class/livro.dart';

import '../class/app_parameter.dart';
import '../enum/situacao_livro.dart';
import '../service/app_parameter_service.dart';
import '../service/livro_service.dart';
import 'app_action.dart';
import 'app_state.dart';

class LoadAppParametersAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<AppParameter> parameters = await AppParameterService().getAll();

    return state.copyWith(appParameters: parameters);
  }
}

class SaveAppParameterAction extends AppAction {
  final AppParameter appParameter;

  SaveAppParameterAction(this.appParameter);

  @override
  Future<AppState?> reduce() async {
    await AppParameterService().saveParameter(appParameter);
    List<AppParameter> parameters = await AppParameterService().getAll();

    return state.copyWith(appParameters: parameters);
  }
}

class LoadListLivroAction extends AppAction {
  final SituacaoLivro situacaoLivro;
  final bool forceReload;

  LoadListLivroAction(this.situacaoLivro, {this.forceReload = false});

  @override
  Future<AppState> reduce() async {
    switch (situacaoLivro) {
      case SituacaoLivro.LENDO:
        List<Livro> livros =
            state.listLendo.isEmpty || forceReload ? await LivroService().queryAllByStateAndConvertToList(SituacaoLivro.LENDO.id) : state.listLendo;

        return state.copyWith(listLendo: livros);
      case SituacaoLivro.PARA_LER:
        List<Livro> livros = state.listParaLer.isEmpty || forceReload
            ? await LivroService().queryAllByStateAndConvertToList(SituacaoLivro.PARA_LER.id)
            : state.listParaLer;

        return state.copyWith(listParaLer: livros);
      case SituacaoLivro.LIDO:
        List<Livro> livros =
            state.listLido.isEmpty || forceReload ? await LivroService().queryAllByStateAndConvertToList(SituacaoLivro.LIDO.id) : state.listLido;

        return state.copyWith(listLido: livros);
    }
  }
}

class ChangeTabAction extends AppAction {
  final SituacaoLivro newTab;

  ChangeTabAction(this.newTab);

  @override
  Future<AppState> reduce() async {
    return state.copyWith(currentTab: newTab);
  }
}
