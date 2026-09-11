import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final primaryColor = Color(0xFFCCCCCC);
final secondaryColor = Color(0xFF5A80B7);
final appTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: GoogleFonts.cairoTextTheme(),
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: Colors.orange, // لون ثانوي
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: primaryColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primaryColor,
      textStyle: GoogleFonts.cairo(fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    hintStyle: GoogleFonts.cairo(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Color(0xFF848484),
    ),
    labelStyle: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[700]),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor, width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1),
      borderRadius: BorderRadius.circular(12),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);
