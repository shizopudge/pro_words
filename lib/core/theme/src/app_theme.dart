import 'package:flutter/material.dart';

@immutable
class AppTheme {
  /// Dark theme key
  static const String darkThemeKey = 'dark';

  /// Light theme key
  static const String lightThemeKey = 'light';

  /// Dark theme
  static final darkTheme = ThemeData.dark();

  /// Light theme
  static final lightTheme = ThemeData.light();
}
