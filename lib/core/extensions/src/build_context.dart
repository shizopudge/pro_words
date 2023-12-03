import 'package:flutter/material.dart';
import 'package:pro_words/core/theme/theme.dart';

extension BuildContextX on BuildContext {
  /// Tема
  ThemeData get theme => Theme.of(this);

  /// Media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// {@macro app_colors}
  AppColors get colors => AppColors.instance;
}
