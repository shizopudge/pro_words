import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';

@immutable
class AppPlaceholder extends StatelessWidget {
  /// Заполнитель приложения
  const AppPlaceholder({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(
            'Placeholder',
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headlineLarge?.copyWith(
              color: context.colors.black,
            ),
          ),
        ),
      );
}
