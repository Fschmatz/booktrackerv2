import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

class AppParameterDAO {
  static const table = DatabaseHelper.tableAppParameters;
  static const columnKey = DatabaseHelper.columnParamKey;
  static const columnValue = DatabaseHelper.columnParamValue;

  AppParameterDAO._privateConstructor();
  static final AppParameterDAO instance = AppParameterDAO._privateConstructor();

  Future<Database> get database async => await DatabaseHelper.instance.database;

  Future<int> insertOrUpdate(Map<String, dynamic> row) async {
    Database db = await instance.database;
    
    return await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> delete(String key) async {
    Database db = await instance.database;

    return await db.delete(table, where: '$columnKey = ?', whereArgs: [key]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;

    return await db.query(table);
  }

  Future<Map<String, dynamic>?> queryByKey(String key) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(
      table,
      where: '$columnKey = ?',
      whereArgs: [key],
    );

    if (results.isNotEmpty) {
      return results.first;
    }

    return null;
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
