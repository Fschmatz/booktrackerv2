import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w400),
    ),
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFFFFF),
    canvasColor: Colors.black,
    colorScheme: ColorScheme.light(
      primary: Colors.green.shade700,
      onSecondary: Colors.green.shade700,
      secondary: Colors.green.shade700,
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0xFFFFFFFF),
      color: Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    cardTheme: const CardTheme(
      surfaceTintColor: Color(0xFFE9EBEA),
      color: Color(0xFFE9EBEA), //0xFFFAFAFC
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFFFFFFF),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green.shade700,
    ),
    inputDecorationTheme: InputDecorationTheme(
        focusColor: Colors.green.shade700,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.green.shade700,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8.0)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8.0))),
    bottomAppBarColor: const Color(0xFFE0E0E0),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(
        color: Colors.green.shade700,
      ),
      selectedLabelStyle: TextStyle(
        color: Colors.green.shade700,
      ),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: const Color(0xFFE2E4E3),
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFE2E4E3),
        indicatorColor: Colors.green.shade700,
        iconTheme: MaterialStateProperty.all(const IconThemeData(
          color: Color(0xFF050505),
        )),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFF050505), fontWeight: FontWeight.w500))),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFFFF)));

ThemeData dark = ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w400),
    ),
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF202022),
    scaffoldBackgroundColor: const Color(0xFF202022),
    canvasColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF66BF72),
      onSecondary: Color(0xFF66BF72),
      secondary: Color(0xFF66BF72),
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0xFF202022),
      color: Color(0xFF202022),
    ),
    cardTheme: const CardTheme(
      surfaceTintColor: Color(0xFF303032),
      color: Color(0xFF303032),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF303032),
    ),
    inputDecorationTheme: InputDecorationTheme(
        focusColor: const Color(0xFF66BF72),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF66BF72),
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(8.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(8.0))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Color(0xFF66BF72)),
      selectedLabelStyle: TextStyle(color: Color(0xFF66BF72)),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFF272729),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF80DA8A), //353537
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF272729),
        indicatorColor: const Color(0xFF3B7343),
        iconTheme: MaterialStateProperty.all(const IconThemeData(
          color: Color(0xffe3e3e2),
        )),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xffe3e3e2), fontWeight: FontWeight.w500))),
    bottomAppBarColor: const Color(0xFF272729),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFF272729)));
