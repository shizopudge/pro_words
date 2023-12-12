import 'package:flutter/material.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

@immutable
class AppPlaceholder extends StatelessWidget {
  /// Заполнитель приложения
  const AppPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Center(
            child: PrimaryLoadingIndicator(),
          ),
        ),
      );
}
