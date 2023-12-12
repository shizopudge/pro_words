import 'package:flutter/material.dart';
import 'package:pro_words/src/core/theme/theme.dart';
import 'package:pro_words/src/core/ui_kit/app_kit/app_kit.dart';

@immutable
class AppInitializationSplashPage extends StatefulWidget {
  /// {@template initialization_progress_controller}
  /// Контроллер инициализации
  /// {@endtemplate}
  final ValueNotifier<({int progress, String message})>
      initializationProgressController;

  /// Экран отображающийся во время инициализации приложения
  const AppInitializationSplashPage({
    required this.initializationProgressController,
    super.key,
  });

  @override
  State<AppInitializationSplashPage> createState() =>
      _AppInitializationSplashPageState();
}

class _AppInitializationSplashPageState
    extends State<AppInitializationSplashPage> {
  /// {@macro app_colors}
  late final IAppColors colors;

  /// {@macro app_theme}
  late final IAppTheme appTheme;

  @override
  void initState() {
    super.initState();
    colors = AppColors();
    appTheme = AppTheme(appColors: colors);
  }

  @override
  void dispose() {
    widget.initializationProgressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: MaterialApp(
          theme: appTheme.lightTheme,
          home: Scaffold(
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PrimaryLoadingIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 40,
                        right: 40,
                      ),
                      child: AnimatedBuilder(
                        animation: widget.initializationProgressController,
                        builder: (context, _) => RichText(
                          text: TextSpan(
                            text: '$_progress / 100 %\n',
                            style: appTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(color: colors.grey),
                            children: [
                              TextSpan(
                                text: _message,
                                style: appTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(color: colors.grey, height: 2),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
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

  /// Возвращает сообщение прогресса инициализации
  String get _message => widget.initializationProgressController.value.message;

  /// Возвращает прогресс инициализации
  int get _progress => widget.initializationProgressController.value.progress;
}
