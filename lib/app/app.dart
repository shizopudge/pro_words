import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_words/app/app_di.dart';
import 'package:pro_words/app/initialization.dart';
import 'package:pro_words/core/extensions/extensions.dart';
import 'package:pro_words/core/theme/src/theme_scope.dart';
import 'package:pro_words/core/ui_kit/app_kit/src/primary_loading_indicator.dart';

@immutable
class Main extends StatefulWidget {
  /// Первый виджет приложения
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  /// {@template app_initialization_future}
  /// Future инициализации приложения
  /// {@endtemplate}
  late final Future<AppCoreModules> _appInitializationFuture;

  @override
  void initState() {
    super.initState();
    _appInitializationFuture = AppInitialization.init();
  }

  @override
  void dispose() {
    AppInitialization.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _appInitializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _AppInitializationProgress();
          }

          final appCoreModules = snapshot.data;

          if (snapshot.hasError || appCoreModules == null) {
            return _AppInitializationError(
                error: snapshot.error, stackTrace: snapshot.stackTrace);
          }

          return _GlobalScopes(
            appCoreModules: appCoreModules,
            app: _App(appCoreModules: appCoreModules),
          );
        },
      );
}

@immutable
class _App extends ConsumerWidget {
  /// {@macro app_core_modules}
  final AppCoreModules appCoreModules;

  /// App
  const _App({
    required this.appCoreModules,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        theme: ThemeScope.getTheme(context, listen: true),
        routerConfig: ref.watch(AppDI.appRouter).config(
              placeholder: (context) => const _AppPlaceholder(),
            ),
      );
}

@immutable
class _AppPlaceholder extends StatelessWidget {
  /// Заполнитель приложения
  const _AppPlaceholder();

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

@immutable
class _AppInitializationProgress extends StatelessWidget {
  /// Widget that would be displayed while app initializing
  const _AppInitializationProgress();

  @override
  Widget build(BuildContext context) => const Material(
        child: Center(
          child: PrimaryLoadingIndicator(),
        ),
      );
}

@immutable
class _AppInitializationError extends StatelessWidget {
  /// Error
  final Object? error;

  /// StackTrace
  final StackTrace? stackTrace;

  /// Widget that would be displayed if app initialization was completed with
  /// error
  const _AppInitializationError({
    required this.error,
    required this.stackTrace,
  });

  @override
  Widget build(BuildContext context) => Material(
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'An error has occurred',
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headlineLarge?.copyWith(
                        color: context.colors.red,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Error: $error.',
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: context.colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'StackTrace: $stackTrace.',
                        textAlign: TextAlign.center,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: context.colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

@immutable
class _GlobalScopes extends StatelessWidget {
  /// Виджет с MaterialApp приложения
  final _App app;

  /// {@macro app_core_modules}
  final AppCoreModules appCoreModules;

  /// Глобальные области видимости приложения
  const _GlobalScopes({
    required this.app,
    required this.appCoreModules,
  });

  @override
  Widget build(BuildContext context) => ProviderScope(
        overrides: [
          AppDI.appCoreModulesProvider.overrideWithValue(appCoreModules),
        ],
        child: ThemeScope(
          child: app,
        ),
      );
}
