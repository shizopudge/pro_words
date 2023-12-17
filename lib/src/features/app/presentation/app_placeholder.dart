import 'package:flutter/material.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

/// {@template app_placeholder}
/// Заполнитель приложения
/// {@endtemplate}
@immutable
class AppPlaceholder extends StatelessWidget {
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
