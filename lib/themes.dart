// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xFF81D1C6);
const darkPrimaryColor = Color.fromARGB(255, 60, 164, 155);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: GoogleFonts.ralewayTextTheme(),
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  textTheme: GoogleFonts.ralewayTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
  ),
);
