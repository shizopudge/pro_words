import 'package:flutter/material.dart';

/// {@template app_colors}
/// Цвета приложения
/// {@endtemplate}
@immutable
class AppColors {
  /// {@macro app_colors}
  const AppColors._();

  /// Экземпляр класса цветов пиложения
  static AppColors get instance => const AppColors._();

  /// White
  Color get white => Colors.white;

  /// Black
  Color get black => Colors.black;

  /// Red
  Color get red => Colors.red;

  /// Purple
  Color get purple => Colors.purple.shade300;

  /// Grey
  Color get grey => Colors.grey.shade400;
}
