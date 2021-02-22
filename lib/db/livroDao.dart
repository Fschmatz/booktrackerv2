import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class LivroDao {

  static final _databaseName = "BookTracker.db";
  static final _databaseVersion = 1;

  static final table = 'livro';
  static final columnIdLivro = 'idLivro';
  static final columnNome = 'nome';
  static final columnNumPaginas = 'numPaginas';
  static final columnAutor = 'autor';
  static final columnLido = 'lido'; //0 não 1 sim
  static final columnCapa = 'capa';

  LivroDao._privateConstructor();
  static final LivroDao instance = LivroDao._privateConstructor();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // Código SQL para criar o banco de dados e a tabela
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

  Future<List<Map<String, dynamic>>> queryAllLivrosParaLer() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnLido=0 ORDER BY $columnNome');
  }

  Future<List<Map<String, dynamic>>> queryAllLivrosLidos() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $table WHERE $columnLido=1 ORDER BY $columnNome');
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
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
}