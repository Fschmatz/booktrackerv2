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
      onPrimary: Color(0xFF102000),
      onSecondary: Colors.green.shade700,
      secondary: Colors.green.shade700,
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFB2B2B2)),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFF454546)),
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
      surfaceTintColor: Color(0xFFFFFFFF),
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
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
        )),
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
      surfaceTintColor: const Color(0xFFE2E4E3),
        backgroundColor: const Color(0xFFE2E4E3),
        indicatorColor: Colors.green.shade700,
        iconTheme: MaterialStateProperty.all(const IconThemeData(
          color: Color(0xFF050505),
        )),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xFF050505), fontWeight: FontWeight.w500))),
    bottomSheetTheme:
        const BottomSheetThemeData(
          surfaceTintColor:  const Color(0xFFE2E4E3),
            modalBackgroundColor: Color(0xFFFFFFFF)));

ThemeData dark = ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w400),
    ),
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1B1B1D),
    scaffoldBackgroundColor: const Color(0xFF1B1B1D),
    canvasColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF66BF72),
      onPrimary: Color(0xFF102000),
      onSecondary: Color(0xFF66BF72),
      secondary: Color(0xFF66BF72),
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0xFF1B1B1D),
      color: Color(0xFF1B1B1D),
    ),
    listTileTheme: const ListTileThemeData(iconColor: Color(0xFFE2E2E9)),
    cardTheme: const CardTheme(
      surfaceTintColor: Color(0xFF303032),
      color: Color(0xFF303032),
    ),
    dialogTheme: const DialogTheme(
      surfaceTintColor: Color(0xFF303032),
      backgroundColor: Color(0xFF303032),
    ),
    inputDecorationTheme: InputDecorationTheme(
        focusColor: const Color(0xFF66BF72),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFF66BF72),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[800]!,
          ),
        )),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Color(0xFF66BF72)),
      selectedLabelStyle: TextStyle(color: Color(0xFF66BF72)),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFF272927),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF80DA8A), //353537
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF424342)),
    navigationBarTheme: NavigationBarThemeData(
        surfaceTintColor: const Color(0xFF272927),
        backgroundColor: const Color(0xFF272927),
        indicatorColor: const Color(0xFF407247),
        iconTheme: MaterialStateProperty.all(const IconThemeData(
          color: Color(0xffe3e3e2),
        )),
        labelTextStyle: MaterialStateProperty.all(const TextStyle(
            color: Color(0xffe3e3e2), fontWeight: FontWeight.w500))),
    bottomSheetTheme:
        const BottomSheetThemeData(
          surfaceTintColor: const Color(0xFF272927),
            modalBackgroundColor: Color(0xFF272927))
);
