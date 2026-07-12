import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_constants.dart';

class UtilsFunctions {
  static openGithubRepository() {
    launchBrowser(AppConstants.repositoryLink);
  }

  static launchBrowser(String url) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  static String getDataAtualAsString() {
    return "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}";
  }

  static String getBackupFilename() {
    String name = AppConstants.backupFileName;
    String dateTimeStr = Jiffy.now().format(pattern: 'dd_MM_yyyy_HHmmss');
    return '${name}_$dateTimeStr.json';
  }
}
