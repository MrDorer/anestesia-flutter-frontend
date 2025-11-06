import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  // Use Google Fonts 'Overlock' as the app text theme. If you prefer another
  // font, replace `overlockTextTheme` with the desired helper (e.g. winkyRoughTextTheme).
  // Apply Overlock text theme from google_fonts. Avoid calling .apply()
  // with a global fontSizeFactor because some TextStyles may have null
  // fontSize and TextTheme.apply asserts that fontSize must be present when
  // scaling. If you want to scale sizes globally, we should set explicit
  // sizes per TextStyle instead.
  textTheme: GoogleFonts.overlockTextTheme(ThemeData.light().textTheme),
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Color.fromRGBO(89, 12, 70, 1),
    secondary: Color(0xFFB11C8C),
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
);
