import 'package:flutter/material.dart';
import 'package:pro_words/src/core/theme/theme.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';
import 'package:pro_words/src/features/app/di/dependencies.dart';

@immutable
class App extends StatelessWidget {
  /// Главный виджет приложения
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: MaterialApp.router(
          theme: ThemeScope.getTheme(context),
          routerConfig: Dependencies.of(context).appRouter.config(
                placeholder: (context) => const AppPlaceholder(),
              ),
        ),
      );
}
