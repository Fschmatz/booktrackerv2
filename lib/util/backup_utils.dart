import 'dart:convert';
import 'dart:io';

import 'package:booktrackerv2/service/livro_service.dart';
import 'package:booktrackerv2/util/toast_utils.dart';
import 'package:booktrackerv2/util/utils_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../db/livro_dao.dart';
import '../service/app_parameter_service.dart';

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

  Future<void> backupData() async {
    final int? capasAntigas = await dbLivro.contarCapasAnosAnteriores();

    if (capasAntigas != null && capasAntigas > 0) {
      await dbLivro.limparCapasAnosAnteriores();
    }

    await AppParameterService().saveLastBackupDate();

    List<Map<String, dynamic>> listBooks = await _loadAllBooks();
    List<Map<String, dynamic>> listParameters = await _loadAllParameters();

    if (listBooks.isNotEmpty) {
      Map<String, dynamic> combinedData = {
        'books': listBooks,
        'parameters': listParameters,
      };

      await _saveListAsJsonAndShare(combinedData);

      ToastUtils.show(
        "Backup completo!",
      );
    } else {
      ToastUtils.showErrorMessage(
        "Nenhum dado encontrado!",
      );
    }
  }

  Future<bool> _saveListAsJsonAndShare(Map<String, dynamic> data) async {
    try {
      final directory = await getTemporaryDirectory();
      final newFileName = UtilsFunctions.getBackupFilename();
      final file = File('${directory.path}/$newFileName');

      await file.writeAsString(json.encode(data));

      await Share.shareXFiles([XFile(file.path)], text: 'Backup $newFileName');

      return true;
    } catch (e) {
      ToastUtils.showErrorMessage('Erro!');
      return false;
    }
  }

  Future<bool> restoreBackupData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final dynamic decodedJson = json.decode(jsonString);

        if (decodedJson.containsKey('books')) {
          await _deleteAllBooks();
          await _insertAll(decodedJson['books']);
        }

        if (decodedJson.containsKey('parameters')) {
          await _deleteAllParameters();
          await _insertParameters(decodedJson['parameters']);
        }

        ToastUtils.show(
          "Successo!",
        );
        return true;
      }
      return false;
    } catch (e) {
      ToastUtils.showErrorMessage(
        "Erro!",
      );
      return false;
    }
  }
}
