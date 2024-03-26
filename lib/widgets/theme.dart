import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData light() {
    return ThemeData(
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFFFBFBFB),
      primaryColor: const Color(0xFF015785),
      // useMaterial3: true,
      // colorScheme: ColorScheme(
      //     brightness: Brightness.dark,
      //     primary: primary,
      //     onPrimary: onPrimary,
      //     secondary: secondary,
      //     onSecondary: onSecondary,
      //     error: error,
      //     onError: onError,
      //     background: background,
      //     onBackground: onBackground,
      //     surface: surface,
      //     onSurface: onSurface),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF015785),
      ),
    );
  }

  static TextStyle textStyle(
      {double? fontSize, FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
