import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_words/src/app/di/dependencies_scope.dart';
import 'package:pro_words/src/app/initialization/initialization.dart';
import 'package:pro_words/src/app/presentation/app.dart';
import 'package:pro_words/src/app/presentation/app_initialization_error_page.dart';
import 'package:pro_words/src/app/presentation/app_initialization_splash_page.dart';
import 'package:pro_words/src/core/logger/logger.dart';
import 'package:pro_words/src/core/theme/theme.dart';

/// Главная функция запускающая приложение
void main() => runZonedGuarded<void>(
      () async {
        final initializationProgressController =
            ValueNotifier<({int progress, String message})>(
                (progress: 0, message: 'Start of initialization'));
        // Splash screen
        runApp(
          AppInitializationSplashScreen(
            initializationProgressController: initializationProgressController,
          ),
        );
        $initializeApp(
          onProgress: (progress, message) => initializationProgressController
              .value = (progress: progress, message: message),
          onSuccess: (dependencies) => runApp(
            DependenciesScope(
              dependencies: dependencies,
              child: const ThemeScope(
                child: App(),
              ),
            ),
          ),
          onError: (error, stackTrace) {
            runApp(const AppInitializationErrorPage());
            L.error('Error occurred during app initialization',
                error: error, stackTrace: stackTrace);
          },
        ).ignore();
      },
      (error, stackTrace) => L.error(
        'Error caught in MAIN guarded zone',
        error: error,
        stackTrace: stackTrace,
      ),
    );
