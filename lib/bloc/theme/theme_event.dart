part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ThemeInitialized extends ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final ThemeMode? themeMode;

  ThemeChanged({this.themeMode});
}
