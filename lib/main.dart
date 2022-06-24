import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 50;

  runApp(
    EasyDynamicThemeWidget(
      child: const AppTheme(),
    ),
  );
}
