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
