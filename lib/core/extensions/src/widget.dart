import 'package:flutter/widgets.dart';

extension WidgetX on Widget? {
  /// Simple extension for nullable widgets
  ///
  /// if widget == null returns [SizedBox.shrink] otherwise
  /// returns that widget
  Widget get widgetOrNull {
    final widget = this;

    if (widget == null) {
      return const SizedBox.shrink();
    }

    return widget;
  }
}
