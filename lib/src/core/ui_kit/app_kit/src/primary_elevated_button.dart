import 'package:flutter/material.dart';

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

  /// {@macro primary_elevated_button}
  const PrimaryElevatedButton({
    required this.onTap,
    required this.child,
    this.style,
    this.padding,
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
      duration: const Duration(milliseconds: 100),
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
    // Кнопка
    Widget button = AnimatedBuilder(
      animation: _scaleAnimationController,
      builder: (context, _) => ScaleTransition(
        scale: _scaleAnimationController.view,
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: widget.style,
          child: widget.child,
        ),
      ),
    );

    if (widget.onTap != null) {
      button = GestureDetector(
        onTapDown: (_) => _scaleDown(),
        onTapUp: (_) => _returnToDefault(),
        onTapCancel: _returnToDefault,
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

  /// Обработчик на зажатие кнопки
  Future<void> _scaleDown() => _scaleAnimationController.reverse();

  /// Обработчик на зажатие кнопки
  Future<void> _returnToDefault() => _scaleAnimationController.forward();
}
