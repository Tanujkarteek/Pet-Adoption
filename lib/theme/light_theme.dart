import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  brightness: Brightness.light,
  canvasColor: Colors.grey[400],
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey,
    surface: Colors.black,
    background: Color(0xffF7F7F7),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black.withOpacity(0.5),
    onBackground: Colors.white38
  ),
);