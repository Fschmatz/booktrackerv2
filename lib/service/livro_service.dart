import 'package:booktrackerv2/service/store_service.dart';

import '../class/livro.dart';
import '../db/livro_dao.dart';
import '../enum/situacao_livro.dart';

class LivroService extends StoreService {
  final dbLivro = LivroDao.instance;

  Future<List<Livro>> queryAllByStateAndConvertToList(int stateValue) async {
    var resp = await dbLivro.queryAllLivrosByEstado(stateValue);

    return resp.isNotEmpty ? resp.map((map) => Livro.fromMap(map)).toList() : [];
  }

  Future<void> deletar(Livro livro) async {
    await dbLivro.delete(livro.id);
    await loadLivros(SituacaoLivro.fromId(livro.situacaoLivro!));
  }

  Future<void> atualizar(int id, String nome, String numPaginas, String autor, int situacaoLivro, dynamic capa) async {
    final dbLivro = LivroDao.instance;
    Map<String, dynamic> row = {
      LivroDao.columnIdLivro: id,
      LivroDao.columnNome: nome,
      LivroDao.columnNumPaginas: numPaginas,
      LivroDao.columnAutor: autor,
      LivroDao.columnSituacaoLivro: situacaoLivro,
      LivroDao.columnCapa: capa,
    };

    await dbLivro.update(row);
    await loadLivros(SituacaoLivro.fromId(situacaoLivro));
  }

  Future<void> mudarSituacao(Livro livro, SituacaoLivro situacaoLivro) async {
    final dbLivro = LivroDao.instance;
    Map<String, dynamic> row = {
      LivroDao.columnIdLivro: livro.id,
      LivroDao.columnSituacaoLivro: situacaoLivro.id,
    };

    await dbLivro.update(row);
    await loadLivrosParaAlterarSituacao(SituacaoLivro.fromId(livro.situacaoLivro!), situacaoLivro);
  }

  Future<void> inserir(String nome, String numPaginas, String autor, int situacaoLivro, dynamic capa) async {
    Map<String, dynamic> row = {
      LivroDao.columnNome: nome,
      LivroDao.columnNumPaginas: numPaginas.isEmpty ? 0 : int.parse(numPaginas),
      LivroDao.columnAutor: autor,
      LivroDao.columnSituacaoLivro: situacaoLivro,
      LivroDao.columnCapa: capa,
    };

    await dbLivro.insert(row);
    await loadLivros(SituacaoLivro.fromId(situacaoLivro));
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
