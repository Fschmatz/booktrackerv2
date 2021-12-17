import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFFFFF),
    canvasColor: Colors.black,
    colorScheme: ColorScheme.light(
      primary: Colors.green.shade700,
      primaryVariant:  Colors.green.shade700,
      onSecondary: Colors.green.shade700,
      secondary: Colors.green.shade700,
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
      color: Color(0xFFE9E9E9), //0xFFFAFAFC
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green.shade700,
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: const Color(0xFFFFFFFF),
        focusColor:  Colors.green.shade700,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green.shade700,
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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme:  IconThemeData(color: Colors.green.shade700,),
      selectedLabelStyle: TextStyle(color: Colors.green.shade700,),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: const Color(0xFFDADCDB),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFDADCDB),
        indicatorColor: Colors.green.shade700,
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
      color: Color(0xFF303032),
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