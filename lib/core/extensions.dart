import 'package:flutter/material.dart';
import 'package:pro_words/app/theme.dart';

extension BuildContextX on BuildContext {
  /// Theme scope data
  ThemeScopeData get themeScope => ThemeScope.of(this);

  /// Media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
