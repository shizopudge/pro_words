import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_words/app/initialization.dart';
import 'package:pro_words/core/extensions/extensions.dart';
import 'package:pro_words/core/theme/src/theme_scope.dart';
import 'package:pro_words/core/ui_kit/app_kit/src/primary_loading_indicator.dart';

@immutable
class Main extends StatefulWidget {
  /// Main app widget
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  /// {@template app_initialization_future}
  /// Future of app initializtion
  /// {@endtemplate}
  late final Future<void> _appInitializationFuture;

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
          if (snapshot.hasError) {
            return _AppInitializationError(
                error: snapshot.error, stackTrace: snapshot.stackTrace);
          }

          if (snapshot.connectionState != ConnectionState.done &&
              snapshot.hasData) {
            return const _AppInitializationProgress();
          }

          return const ProviderScope(
            child: ThemeScope(
              child: _App(),
            ),
          );
        },
      );
}

@immutable
class _App extends StatelessWidget {
  /// App
  const _App();

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeScope.getTheme(context),
        home: Scaffold(
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
