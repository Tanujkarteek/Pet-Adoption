import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeEvent>((event, emit) {
      // Default handler
    });

    on<ThemeInitialized>((event, emit) async {
      final myBox = Hive.box('settings');
      final savedThemeMode = myBox.get('themeMode');

      ThemeMode themeMode = ThemeMode.system;
      if (savedThemeMode != null) {
        if (savedThemeMode == 'light') {
          themeMode = ThemeMode.light;
        } else if (savedThemeMode == 'dark') {
          themeMode = ThemeMode.dark;
        }
      }

      emit(ThemeState(themeMode: themeMode));
    });

    on<ThemeChanged>((event, emit) async {
      final myBox = Hive.box('settings');

      ThemeMode newThemeMode;
      if (event.themeMode != null) {
        newThemeMode = event.themeMode!;
      } else {
        // Toggle between light and dark
        if (state.themeMode == ThemeMode.light) {
          newThemeMode = ThemeMode.dark;
        } else {
          newThemeMode = ThemeMode.light;
        }
      }

      // Save to Hive
      myBox.put(
          'themeMode', newThemeMode == ThemeMode.light ? 'light' : 'dark');

      emit(ThemeState(themeMode: newThemeMode));
    });
  }
}
