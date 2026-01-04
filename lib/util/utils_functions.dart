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
}
