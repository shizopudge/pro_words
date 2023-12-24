import 'package:flutter/cupertino.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/resources/resources.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

/// {@template error_layout}
/// Виджет отображающий ошибку инициализации приложения
/// {@endtemplate}
@immutable
class ErrorLayout extends StatefulWidget {
  /// Сообщение
  final String message;

  /// Заголовок
  final String title;

  /// Текст кнопки
  final String buttonText;

  /// Обработчик нажатия на кнопку
  final VoidCallback? onTap;

  /// {@macro error_layout}
  const ErrorLayout({
    required this.message,
    this.title = 'Ошибка',
    this.buttonText = 'Обновить',
    this.onTap,
    super.key,
  });

  @override
  State<ErrorLayout> createState() => _ErrorLayoutState();
}

class _ErrorLayoutState extends State<ErrorLayout> {
  /// {@template message_and_refresh_button_visibility_controller}
  /// Контроллер появления иконки ошибки
  /// {@endtemplate}
  late final ValueNotifier<bool> _messageAndRefreshButtonVisibilityController;

  /// {@template more_button_visibility_controller}
  /// Контроллер видимости кнопки "Подробнее"
  /// {@endtemplate}
  late final ValueNotifier<bool> _moreButtonVisibilityController;

  @override
  void initState() {
    super.initState();
    _messageAndRefreshButtonVisibilityController = ValueNotifier<bool>(false);
    _moreButtonVisibilityController = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    _messageAndRefreshButtonVisibilityController.dispose();
    _moreButtonVisibilityController.dispose();
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
                  PrimaryAnimatedIcon(
                    name: Assets.animations.error,
                    size: 120,
                    listener: _animationListener,
                  ),
                  AnimatedBuilder(
                    animation: _messageAndRefreshButtonVisibilityController,
                    builder: (context, _) => PrimaryAnimatedSwitcher(
                      showFirst: _showMessageAndRefreshButton,
                      firstChild: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 40,
                          right: 40,
                        ),
                        child: Column(
                          children: [
                            Text(
                              widget.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.headlineLarge
                                  ?.copyWith(color: context.colors.red),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: DidExceedMaxLinesText(
                                widget.message,
                                maxLines: 5,
                                textAlign: TextAlign.center,
                                style: context.theme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: context.colors.grey,
                                ),
                                onExceedMaxLines: _onExceedMaxLines,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _moreButtonVisibilityController,
                              builder: (context, child) =>
                                  PrimaryAnimatedSwitcher(
                                showFirst: _showMoreButton,
                                firstChild: CupertinoButton(
                                  onPressed: _openDetailErrorSheet,
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 24,
                                    right: 24,
                                  ),
                                  child: Text(
                                    'Подробнее',
                                    style: context.theme.textTheme.titleSmall
                                        ?.copyWith(color: context.colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
            errorIconAppearanceController:
                _messageAndRefreshButtonVisibilityController,
          ),
        ],
      );

  /// Слушатель анимации
  void _animationListener(AnimationController controller) {
    if (_messageAndRefreshButtonVisibilityController.value) return;
    _messageAndRefreshButtonVisibilityController.value =
        controller.value >= 0.4;
  }

  /// Обработчик на превышение текстом доступного места
  void _onExceedMaxLines() {
    if (_moreButtonVisibilityController.value) return;
    _moreButtonVisibilityController.value = true;
  }

  /// Открывает шит с подробной информацией об ошибке
  Future<void> _openDetailErrorSheet() => ErrorDetailSheet.show(
        context,
        title: widget.title,
        message: widget.message,
      );

  /// Возвращает значение контроллера [_messageAndRefreshButtonVisibilityController]
  bool get _showMessageAndRefreshButton =>
      _messageAndRefreshButtonVisibilityController.value;

  /// Возвращает значение контроллера [_moreButtonVisibilityController]
  bool get _showMoreButton => _moreButtonVisibilityController.value;
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
        duration: const Duration(milliseconds: 300),
        child: PrimaryElevatedButton(
          onTap: onTap,
          padding: const EdgeInsets.all(20),
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      );
}
