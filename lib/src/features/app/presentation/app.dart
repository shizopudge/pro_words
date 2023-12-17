import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/features/app/di/dependencies.dart';
import 'package:pro_words/src/features/app/presentation/app_placeholder.dart';

/// {@template app}
/// Главный виджет приложения
/// {@endtemplate}
@immutable
class App extends StatelessWidget {
  /// {@macro app}
  const App({super.key});

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: MaterialApp.router(
          theme: context.theme,
          routerConfig: Dependencies.of(context).router.config(
                placeholder: (context) => const AppPlaceholder(),
              ),
        ),
      );
}
