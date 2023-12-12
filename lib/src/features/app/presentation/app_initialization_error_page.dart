import 'package:flutter/material.dart';
import 'package:pro_words/src/core/resources/resources.dart';
import 'package:pro_words/src/core/theme/theme.dart';
import 'package:pro_words/src/core/ui_kit/app_kit/app_kit.dart';
import 'package:pro_words/src/core/ui_kit/utils_kit/src/animated_fade_slide_transition.dart';

@immutable
class AppInitializationErrorPage extends StatefulWidget {
  /// Экран отображающий ошибку инициализации приложения
  const AppInitializationErrorPage({
    super.key,
  });

  @override
  State<AppInitializationErrorPage> createState() =>
      _AppInitializationErrorPageState();
}

class _AppInitializationErrorPageState
    extends State<AppInitializationErrorPage> {
  /// {@template error_icon_appearance_controller}
  /// Контроллер появления иконки ошибки
  /// {@endtemplate}
  late final ValueNotifier<bool> _errorIconAppearanceController;

  /// {@macro app_colors}
  late final IAppColors colors;

  /// {@macro app_theme}
  late final IAppTheme appTheme;

  @override
  void initState() {
    super.initState();
    _errorIconAppearanceController = ValueNotifier<bool>(false);
    colors = AppColors();
    appTheme = AppTheme(appColors: colors);
  }

  @override
  void dispose() {
    _errorIconAppearanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: MaterialApp(
          theme: appTheme.lightTheme,
          home: Scaffold(
            body: SafeArea(
              bottom: false,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryAnimatedIcon(
                      name: Assets.animations.error,
                      size: 150,
                      listener: _animationListener,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 40,
                        right: 40,
                      ),
                      child: AnimatedBuilder(
                        animation: _errorIconAppearanceController,
                        builder: (context, _) => AnimatedFadeSlideTransition(
                          isVisible: _isErrorIconAppeared,
                          duration: const Duration(milliseconds: 550),
                          child: Text(
                            'Oops, looks like we were unable to initialize the application...'
                            '\nTry restarting the application.',
                            textAlign: TextAlign.center,
                            style: appTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(color: colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _BottomButton(
              onTap: _reinitializeApp,
              errorIconAppearanceController: _errorIconAppearanceController,
            ),
          ),
        ),
      );

  /// Слушатель анимации
  void _animationListener(AnimationController controller) {
    if (_errorIconAppearanceController.value) return;

    _errorIconAppearanceController.value = controller.value >= 0.4;
  }

  /// Вовзращает true, если иконка ошибки появилась
  bool get _isErrorIconAppeared => _errorIconAppearanceController.value;

  /// Перезагружает приложение
  Future<void> _reinitializeApp() => Future<void>.value();
}

@immutable
class _BottomButton extends AnimatedWidget {
  /// Обработчик нажатия
  final VoidCallback onTap;

  /// {@macro error_icon_appearance_controller}
  final ValueNotifier<bool> errorIconAppearanceController;

  /// Нижняя кнопка
  const _BottomButton({
    required this.onTap,
    required this.errorIconAppearanceController,
  }) : super(listenable: errorIconAppearanceController);

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        left: false,
        right: false,
        child: AnimatedFadeSlideTransition(
          isVisible: errorIconAppearanceController.value,
          duration: const Duration(milliseconds: 650),
          child: PrimaryElevatedButton(
            onTap: onTap,
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Перезагрузить приложение',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      );
}
