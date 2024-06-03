import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_details.dart';

class Utils {

  openGithubRepository() {
    launchBrowser(AppDetails.repositoryLink);
  }

  launchBrowser(String url) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

}