import 'package:flutter/widgets.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';

extension EdgeInsetsX on EdgeInsets {
  /// Возвращет [EdgeInsets] с context.mediaQuery.padding.bottom
  EdgeInsets withBottomPadding(BuildContext context) =>
      this + EdgeInsets.only(bottom: context.mediaQuery.padding.bottom);

  /// Возвращет [EdgeInsets] с context.mediaQuery.viewInsets.bottom
  EdgeInsets withBottomViewInsets(BuildContext context) =>
      this + EdgeInsets.only(bottom: context.mediaQuery.viewInsets.bottom);

  /// Возвращет [EdgeInsets] с context.mediaQuery.viewPadding.bottom
  EdgeInsets withBottomViewPadding(BuildContext context) =>
      this + EdgeInsets.only(bottom: context.mediaQuery.viewPadding.bottom);
}
