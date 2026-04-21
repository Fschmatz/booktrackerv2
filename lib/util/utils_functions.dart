import 'package:url_launcher/url_launcher.dart';

import 'app_details.dart';

class UtilsFunctions {
  static openGithubRepository() {
    launchBrowser(AppDetails.repositoryLink);
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
}
