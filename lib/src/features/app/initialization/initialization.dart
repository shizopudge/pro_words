import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_words/src/core/app_connect/app_connect.dart';
import 'package:pro_words/src/core/bloc_observer/bloc_observer.dart';
import 'package:pro_words/src/core/key_local_storage/key_local_storage.dart';
import 'package:pro_words/src/core/logger/logger.dart';
import 'package:pro_words/src/core/router/router.dart';
import 'package:pro_words/src/core/theme/src/app_colors.dart';
import 'package:pro_words/src/core/theme/src/app_theme.dart';
import 'package:pro_words/src/features/app/di/dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ephemerally initializes the app and prepares it for use.
Future<Dependencies>? _$initializeApp;

/// Initializes the app and prepares it for use.
Future<Dependencies> $initializeApp({
  void Function(int progress, String message)? onProgress,
  FutureOr<void> Function(Dependencies dependencies)? onSuccess,
  void Function(Object error, StackTrace stackTrace)? onError,
}) =>
    _$initializeApp ??= Future<Dependencies>(() async {
      late final WidgetsBinding binding;
      final stopwatch = Stopwatch()..start();
      try {
        binding = WidgetsFlutterBinding.ensureInitialized()..deferFirstFrame();
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        await _catchExceptions();
        final dependencies =
            await $initializeDependencies(onProgress: onProgress)
                .timeout(const Duration(seconds: 90));
        await onSuccess?.call(dependencies);
        return dependencies;
      } on Object catch (error, stackTrace) {
        onError?.call(error, stackTrace);
        L.error(
          'Failed to initialize app',
          error: error,
          stackTrace: stackTrace,
        );
        rethrow;
      } finally {
        stopwatch.stop();
        binding.addPostFrameCallback((_) {
          // Closes splash screen, and show the app layout.
          binding.allowFirstFrame();
          //final context = binding.renderViewElement;
        });
        _$initializeApp = null;
      }
    });

/// Resets the app's state to its initial state.
@visibleForTesting
Future<void> $resetApp(Dependencies dependencies) async {}

/// Disposes the app and releases all resources.
@visibleForTesting
Future<void> $disposeApp(Dependencies dependencies) async {}

Future<void> _catchExceptions() async {
  try {
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      L.error(
        'ROOT ERROR\r\n${Error.safeToString(error)}',
        error: error,
        stackTrace: stackTrace,
      );
      // FirebaseCrashlytics.instance.recordError(
      //   error,
      //   stack,
      //   fatal: true,
      // );
      return true;
    };

    final sourceFlutterError = FlutterError.onError;
    FlutterError.onError = (final details) {
      L.error(
        'FLUTTER ERROR\r\n$details',
        error: details.exception,
        stackTrace: details.stack,
      );
      // FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // FlutterError.presentError(details);
      sourceFlutterError?.call(details);
    };
  } on Object catch (error, stackTrace) {
    L.error(
      'Error occurred during error catchers initialization',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Initializes the app and returns a [Dependencies] object
Future<Dependencies> $initializeDependencies({
  void Function(int progress, String message)? onProgress,
}) async {
  final dependencies = $MutableDependencies();
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  for (final step in _initializationSteps.entries) {
    currentStep++;
    final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
    onProgress?.call(percent, step.key);
    L.log(
        'Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
    await step.value(dependencies);
  }
  return dependencies.freeze();
}

typedef _InitializationStep = FutureOr<void> Function(
    $MutableDependencies dependencies);

final Map<String, _InitializationStep> _initializationSteps =
    <String, _InitializationStep>{
  'Initializing KeyLocalStorage': (dependencies) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      dependencies.keyLocalStorage =
          KeyLocalStorage(sharedPreferences: sharedPreferences);
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during KeyLocalStorage initialization',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  },
  'Initializing AppRouter': (dependencies) =>
      dependencies.appRouter = AppRouter(),
  'Initializing AppTheme': (dependencies) =>
      dependencies.appTheme = AppTheme(appColors: AppColors()),
  'Initializing BLoC observer': (dependencies) =>
      Bloc.observer = const AppBlocObserver(),
  'Initializing AppConnect': (dependencies) =>
      dependencies.appConnect = AppConnect(),
  'App initialized': (_) => L.log('App successfully initialized'),
};
