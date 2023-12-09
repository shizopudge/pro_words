import 'package:flutter/material.dart';
import 'package:pro_words/src/app/di/dependencies.dart';
import 'package:pro_words/src/core/theme/theme.dart';

extension BuildContextX on BuildContext {
  /// Media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// {@macro dependencies}
  Dependencies get dependencies => Dependencies.of(this);

  /// {@macro app_colors}
  IAppColors get colors => Dependencies.of(this).appTheme.colors;

  /// {@macro app_theme}
  IAppTheme get appTheme => Dependencies.of(this).appTheme;

  /// Слушает текущую тему
  ThemeData get theme => ThemeScope.getTheme(this);

  /// Возвращает текущую тему
  ThemeData get themeRead => ThemeScope.getTheme(this, listen: false);
}
