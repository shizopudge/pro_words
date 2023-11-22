import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pro_words/app/bloc_observer.dart';
import 'package:pro_words/app/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitialization {
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
  static void _initLogger() => Locator.logger = Logger();

  /// Shared preferences initialization
  static Future<void> _initSharedPreferences() async {
    try {
      Locator.sharedPreferences = await SharedPreferences.getInstance();
    } on Object catch (error, stackTrace) {
      Locator.logger.e(
        'Something went wrong while SharedPreferences was initializing',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Firebase initialization
  static Future<void> _initFirebase() async {
    await Firebase.initializeApp();
  }

  /// Crashlytics initialization
  static void _initCrashlytics() {
    FlutterError.onError = (errorDetails) {
      Locator.logger.d('Caught error in FlutterError.onError');
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      Locator.logger.d('Caught error in PlatformDispatcher.onError');
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
      );
      return true;
    };
  }

  /// Dispose initialization  method
  static void dispose() {}
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
