import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  brightness: Brightness.dark,
  canvasColor: Colors.grey[400],
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.white38,
    surface: Colors.deepPurpleAccent,
    background: Color(0xff0E0E0E),
    onPrimary: Colors.black54,
    onSecondary: Colors.black26,
    onSurface: Colors.white.withOpacity(0.5),
    onBackground: Colors.black12,
  ),
);