import 'package:flutter/material.dart';
import 'package:pro_words/core/theme/theme.dart';

extension BuildContextX on BuildContext {
  /// Theme data
  ThemeData get theme => Theme.of(this);

  /// Media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// App colors
  AppColors get colors => const AppColors();
}
