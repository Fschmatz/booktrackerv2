import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
    ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFF9F9FF),
    accentColor: Color(0xFF867aa3),

    scaffoldBackgroundColor: Color(0xFFF9F9FF),
    cardTheme: CardTheme(
      color: Color(0xFFF9F9FF), //0xFFFAFAFC
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFF9F9FF),
    ),
    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF867aa3))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF282828)))),

    bottomAppBarColor: Color(0xFFE7E7EF),
    //Color(0xFFE0E0E4)
    bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: Color(0xFFF8F8FC)) //0xFFF6F6FA
    );

//ESCURO
    ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF202021),
    accentColor: Color(0xFF867aa3),//Colors.teal
    scaffoldBackgroundColor: Color(0xFF202021),

    cardTheme: CardTheme(
      color: Color(0xFF202021), //Color(0xFF29292C)
    ),

    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF202021),
    ),

    inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF867aa3))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF282828)))),

    bottomAppBarColor: Color(0xFF181819),//0xFF0xFF181819
    bottomSheetTheme:
      BottomSheetThemeData(modalBackgroundColor: Color(0xFF202021)) //0xFF252529

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
