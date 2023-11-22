import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  /// Theme data
  ThemeData get theme => Theme.of(this);

  /// Media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);
}
