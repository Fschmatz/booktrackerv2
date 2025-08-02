import 'dart:convert';
import 'dart:io';

import 'package:booktrackerv2/service/livro_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../db/livro_dao.dart';

class BackupUtils {
  final dbLivro = LivroDao.instance;

  Future<List<Map<String, dynamic>>> _loadAllBooks() async {
    return dbLivro.queryAllRows();
  }

  Future<void> _deleteAllBooks() async {
    await dbLivro.deleteAll();
  }

  Future<void> _insertAll(List<dynamic> jsonData) async {
    for (dynamic item in jsonData) {
      await dbLivro.insert(item);
    }

    await LivroService().loadAllAfterBackup();
  }

  /* END PER APP SPECIFIC FUNCTIONS */

  Future<void> _loadStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  // Always using Android Download folder
  Future<String> _loadDirectory() async {
    bool dirDownloadExists = true;
    String directory = "/storage/emulated/0/Download/";

    dirDownloadExists = await Directory(directory).exists();
    if (dirDownloadExists) {
      directory = "/storage/emulated/0/Download/";
    } else {
      directory = "/storage/emulated/0/Downloads/";
    }

    return directory;
  }

  Future<void> backupData(String fileName) async {
    await _loadStoragePermission();

    List<Map<String, dynamic>> list = await _loadAllBooks();

    if (list.isNotEmpty) {
      await _saveListAsJson(list, fileName);

      Fluttertoast.showToast(
        msg: "Backup completo!",
      );
    } else {
      Fluttertoast.showToast(
        msg: "Nenhum dado encontrado!",
      );
    }
  }

  Future<void> _saveListAsJson(List<Map<String, dynamic>> data, String fileName) async {
    try {
      String directory = await _loadDirectory();

      final file = File('$directory/$fileName.json');

      await file.writeAsString(json.encode(data));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro!",
      );
    }
  }

  Future<void> restoreBackupData(String fileName) async {
    await _loadStoragePermission();

    try {
      String directory = await _loadDirectory();

      final file = File('$directory/$fileName.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = json.decode(jsonString);

      await _deleteAllBooks();
      await _insertAll(jsonData);

      Fluttertoast.showToast(
        msg: "Successo!",
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro!",
      );
    }
  }
}
