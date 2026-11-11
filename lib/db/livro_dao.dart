import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class LivroDao {
  static const table = DatabaseHelper.tableLivros;
  static const columnIdLivro = DatabaseHelper.columnIdLivro;
  static const columnNome = DatabaseHelper.columnNome;
  static const columnNumPaginas = DatabaseHelper.columnNumPaginas;
  static const columnAutor = DatabaseHelper.columnAutor;
  static const columnSituacaoLivro = DatabaseHelper.columnSituacaoLivro;
  static const columnCapa = DatabaseHelper.columnCapa;
  static const columnCriadoEm = DatabaseHelper.columnCriadoEm;
  static const columnLendoEm = DatabaseHelper.columnLendoEm;
  static const columnFinalizadoEm = DatabaseHelper.columnFinalizadoEm;

  Future<Database> get database async => await DatabaseHelper.instance.database;

  LivroDao._privateConstructor();

  static final LivroDao instance = LivroDao._privateConstructor();

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllLivrosByEstado(int situacaoLivro) async {
    Database db = await instance.database;
    if (situacaoLivro == 2) {
      final anoAtual = DateTime.now().year.toString();
      return await db.rawQuery(
        'SELECT * FROM $table WHERE $columnSituacaoLivro=$situacaoLivro AND ($columnFinalizadoEm LIKE \'%/\' || ? OR $columnFinalizadoEm LIKE ? || \'%\') ORDER BY $columnNome',
        [anoAtual, anoAtual],
      );
    }
    return await db.rawQuery('SELECT * FROM $table WHERE $columnSituacaoLivro=$situacaoLivro ORDER BY $columnNome');
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnIdLivro];
    return await db.update(table, row, where: '$columnIdLivro = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnIdLivro = ?', whereArgs: [id]);
  }

  Future<int> deleteTodosLidos() async {
    Database db = await instance.database;
    return await db.delete('$table WHERE $columnSituacaoLivro=2');
  }

  Future<int?> contagemLivrosEstado(int situacaoLivro) async {
    Database db = await instance.database;
    if (situacaoLivro == 2) {
      final anoAtual = DateTime.now().year.toString();
      return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $table WHERE $columnSituacaoLivro=$situacaoLivro AND ($columnFinalizadoEm LIKE \'%/\' || ? OR $columnFinalizadoEm LIKE ? || \'%\')',
        [anoAtual, anoAtual],
      ));
    }
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE $columnSituacaoLivro=$situacaoLivro'));
  }

  Future<int?> contagemPaginasEstado(int situacaoLivro) async {
    Database db = await instance.database;
    if (situacaoLivro == 2) {
      final anoAtual = DateTime.now().year.toString();
      return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT SUM($columnNumPaginas) FROM $table WHERE $columnSituacaoLivro=$situacaoLivro AND ($columnFinalizadoEm LIKE \'%/\' || ? OR $columnFinalizadoEm LIKE ? || \'%\')',
        [anoAtual, anoAtual],
      ));
    }
    return Sqflite.firstIntValue(await db.rawQuery('SELECT SUM($columnNumPaginas) FROM $table WHERE $columnSituacaoLivro=$situacaoLivro'));
  }

  Future<int?> findContagemAutoresDistinct() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(DISTINCT $columnAutor) FROM $table'));
  }

  Future<Map<String, dynamic>?> getEstatisticasLivro() async {
    Database db = await instance.database;
    final anoAtual = DateTime.now().year.toString();
    final result = await db.rawQuery('''
      SELECT 
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 0 THEN 1 ELSE 0 END), 0) AS livrosLendo,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 1 THEN 1 ELSE 0 END), 0) AS livrosParaLer,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 2 AND ($columnFinalizadoEm LIKE '%/' || ? OR $columnFinalizadoEm LIKE ? || '%') THEN 1 ELSE 0 END), 0) AS livrosLidos,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 0 THEN $columnNumPaginas ELSE 0 END), 0) AS paginasLendo,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 1 THEN $columnNumPaginas ELSE 0 END), 0) AS paginasParaLer,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 2 AND ($columnFinalizadoEm LIKE '%/' || ? OR $columnFinalizadoEm LIKE ? || '%') THEN $columnNumPaginas ELSE 0 END), 0) AS paginasLidos,
        IFNULL(SUM(CASE WHEN $columnCriadoEm LIKE '%/' || ? THEN 1 ELSE 0 END), 0) AS livrosAdicionadosAnoAtual,
        COUNT(DISTINCT $columnAutor) AS quantidadeAutores,
        ROUND(AVG(CASE WHEN $columnNumPaginas > 0 THEN $columnNumPaginas ELSE NULL END)) AS mediaPaginas,
        (SELECT $columnNome FROM $table WHERE $columnNumPaginas > 0 ORDER BY $columnNumPaginas ASC, $columnIdLivro ASC LIMIT 1) AS menorLivroNome,
        (SELECT $columnNumPaginas FROM $table WHERE $columnNumPaginas > 0 ORDER BY $columnNumPaginas ASC, $columnIdLivro ASC LIMIT 1) AS menorLivroPaginas,
        (SELECT $columnNome FROM $table WHERE $columnNumPaginas > 0 ORDER BY $columnNumPaginas DESC, $columnIdLivro ASC LIMIT 1) AS maiorLivroNome,
        (SELECT $columnNumPaginas FROM $table WHERE $columnNumPaginas > 0 ORDER BY $columnNumPaginas DESC, $columnIdLivro ASC LIMIT 1) AS maiorLivroPaginas
      FROM $table
    ''', [anoAtual, anoAtual, anoAtual, anoAtual, anoAtual]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> queryNomeAllLivrosLidos() async {
    Database db = await instance.database;
    final anoAtual = DateTime.now().year.toString();
    return await db.rawQuery(
      'SELECT nome FROM $table WHERE $columnSituacaoLivro=2 AND ($columnFinalizadoEm LIKE \'%/\' || ? OR $columnFinalizadoEm LIKE ? || \'%\') ORDER BY $columnNome',
      [anoAtual, anoAtual],
    );
  }

  Future<List<Map<String, dynamic>>> queryHistoricoAnos() async {
    Database db = await instance.database;
    return await db.rawQuery('''
      SELECT 
        CASE 
          WHEN $columnFinalizadoEm LIKE '%/%/%' THEN SUBSTR($columnFinalizadoEm, -4)
          WHEN $columnFinalizadoEm LIKE '____-%' THEN SUBSTR($columnFinalizadoEm, 1, 4)
          ELSE NULL 
        END AS ano,
        COUNT(*) AS quantidadeLivros,
        IFNULL(SUM($columnNumPaginas), 0) AS totalPaginas
      FROM $table
      WHERE $columnSituacaoLivro = 2 
        AND $columnFinalizadoEm IS NOT NULL 
        AND $columnFinalizadoEm != ''
      GROUP BY ano
      HAVING ano IS NOT NULL AND LENGTH(ano) = 4
      ORDER BY ano DESC
    ''');
  }

  Future<List<Map<String, dynamic>>> queryLivrosLidosByAno(String ano) async {
    Database db = await instance.database;
    return await db.rawQuery(
      'SELECT * FROM $table WHERE $columnSituacaoLivro=2 AND ($columnFinalizadoEm LIKE \'%/\' || ? OR $columnFinalizadoEm LIKE ? || \'%\') ORDER BY $columnNome',
      [ano, ano],
    );
  }

  Future<int> limparCapasAnosAnteriores() async {
    Database db = await instance.database;
    final anoAtual = DateTime.now().year.toString();
    return await db.rawUpdate('''
      UPDATE $table 
      SET $columnCapa = NULL 
      WHERE $columnSituacaoLivro = 2 
        AND $columnCapa IS NOT NULL
        AND NOT ($columnFinalizadoEm LIKE '%/' || ? OR $columnFinalizadoEm LIKE ? || '%')
    ''', [anoAtual, anoAtual]);
  }

  Future<int?> contarCapasAnosAnteriores() async {
    Database db = await instance.database;
    final anoAtual = DateTime.now().year.toString();
    return Sqflite.firstIntValue(await db.rawQuery('''
      SELECT COUNT(*) 
      FROM $table 
      WHERE $columnSituacaoLivro = 2 
        AND $columnCapa IS NOT NULL
        AND NOT ($columnFinalizadoEm LIKE '%/' || ? OR $columnFinalizadoEm LIKE ? || '%')
    ''', [anoAtual, anoAtual]));
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
