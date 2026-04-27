import 'package:booktrackerv2/service/store_service.dart';

import '../class/livro.dart';
import '../db/livro_dao.dart';
import '../enum/situacao_livro.dart';
import '../util/utils_functions.dart';

class LivroService extends StoreService {
  final dbLivro = LivroDao.instance;

  Future<List<Livro>> queryAllByStateAndConvertToList(int stateValue) async {
    var resp = await dbLivro.queryAllLivrosByEstado(stateValue);

    return resp.isNotEmpty ? resp.map((map) => Livro.fromMap(map)).toList() : [];
  }

  Future<void> deletar(Livro livro) async {
    await dbLivro.delete(livro.id!);
    await loadLivros(SituacaoLivro.fromId(livro.situacaoLivro!));
  }

  Future<void> atualizar(Livro livro) async {
    await dbLivro.update(livro.toMap());
    await loadLivros(SituacaoLivro.fromId(livro.situacaoLivro!));
  }

  Future<void> mudarSituacao(Livro livro, SituacaoLivro novaSituacao) async {
    Livro livroAtualizado = livro.copyWith(
      situacaoLivro: novaSituacao.id,
      finalizadoEm: novaSituacao == SituacaoLivro.LIDO ? UtilsFunctions.getDataAtualAsString() : "",
    );

    await dbLivro.update(livroAtualizado.toMap());
    await loadLivrosParaAlterarSituacao(SituacaoLivro.fromId(livro.situacaoLivro!), novaSituacao);
  }

  Future<void> inserir(Livro livro) async {
    await dbLivro.insert(livro.toMap());
    await loadLivros(SituacaoLivro.fromId(livro.situacaoLivro!));
  }

  Future<int?> findContagemAutoresDistinct() async {
    return await dbLivro.findContagemAutoresDistinct();
  }

  Future<void> loadAllLivrosParaEstatisticas() async {
    await loadLivrosParaEstatisticas();
  }

  Future<void> loadAllAfterBackup() async {
    await loadAllLivros();
  }

  Future<void> deletarLivrosLidos() async {
    await dbLivro.deleteTodosLidos();
    await loadLivros(SituacaoLivro.LIDO);
  }
}
