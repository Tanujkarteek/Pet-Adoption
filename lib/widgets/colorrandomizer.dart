import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/data.dart';

List<Color> ColorRandomizer (List<DataModel> foundList) {
  List<Color> selectedColor =[];
  for(int i = 0; i < foundList.length; i++) {
    int randomIndex = Random().nextInt(colors.length);
    Color randomColor = colors[randomIndex];
    selectedColor.add(randomColor);
  }
  return selectedColor;
}

List<Color> ColorRandomizerInt (int foundList) {
  List<Color> selectedColor =[];
  for(int i = 0; i < foundList; i++) {
    int randomIndex = Random().nextInt(colors.length);
    Color randomColor = colors[randomIndex];
    selectedColor.add(randomColor);
  }
  return selectedColor;
}