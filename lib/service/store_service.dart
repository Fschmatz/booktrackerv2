import '../enum/situacao_livro.dart';
import '../main.dart';
import '../redux/actions.dart';

abstract class StoreService {
  Future<void> loadLivros(SituacaoLivro situacaoLivro) async {
    await store.dispatch(LoadListLivroAction(situacaoLivro, forceReload: true));
  }

  Future<void> loadLivrosParaAlterarSituacao(SituacaoLivro situacaoLivroAnterior, SituacaoLivro situacaoLivroNova) async {
    await store.dispatchAndWaitAll(
        [LoadListLivroAction(situacaoLivroAnterior, forceReload: true), LoadListLivroAction(situacaoLivroNova, forceReload: true)]);
  }

  Future<void> loadLivrosParaEstatisticas() async {
    await store.dispatchAndWaitAll(
        [LoadListLivroAction(SituacaoLivro.LIDO, forceReload: true), LoadListLivroAction(SituacaoLivro.PARA_LER, forceReload: true)]);
  }

  Future<void> loadAllLivros() async {
    await store.dispatchAndWaitAll([
      LoadListLivroAction(SituacaoLivro.LIDO, forceReload: true),
      LoadListLivroAction(SituacaoLivro.PARA_LER, forceReload: true),
      LoadListLivroAction(SituacaoLivro.LENDO, forceReload: true)
    ]);
  }
}
