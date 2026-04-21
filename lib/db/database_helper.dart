import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "BookTracker.db";
  static const _databaseVersion = 3;

  // Livros
  static const tableLivros = 'livro';
  static const columnIdLivro = 'idLivro';
  static const columnNome = 'nome';
  static const columnNumPaginas = 'numPaginas';
  static const columnAutor = 'autor';
  static const columnSituacaoLivro = 'situacaoLivro';
  static const columnCapa = 'capa';
  static const columnCriadoEm = 'criadoEm';
  static const columnFinalizadoEm = 'finalizadoEm';

  // App Parameters
  static const tableAppParameters = 'app_parameters';
  static const columnParamKey = 'key';
  static const columnParamValue = 'value';

  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Livros
    await db.execute('''
          CREATE TABLE $tableLivros (
            $columnIdLivro INTEGER PRIMARY KEY,            
            $columnNome TEXT NOT NULL,
            $columnNumPaginas INTEGER,
            $columnAutor TEXT,  
            $columnSituacaoLivro INTEGER NOT NULL,
            $columnCapa BLOB,
            $columnCriadoEm TEXT,
            $columnFinalizadoEm TEXT
          )
          ''');

    // App Parameters
    await db.execute('''
          CREATE TABLE $tableAppParameters (
            $columnParamKey TEXT PRIMARY KEY,
            $columnParamValue TEXT
          )
          ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
          CREATE TABLE $tableAppParameters (
            $columnParamKey TEXT PRIMARY KEY,
            $columnParamValue TEXT
          )
          ''');
    }

    if (oldVersion < 3) {
      await db.execute('ALTER TABLE $tableLivros ADD COLUMN $columnCriadoEm TEXT');
      await db.execute('ALTER TABLE $tableLivros ADD COLUMN $columnFinalizadoEm TEXT');
    }
  }
}
