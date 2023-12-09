import 'package:flutter/material.dart';
import 'package:pro_words/src/core/theme/src/app_colors.dart';
import 'package:pro_words/src/core/ui_kit/app_kit/app_kit.dart';

@immutable
class AppInitializationSplashScreen extends StatefulWidget {
  /// {@macro initialization_progress_controller}
  /// Контроллер инициализации
  /// {@endtemplate}
  final ValueNotifier<({int progress, String message})>
      initializationProgressController;

  /// Экран отображающийся во время инициализации приложения
  const AppInitializationSplashScreen({
    required this.initializationProgressController,
    super.key,
  });

  @override
  State<AppInitializationSplashScreen> createState() =>
      _AppInitializationSplashScreenState();
}

class _AppInitializationSplashScreenState
    extends State<AppInitializationSplashScreen> {
  /// {@macro app_colors}
  late final IAppColors colors;

  @override
  void initState() {
    super.initState();
    colors = AppColors.instance;
  }

  @override
  void dispose() {
    widget.initializationProgressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
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
                          style: TextStyle(
                            color: colors.grey,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            height: 1.55,
                          ),
                          children: [
                            TextSpan(
                              text: _message,
                              style: TextStyle(
                                color: colors.grey,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                height: 1.75,
                              ),
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
      );

  /// Возвращает сообщение прогресса инициализации
  String get _message => widget.initializationProgressController.value.message;

  /// Возвращает прогресс инициализации
  int get _progress => widget.initializationProgressController.value.progress;
}
