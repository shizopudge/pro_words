import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_words/app/initialization.dart';
import 'package:pro_words/app/theme.dart';
import 'package:pro_words/core/extensions.dart';

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
  Widget build(BuildContext context) => ProviderScope(
        child: ThemeScope(
          child: _App(appInitializationFuture: _appInitializationFuture),
        ),
      );
}

@immutable
class _App extends StatefulWidget {
  /// {@macro app_initialization_future}
  final Future<void> appInitializationFuture;

  /// App widget
  const _App({
    required this.appInitializationFuture,
  });

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: widget.appInitializationFuture,
        builder: (context, snapshot) {
          final isAppInitialized =
              snapshot.connectionState == ConnectionState.done;

          final child = isAppInitialized
              ? const _MaterialApp()
              : const _AppInitializationProgress();

          return child;
        },
      );
}

@immutable
class _MaterialApp extends StatelessWidget {
  /// Material app
  const _MaterialApp();

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: context.themeScope.controller,
        builder: (context, child) => MaterialApp(
          theme: context.themeScope.theme,
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
        ),
      );
}

@immutable
class _AppInitializationProgress extends StatelessWidget {
  /// Widget that would bne displayed while app initializing
  const _AppInitializationProgress();

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
