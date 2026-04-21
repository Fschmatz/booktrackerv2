import 'dart:convert';
import 'dart:io';

import 'package:booktrackerv2/service/livro_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../db/livro_dao.dart';

import '../service/app_parameter_service.dart';

class UtilsBackup {
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

  Future<List<Map<String, dynamic>>> _loadAllParameters() async {
    return AppParameterService().loadAllParameters();
  }

  Future<void> _deleteAllParameters() async {
    await AppParameterService().deleteAllParameters();
  }

  Future<void> _insertParameters(List<dynamic> jsonData) async {
    await AppParameterService().insertParametersFromRestoreBackup(jsonData);
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
    await AppParameterService().saveLastBackupDate();

    List<Map<String, dynamic>> listBooks = await _loadAllBooks();
    List<Map<String, dynamic>> listParameters = await _loadAllParameters();

    if (listBooks.isNotEmpty) {
      Map<String, dynamic> combinedData = {
        'books': listBooks,
        'parameters': listParameters,
      };

      await _saveDataAsJson(combinedData, fileName);

      Fluttertoast.showToast(
        msg: "Backup completo!",
      );
    } else {
      Fluttertoast.showToast(
        msg: "Nenhum dado encontrado!",
      );
    }
  }

  Future<void> _saveDataAsJson(Map<String, dynamic> data, String fileName) async {
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
      final dynamic decodedJson = json.decode(jsonString);

      if (decodedJson is List) {
        // Backup Antigo (Somente Livros)
        await _deleteAllBooks();
        await _insertAll(decodedJson);
      } else if (decodedJson is Map<String, dynamic>) {
        // Backup Novo (Livros + Parâmetros)
        if (decodedJson.containsKey('books')) {
          await _deleteAllBooks();
          await _insertAll(decodedJson['books']);
        }

        if (decodedJson.containsKey('parameters')) {
          await _deleteAllParameters();
          await _insertParameters(decodedJson['parameters']);
        }
      }

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
