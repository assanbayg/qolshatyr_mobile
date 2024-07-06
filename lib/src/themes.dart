// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme(),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF81D1C6)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF81D1C6),
    brightness: Brightness.dark,
  ),
);
