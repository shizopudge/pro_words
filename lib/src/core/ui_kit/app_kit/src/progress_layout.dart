import 'package:flutter/material.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

@immutable
class ProgressLayout extends StatelessWidget {
  /// Виджет отображающий загрузку
  const ProgressLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Center(
        child: PrimaryLoadingIndicator(),
      );
}
