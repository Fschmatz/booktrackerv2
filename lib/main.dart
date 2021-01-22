import 'package:booktrackerv2/pages/home.dart';
import 'package:booktrackerv2/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool exibirLidos = prefs.getBool('valorExibirLidos');
  if(exibirLidos == null){
    exibirLidos = false;
    prefs.setBool('valorExibirLidos', exibirLidos);
  }


  //notifier usado para o tema
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),

    child: Consumer<ThemeNotifier>(
      builder:(context, ThemeNotifier notifier, child){

        return MaterialApp(
          theme: notifier.darkTheme ? dark : light,
          home: Home(),
        );
      },
    ),
  )
  );
}

