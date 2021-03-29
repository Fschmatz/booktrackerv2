import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
    ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFF1F1F9),
    accentColor: Colors.green[700],
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Color(0xFFF1F1F9),
    cardTheme: CardTheme(
      color: Color(0xFFF5F5FE), //0xFFFAFAFC
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFF9F9FF),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xFFF0F0F6),
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF282828)))),

    bottomAppBarColor: Color(0xFFE6E6EF),
    bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: Color(0xFFF5F5FE))
    );

//ESCURO
    ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF202022),
    accentColor: Color(0xFF66BF72),  //0xFF867aa3 roxoneutro //0xFF6B89BF azl neutro
    scaffoldBackgroundColor: Color(0xFF202022),
    canvasColor: Colors.black,

    cardTheme: CardTheme(
      color: Color(0xFF202022), //Color(0xFF29292C)
    ),

    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF202022),
    ),

    inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xFF353537),
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF66BF72))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF282829)))),

    bottomAppBarColor: Color(0xFF18181A),
    bottomSheetTheme:
      BottomSheetThemeData(modalBackgroundColor: Color(0xFF202022))

    );

class ThemeNotifier extends ChangeNotifier {
  final String key = 'valorTema';
  SharedPreferences prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _darkTheme);
  }
}
