import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_words/app/bloc_observer.dart';
import 'package:pro_words/core/key_local_storage/src/key_local_storage.dart';
import 'package:pro_words/core/logger/logger.dart';

/// {@template app_initialization}
/// App initialization
/// {@endtemplate}
@immutable
class AppInitialization {
  /// {@macro app_initialization}
  const AppInitialization._();

  /// App initialization method
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _initLogger();
    await _initSharedPreferences();
    await _initFirebase();
    _initCrashlytics();
    Bloc.observer = const AppBlocObserver();
  }

  /// Logger initialization
  static void _initLogger() => L.init();

  /// Shared preferences initialization
  static Future<void> _initSharedPreferences() async =>
      await KeyLocalStorage.init();

  /// Firebase initialization
  static Future<void> _initFirebase() async {
    // await Firebase.initializeApp();
  }

  /// Crashlytics initialization
  static void _initCrashlytics() {
    FlutterError.onError = (errorDetails) {
      L.log('Caught error in FlutterError.onError');
      // FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      L.log('Caught error in PlatformDispatcher.onError');
      // FirebaseCrashlytics.instance.recordError(
      //   error,
      //   stack,
      //   fatal: true,
      // );
      return true;
    };
  }

  /// Dispose initialization  method
  static Future<void> dispose() async {
    await L.dispose();
  }
}

class InitializationStep extends Equatable {
  /// Progress from 1% to 100%
  final int progress;

  /// Step name - string value for initialization step
  final String stepName;

  /// Model for app initialization step
  const InitializationStep({
    required this.progress,
    required this.stepName,
  });

  @override
  List<Object?> get props => [progress, stepName];
}
