import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFF3F3F3),
    accentColor: Colors.green[700],
    canvasColor: Colors.black,
    scaffoldBackgroundColor: Color(0xFFF3F3F3),
    cardTheme: CardTheme(
      color: Color(0xFFFFFFFF), //0xFFFAFAFC
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xFFFAFAFA),
        focusColor: Colors.green[700],
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green[700]!,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(10.0))),
    bottomAppBarColor: Color(0xFFE9E9E9),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Colors.green[700]),
      selectedLabelStyle: TextStyle(color: Colors.green[700]),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFFE5E5E5),
    ),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFFFF)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF202022),
    accentColor: Color(0xFF66BF72),
    scaffoldBackgroundColor: Color(0xFF202022),
    canvasColor: Colors.black,
    cardTheme: CardTheme(
      color: Color(0xFF2D2D2F),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF2D2D2F),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xFF353537),
        focusColor: Color(0xFF66BF72),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF66BF72),
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(10.0))),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Color(0xFF66BF72)),
      selectedLabelStyle: TextStyle(color: Color(0xFF66BF72)),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFF151517),
    ),
    bottomAppBarColor: Color(0xFF151517),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF202022)));

class ThemeNotifier extends ChangeNotifier {
  final String key = 'valorTema';
  late SharedPreferences prefs;
  late bool _darkTheme;

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
    prefs = await SharedPreferences.getInstance();
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