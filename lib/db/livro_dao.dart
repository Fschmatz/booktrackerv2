import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE $columnSituacaoLivro=$situacaoLivro'));
  }

  Future<int?> contagemPaginasEstado(int situacaoLivro) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT SUM($columnNumPaginas) FROM $table WHERE $columnSituacaoLivro=$situacaoLivro'));
  }

  Future<int?> findContagemAutoresDistinct() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(DISTINCT $columnAutor) FROM $table'));
  }

  Future<Map<String, dynamic>?> getEstatisticasLivro() async {
    Database db = await instance.database;
    final result = await db.rawQuery('''
      SELECT 
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 0 THEN 1 ELSE 0 END), 0) AS livrosLendo,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 1 THEN 1 ELSE 0 END), 0) AS livrosParaLer,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 2 THEN 1 ELSE 0 END), 0) AS livrosLidos,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 0 THEN $columnNumPaginas ELSE 0 END), 0) AS paginasLendo,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 1 THEN $columnNumPaginas ELSE 0 END), 0) AS paginasParaLer,
        IFNULL(SUM(CASE WHEN $columnSituacaoLivro = 2 THEN $columnNumPaginas ELSE 0 END), 0) AS paginasLidos,
        COUNT(DISTINCT $columnAutor) AS quantidadeAutores
      FROM $table
    ''');
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> queryNomeAllLivrosLidos() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT nome FROM $table WHERE $columnSituacaoLivro=2 ORDER BY $columnNome');
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
