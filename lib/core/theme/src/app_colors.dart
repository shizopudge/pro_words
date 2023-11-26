import 'package:flutter/material.dart';

/// {@template app_colors}
/// App colors
/// {@endtemplate}
@immutable
class AppColors {
  /// {@macro app_colors}
  const AppColors();

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
