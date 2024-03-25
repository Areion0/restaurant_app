import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeModel {
  static const darkBlue = Color(0xFF2B2D42);
  static const darkGrey = Color(0xFF8D99AE);
  static const lightGrey = Color(0xFFD2DBDF);
  static const darkRed = Color(0xFFBB2222);
  static const lightRed = Color(0xFFEF233C);

  static ThemeData get theme => ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkRed,
            foregroundColor: lightGrey,
            textStyle: titleLargeTextStyle,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: titleLargeTextStyle,
          titleMedium: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
          bodyMedium: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        iconTheme: const IconThemeData(size: 34),
        colorScheme: const ColorScheme(
          primary: darkBlue,
          secondary: darkGrey,
          tertiary: lightGrey,
          surface: lightGrey,
          background: lightGrey,
          error: lightRed,
          onPrimary: lightGrey,
          onSecondary: lightGrey,
          onSurface: darkBlue,
          onBackground: darkBlue,
          onError: darkBlue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      );

  static TextStyle titleLargeTextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: darkBlue,
  );
}
