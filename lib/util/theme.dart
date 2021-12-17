import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFFFFF),
    accentColor: const Color(0xFF066D2B),
    canvasColor: Colors.black,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF066D2B),
      primaryVariant:  Color(0xFF066D2B),
      onSecondary: Color(0xFF066D2B),
      secondary: Color(0xFF066D2B),
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFFFFFFF),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFF050505)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    cardTheme: const CardTheme(
      color: Color(0xFFF3F3F3), //0xFFFAFAFC
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF066D2B),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFFFFFFFF),
        focusColor:const Color(0xFF066D2B),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF066D2B),
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
    bottomAppBarColor: const Color(0xFFE0E0E0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme:  IconThemeData(color: Color(0xFF066D2B),),
      selectedLabelStyle: TextStyle(color: Color(0xFF066D2B),),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFFE0E0E0),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFE0E0E0),
        indicatorColor: const Color(0xFF066D2B),
        iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Color(0xFF050505),)
        ),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFF050505), fontWeight: FontWeight.w500))),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFFFF)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF202022),
    scaffoldBackgroundColor: const Color(0xFF202022),
    canvasColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF66BF72),
      primaryVariant:  Color(0xFF66BF72),
      onSecondary: Color(0xFF66BF72),
      secondary: Color(0xFF66BF72),
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF202022),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFFCACACA)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    cardTheme: const CardTheme(
      color: Color(0xFF2A2A2C),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF303032),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFF353537),
        focusColor: const Color(0xFF66BF72),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
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
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Color(0xFF66BF72)),
      selectedLabelStyle: TextStyle(color: Color(0xFF66BF72)),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFF151517),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF80DA8A),//353537
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF151517),
        indicatorColor: const Color(0xFF66BF72),
        iconTheme: MaterialStateProperty.all(
            const IconThemeData(color: Color(0xFFCACACA),)
        ),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFFCACACA), fontWeight: FontWeight.w500))),
    bottomAppBarColor: const Color(0xFF151517),
    bottomSheetTheme:
    const BottomSheetThemeData(modalBackgroundColor: Color(0xFF202022)));

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