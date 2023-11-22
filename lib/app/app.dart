import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_words/app/initialization.dart';
import 'package:pro_words/app/theme.dart';

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
        child: FutureBuilder(
          future: _appInitializationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const _AppInitializationProgress();
            }

            return const ThemeProvider(
              child: _App(),
            );
          },
        ),
      );
}

@immutable
class _App extends StatelessWidget {
  /// Material app
  const _App();

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: ThemeScope.of(context, watch: false).controller,
        builder: (context, _) => MaterialApp(
          theme: ThemeScope.of(context).theme,
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
