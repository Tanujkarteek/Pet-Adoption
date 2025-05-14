import 'dart:ui';

import 'package:flutter/material.dart';

final List<Color> colors = [
  Colors.deepPurpleAccent,
  Colors.deepOrangeAccent,
  Colors.blueAccent,
  Colors.pinkAccent,
  Colors.redAccent,
  Colors.purpleAccent,
  Colors.lightBlueAccent,
  Colors.orangeAccent,
  Colors.indigoAccent,
];

// Add extension for Color to fix potential issue with withValues
extension ColorExtension on Color {
  Color withValues({double? red, double? green, double? blue, double? alpha}) {
    return Color.fromRGBO(
      red != null ? (red * 255).round() : this.red,
      green != null ? (green * 255).round() : this.green,
      blue != null ? (blue * 255).round() : this.blue,
      alpha ?? this.alpha / 255,
    );
  }
}
