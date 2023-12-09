import 'package:flutter/material.dart';

@immutable
abstract interface class IAppColors {
  /// White
  Color get white;

  /// Black
  Color get black;

  /// Red
  Color get red;

  /// Purple
  Color get purple;

  /// Grey
  Color get grey;
}

/// {@template app_colors}
/// Цвета приложения
/// {@endtemplate}
@immutable
class AppColors implements IAppColors {
  /// {@macro app_colors}
  const AppColors._();

  /// Вовзращает экземпляр класса [IAppColors]
  static IAppColors get instance => const AppColors._();

  @override
  Color get white => Colors.white;

  @override
  Color get black => Colors.black;

  @override
  Color get red => Colors.red;

  @override
  Color get purple => Colors.purple.shade300;

  @override
  Color get grey => Colors.grey.shade400;
}
