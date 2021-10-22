import 'package:booktrackerv2/pages/home.dart';
import 'package:booktrackerv2/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance!.imageCache!.maximumSizeBytes = 1000 << 20;

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          theme: notifier.darkTheme ? dark : light,
          home: const Home(),
        );
      },
    ),
  ));
}
