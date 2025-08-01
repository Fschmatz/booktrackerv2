import 'package:booktrackerv2/class/livro.dart';

import '../service/livro_service.dart';
import 'app_action.dart';
import 'app_state.dart';

class LoadListLivroAction extends AppAction {
  final int paginaAtual;

  LoadListLivroAction(this.paginaAtual);

  @override
  Future<AppState> reduce() async {
    switch (paginaAtual) {
      case 0:
        List<Livro> livros = state.listLendo.isEmpty ? await LivroService().queryAllByStateAndConvertToList(state.paginaAtual) : state.listLendo;

        return state.copyWith(listLendo: livros);
      case 1:
        List<Livro> livros = state.listParaLer.isEmpty ? await LivroService().queryAllByStateAndConvertToList(state.paginaAtual) : state.listParaLer;
        return state.copyWith(listParaLer: livros);
      case 2:
        List<Livro> livros = state.listLido.isEmpty ? await LivroService().queryAllByStateAndConvertToList(state.paginaAtual) : state.listLido;

        return state.copyWith(listLido: livros);
      default:
        return state.copyWith();
    }
  }
}

/*class LoadListLivroAction extends AppAction {
  @override
  Future<AppState> reduce() async {
    List<Livro> livros = await LivroService().queryAllByStateAndConvertToList(state.paginaAtual);

    switch (state.paginaAtual) {
      case 0:
        return state.copyWith(listLendo: livros);
      case 1:
        return state.copyWith(listParaLer: livros);
      case 2:
        return state.copyWith(listLido: livros);
      default:
        return state.copyWith();
    }
  }
}*/

class AlterarPaginaAtualAction extends AppAction {
  final int pagina;

  AlterarPaginaAtualAction(this.pagina);

  @override
  Future<AppState> reduce() async {
    return state.copyWith(paginaAtual: pagina);
  }
}
