import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/ui_kit/app_kit/app_kit.dart';
import 'package:pro_words/src/core/ui_kit/utils_kit/src/animated_fade_slide_transition.dart';

@immutable
class ErrorLayout extends StatefulWidget {
  /// Сообщение
  final String message;

  /// Текст кнопки
  final String buttonText;

  /// Обработчик нажатия на кнопку
  final VoidCallback? onTap;

  /// Виджет отображающий ошибку инициализации приложения
  const ErrorLayout({
    required this.message,
    this.buttonText = 'Обновить',
    this.onTap,
    super.key,
  });

  @override
  State<ErrorLayout> createState() => _ErrorLayoutState();
}

class _ErrorLayoutState extends State<ErrorLayout> {
  /// {@template error_icon_appearance_controller}
  /// Контроллер появления иконки ошибки
  /// {@endtemplate}
  late final ValueNotifier<bool> _errorIconAppearanceController;

  @override
  void initState() {
    super.initState();
    _errorIconAppearanceController = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _errorIconAppearanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedErrorIcon(
                        size: 120,
                        listener: _animationListener,
                      ),
                      AnimatedBuilder(
                        animation: _errorIconAppearanceController,
                        builder: (context, _) => AnimatedFadeSlideTransition(
                          isVisible: _isErrorIconAppeared,
                          duration: const Duration(milliseconds: 550),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Error',
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.headlineLarge
                                  ?.copyWith(
                                color: context.colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: AnimatedBuilder(
                      animation: _errorIconAppearanceController,
                      builder: (context, _) => AnimatedFadeSlideTransition(
                        isVisible: _isErrorIconAppeared,
                        duration: const Duration(milliseconds: 550),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 40,
                            right: 40,
                          ),
                          child: Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style:
                                context.theme.textTheme.titleMedium?.copyWith(
                              color: context.colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BottomButton(
            onTap: widget.onTap,
            text: widget.buttonText,
            errorIconAppearanceController: _errorIconAppearanceController,
          )
        ],
      );

  /// Слушатель анимации
  void _animationListener(AnimationController controller) {
    if (controller.value > 0.2) _errorIconAppearanceController.value = true;
  }

  /// Вовзращает true, если иконка ошибки появилась
  bool get _isErrorIconAppeared => _errorIconAppearanceController.value;
}

@immutable
class _BottomButton extends AnimatedWidget {
  /// Обработчик нажатия
  final VoidCallback? onTap;

  /// Текст кнопки
  final String text;

  /// {@macro error_icon_appearance_controller}
  final ValueNotifier<bool> errorIconAppearanceController;

  /// Нижняя кнопка
  const _BottomButton({
    required this.onTap,
    required this.errorIconAppearanceController,
    required this.text,
  }) : super(listenable: errorIconAppearanceController);

  @override
  Widget build(BuildContext context) => AnimatedFadeSlideTransition(
        isVisible: errorIconAppearanceController.value,
        duration: const Duration(milliseconds: 650),
        child: PrimaryElevatedButton(
          onTap: onTap,
          padding: const EdgeInsets.all(20),
          child: Text(text),
        ),
      );
}
