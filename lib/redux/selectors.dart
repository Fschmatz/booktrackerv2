import '../class/livro.dart';
import '../main.dart';

List<Livro> selectListLivroByPaginaAtual() {
  int paginaAtual = selectPaginaAtual();

  switch (paginaAtual) {
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

int selectPaginaAtual() => store.state.paginaAtual;
