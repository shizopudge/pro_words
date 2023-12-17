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
  /// {@macro message_and_refresh_button_visibility_controller}
  late final ValueNotifier<bool> _messageAndRefreshButtonVisibilityController;

  /// {@macro app_colors}
  late final IAppColors colors;

  /// {@macro app_theme}
  late final IAppTheme appTheme;

  @override
  void initState() {
    super.initState();
    _messageAndRefreshButtonVisibilityController = ValueNotifier<bool>(false);
    colors = AppColors();
    appTheme = AppTheme(appColors: colors);
  }

  @override
  void dispose() {
    _messageAndRefreshButtonVisibilityController.dispose();
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
                    AnimatedBuilder(
                      animation: _messageAndRefreshButtonVisibilityController,
                      builder: (context, _) => PrimaryAnimatedSwitcher(
                        showFirst: _showMessageAndRefreshButton,
                        firstChild: Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                            left: 40,
                            right: 40,
                          ),
                          child: Text(
                            'К сожалению нам не удалось инициализировать приложение...',
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
              errorIconAppearanceController:
                  _messageAndRefreshButtonVisibilityController,
            ),
          ),
        ),
      );

  /// Слушатель анимации
  void _animationListener(AnimationController controller) {
    if (_messageAndRefreshButtonVisibilityController.value) return;
    _messageAndRefreshButtonVisibilityController.value =
        controller.value >= 0.4;
  }

  /// Возвращает значение контроллера [_messageAndRefreshButtonVisibilityController]
  bool get _showMessageAndRefreshButton =>
      _messageAndRefreshButtonVisibilityController.value;

  /// Перезагружает приложение
  Future<void> _reinitializeApp() => Future<void>.value();
}

@immutable
class _BottomButton extends AnimatedWidget {
  /// Обработчик нажатия
  final VoidCallback onTap;

  /// {@macro message_and_refresh_button_visibility_controller}
  final ValueNotifier<bool> errorIconAppearanceController;

  /// Нижняя кнопка
  const _BottomButton({
    required this.onTap,
    required this.errorIconAppearanceController,
    super.key,
  }) : super(listenable: errorIconAppearanceController);

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        left: false,
        right: false,
        child: AnimatedFadeSlideTransition(
          isVisible: errorIconAppearanceController.value,
          duration: const Duration(milliseconds: 300),
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
