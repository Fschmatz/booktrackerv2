import 'package:booktrackerv2/service/store_service.dart';

import '../class/historico_ano.dart';
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

  Future<void> atualizar(Livro livro, {SituacaoLivro? situacaoAntiga}) async {
    await dbLivro.update(livro.toMap());

    if (situacaoAntiga != null && situacaoAntiga.id != livro.situacaoLivro) {
      await loadLivrosParaAlterarSituacao(situacaoAntiga, SituacaoLivro.fromId(livro.situacaoLivro!));
    } else {
      await loadLivros(SituacaoLivro.fromId(livro.situacaoLivro!));
    }
  }

  Future<void> mudarSituacao(Livro livro, SituacaoLivro novaSituacao) async {
    final String dataAtual = UtilsFunctions.getDataAtualAsString();
    Livro livroAtualizado = livro.copyWith(
      situacaoLivro: novaSituacao.id,
      finalizadoEm: novaSituacao == SituacaoLivro.LIDO ? dataAtual : "",
      lendoEm: novaSituacao == SituacaoLivro.LENDO ? dataAtual : livro.lendoEm,
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

  Future<Map<String, dynamic>?> getEstatisticasLivro() async {
    return await dbLivro.getEstatisticasLivro();
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

  Future<List<HistoricoAno>> getHistoricoAnos() async {
    final list = await dbLivro.queryHistoricoAnos();
    return list.map((map) => HistoricoAno.fromMap(map)).toList();
  }

  Future<List<Livro>> queryLivrosLidosByAno(String ano) async {
    final list = await dbLivro.queryLivrosLidosByAno(ano);
    return list.isNotEmpty ? list.map((map) => Livro.fromMap(map)).toList() : [];
  }

  Future<int> limparCapasAnosAnteriores() async {
    return await dbLivro.limparCapasAnosAnteriores();
  }

  Future<int?> contarCapasAnosAnteriores() async {
    return await dbLivro.contarCapasAnosAnteriores();
  }
}
