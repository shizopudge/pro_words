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

  /// Глобальный ключ навигатора приложения
  static final _navigatorKey = GlobalKey<NavigatorState>();

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

  /// Возвращает ключ навигатора приложения
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
}
