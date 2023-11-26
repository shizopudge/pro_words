import 'package:flutter/widgets.dart';

extension WidgetNullableX on Widget? {
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

extension WidgetX on Widget {
  /// Extension for adding padding to widget
  Widget addPadding(EdgeInsets padding) => Padding(
        padding: padding,
        child: this,
      );
}
