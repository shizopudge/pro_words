import 'package:flutter/material.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

/// {@template primary_loading_indicator}
/// Виджет отображающий загрузку
/// {@endtemplate}
@immutable
class ProgressLayout extends StatelessWidget {
  /// {@macro primary_loading_indicator}
  const ProgressLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Center(
        child: PrimaryLoadingIndicator(),
      );
}
