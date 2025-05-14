import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  canvasColor: Colors.grey[400],
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.black87,
    // surface: Colors.black,
    surface: Color(0xffF7F7F7),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black.withValues(alpha: 0.5),
    // onSurface: Colors.white38,
  ),
);
