import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

/// {@template primary_elevated_button}
/// Основная elevated кнопка приложения
/// {@endtemplate}
@immutable
class PrimaryElevatedButton extends StatefulWidget {
  /// Ообработчик нажатия
  final VoidCallback? onTap;

  /// Дочерний виджет
  final Widget child;

  /// Стиль кнопки
  final ButtonStyle? style;

  /// Отступы кнопки
  final EdgeInsets? padding;

  /// Если true, то вместо [child] отображается индикатор загрузки
  final bool isLoading;

  /// {@macro primary_elevated_button}
  const PrimaryElevatedButton({
    required this.onTap,
    required this.child,
    this.style,
    this.padding,
    this.isLoading = false,
    super.key,
  });

  @override
  State<PrimaryElevatedButton> createState() => _PrimaryElevatedButtonState();
}

class _PrimaryElevatedButtonState extends State<PrimaryElevatedButton>
    with SingleTickerProviderStateMixin {
  /// {@template scale_animation_controller}
  /// Контроллер анимации масштаба
  /// {@endtemplate}
  late final AnimationController _scaleAnimationController;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
      value: 1.0,
      lowerBound: 0.95,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _scaleAnimationController,
      builder: (context, _) => ScaleTransition(
        scale: _scaleAnimationController.view,
        child: ElevatedButton(
          onPressed: _getOnTap,
          style: widget.style,
          child: PrimaryAnimatedSwitcher(
            showFirst: !widget.isLoading,
            firstChild: widget.child,
            secondChild: PrimaryLoadingIndicator(color: context.colors.white),
          ),
        ),
      ),
    );

    if (widget.onTap != null) {
      button = GestureDetector(
        onTapDown: (_) => _scaleAnimationController.reverse(),
        onTapUp: (_) => _scaleAnimationController.forward(),
        onTapCancel: _scaleAnimationController.forward,
        behavior: HitTestBehavior.opaque,
        child: button,
      );
    }

    final padding = widget.padding;

    if (padding == null) return button;

    return Padding(
      padding: padding,
      child: button,
    );
  }

  /// Возвращает обработчик нажатия если он был передан, иначе null
  VoidCallback? get _getOnTap => widget.onTap != null ? _onTap : null;

  /// Обработчик нажатия
  void _onTap() {
    widget.onTap?.call();
    final TickerFuture ticker = _scaleAnimationController.reverse();
    ticker.whenComplete(_scaleAnimationController.forward);
  }
}
