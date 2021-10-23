import 'package:booktrackerv2/app.dart';
import 'package:booktrackerv2/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance!.imageCache!.maximumSizeBytes = 1000 << 20;

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          theme: notifier.darkTheme ? dark : light,
          home: const App(),
        );
      },
    ),
  ));
}
