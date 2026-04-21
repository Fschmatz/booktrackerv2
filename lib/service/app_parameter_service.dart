import '../db/app_parameter_dao.dart';
import '../class/app_parameter.dart';
import '../main.dart';
import 'store_service.dart';

class AppParameterService extends StoreService {
  final dbParams = AppParameterDAO.instance;

  Future<void> saveParameter(AppParameter parameter) async {
    await dbParams.insertOrUpdate(parameter.toMap());
    await loadAppParameters();
  }

  Future<void> deleteParameter(String key) async {
    await dbParams.delete(key);
    await loadAppParameters();
  }

  Future<List<AppParameter>> getAll() async {
    var resp = await dbParams.queryAllRows();
    
    return resp.isNotEmpty
        ? resp.map((map) => AppParameter.fromMap(map)).toList()
        : [];
  }

  Future<void> saveLastBackupDate() async {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year;
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    
    final formattedDate = '$day/$month/$year $hour:$minute';

    await saveParameter(AppParameter(
      key: 'lastBackupDate',
      value: formattedDate,
    ));
  }

  Future<String?> getLastBackupDate() async {
    var resp = await dbParams.queryByKey('lastBackupDate');
    return resp != null ? AppParameter.fromMap(resp).getValue() : null;
  }

  Future<List<Map<String, dynamic>>> loadAllParameters() {
    return dbParams.queryAllRows();
  }

  Future<void> deleteAllParameters() async {
    await dbParams.deleteAll();
  }

  Future<void> insertParametersFromRestoreBackup(List<dynamic> jsonData) async {
    for (var item in jsonData) {
      await dbParams.insertOrUpdate(item as Map<String, dynamic>);
    }
    await loadAppParameters();
  }
}
