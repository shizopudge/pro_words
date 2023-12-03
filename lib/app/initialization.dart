import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_words/app/bloc_observer.dart';
import 'package:pro_words/core/key_local_storage/src/key_local_storage.dart';
import 'package:pro_words/core/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template app_initialization}
/// Инициализация приложения
/// {@endtemplate}
@immutable
class AppInitialization {
  /// {@macro app_initialization}
  const AppInitialization._();

  /// Инициализирует приложение
  static Future<AppCoreModules> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _initLogger();
    await _initFirebase();
    _initCrashlytics();
    Bloc.observer = const AppBlocObserver();
    final keyLocalStorage = await _initKeyLocalStorage();
    return AppCoreModules(keyLocalStorage: keyLocalStorage);
  }

  /// Инициализирует логгер
  static void _initLogger() => L.init();

  /// Инициализирует KeyLocalStorage
  static Future<KeyLocalStorage> _initKeyLocalStorage() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final keyLocalStorage =
          KeyLocalStorage(sharedPreferences: sharedPreferences);
      return keyLocalStorage;
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during KeyLocalStorage initialization',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Инициализирует Firebase
  static Future<void> _initFirebase() async {
    // await Firebase.initializeApp();
  }

  /// Инициализирует Crashlytics
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

  /// Метод вызывающийся при удалении из дерева навсегда
  static Future<void> dispose() async {
    await L.dispose();
  }
}

/// {@template initialization_step}
/// Модель шага инициализации
/// {@endtemplate}
@immutable
class InitializationStep extends Equatable {
  /// Progress from 1 % to 100 %
  final int progress;

  /// Step name - string value for initialization step
  final String stepName;

  /// {@macro initialization_step}
  const InitializationStep({
    required this.progress,
    required this.stepName,
  });

  @override
  List<Object?> get props => [progress, stepName];
}

/// {@template app_core_modules}
/// Основные модули приложения
/// {@endtemplate}
@immutable
class AppCoreModules {
  /// {@macro key_local_storage}
  final IKeyLocalStorage keyLocalStorage;

  /// {@macro app_core_modules}
  const AppCoreModules({
    required this.keyLocalStorage,
  });
}
