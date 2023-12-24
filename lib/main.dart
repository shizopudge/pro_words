import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_words/src/core/logger/logger.dart';
import 'package:pro_words/src/core/theme/src/theme_scope.dart';
import 'package:pro_words/src/features/app/di/dependencies_scope.dart';
import 'package:pro_words/src/features/app/initialization/initialization.dart';
import 'package:pro_words/src/features/app/presentation/app.dart';
import 'package:pro_words/src/features/app/presentation/app_initialization_error_page.dart';
import 'package:pro_words/src/features/app/presentation/app_initialization_splash_page.dart';
import 'package:pro_words/src/features/app_connect/presentation/app_connect_listener.dart';
import 'package:pro_words/src/features/toaster/logic/toaster_scope.dart';

/// Главная функция запускающая приложение
void main() => runZonedGuarded<void>(
      () async {
        /// {@macro initialization_progress_controller}
        final initializationProgressController =
            ValueNotifier<({int progress, String message})>(
                (progress: 0, message: 'Start of initialization'));
        // Splash screen
        runApp(
          AppInitializationSplashPage(
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
                child: ToasterScope(
                  child: AppConnectListener(
                    child: App(),
                  ),
                ),
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
