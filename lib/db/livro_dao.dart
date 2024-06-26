import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class LivroDao {

  static const _databaseName = "BookTracker.db";
  static const _databaseVersion = 1;

  static const table = 'livro';
  static const columnIdLivro = 'idLivro';
  static const columnNome = 'nome';
  static const columnNumPaginas = 'numPaginas';
  static const columnAutor = 'autor';
  static const columnLido = 'lido'; // 0 = ler , 1 = lendo , 2 = lido
  static const columnCapa = 'capa';

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  LivroDao._privateConstructor();
  static final LivroDao instance = LivroDao._privateConstructor();

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnIdLivro INTEGER PRIMARY KEY,            
            $columnNome TEXT NOT NULL,
            $columnNumPaginas INTEGER,
            $columnAutor TEXT,  
            $columnLido INTEGER NOT NULL,
            $columnCapa BLOB
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllLivrosByEstado(int estado) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnLido=$estado ORDER BY $columnNome');
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
    return await db.delete('$table WHERE $columnLido=2');
  }

  Future<int?> contagemLivrosEstado(int estado) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table WHERE $columnLido=$estado'));
  }

  Future<int?> contagemPaginasEstado(int estado) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT SUM($columnNumPaginas) FROM $table WHERE $columnLido=$estado'));
  }

  Future<int?> contagemAutores() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT  COUNT(DISTINCT $columnAutor) FROM $table'));
  }

  Future<List<Map<String, dynamic>>> queryNomeAllLivrosLidos() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT nome FROM $table WHERE $columnLido=2 ORDER BY $columnNome');
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

}
