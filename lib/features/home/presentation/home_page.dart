import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pro_words/core/theme/theme.dart';

@immutable
@RoutePage<void>()
class HomePage extends StatelessWidget {
  /// Домашний экран
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade200,
              foregroundColor: Colors.deepOrange.shade900,
            ),
            onPressed: ThemeScope.of(context).toggleTheme,
            child: const Text('Toggle Theme'),
          ),
        ),
      );
}
