import 'package:flutter/material.dart';

/// {@template app_theme}
/// Тема приложения
/// {@endtemplate}
@immutable
class AppTheme {
  /// {@macro app_theme}
  const AppTheme._();

  /// Экземпляр класса темы пиложения
  static AppTheme get instance => const AppTheme._();

  /// Dark theme key
  static const String darkThemeKey = 'dark';

  /// Light theme key
  static const String lightThemeKey = 'light';

  /// Dark theme
  static final darkTheme = ThemeData.dark();

  /// Light theme
  static final lightTheme = ThemeData.light();
}
