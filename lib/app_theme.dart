import 'package:booktrackerv2/util/theme.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import 'app.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: const App(),
    );
  }
}
