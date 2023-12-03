import 'package:flutter/material.dart';

/// {@template disappear_animation}
/// Тип анимация исчезновения
/// {@endtemplate}
enum DisappearAnimationType {
  /// Масштаб
  scale,

  /// Выцветания
  fade;
}

@immutable
class AnimatedDisappear extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Если true, то отображается дочерний виджет
  final bool isVisible;

  /// Точка исчезновения дочернего виджета
  final ({
    DisappearAnimationType disappearAnimation,
    double point
  }) disappearPoint;

  /// Длительность анимации масштаба
  final Duration scaleDuration;

  /// Длительность анимации выцветания
  final Duration fadeDuration;

  /// Анимированное появление/исчезновение виджета c полным исчезновением,
  /// когда значение анимации меньше или равно значению в
  /// [widget.disappearPoints]
  const AnimatedDisappear({
    required this.child,
    required this.isVisible,
    this.disappearPoint = (
      disappearAnimation: DisappearAnimationType.fade,
      point: 0.25,
    ),
    this.scaleDuration = const Duration(milliseconds: 250),
    this.fadeDuration = const Duration(milliseconds: 200),
    super.key,
  });

  @override
  State<AnimatedDisappear> createState() => _AnimatedDisappearState();
}

class _AnimatedDisappearState extends State<AnimatedDisappear>
    with TickerProviderStateMixin {
  /// {@template scale_controller}
  /// Контроллер анимации масштаба
  /// {@endtemplate}
  late final AnimationController _scaleController;

  /// {@template fade_controller}
  /// Контроллер анимации выцветания
  /// {@endtemplate}
  late final AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      value: widget.isVisible ? 1.0 : 0.0,
      vsync: this,
      duration: widget.scaleDuration,
    );
    _fadeController = AnimationController(
      value: widget.isVisible ? 1.0 : 0.0,
      vsync: this,
      duration: widget.fadeDuration,
    );
  }

  @override
  void didUpdateWidget(AnimatedDisappear oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _forwardAnimations();
      } else {
        _reverseAnimations();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedSize(
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: Listenable.merge(_controllers),
          builder: (context, _) {
            if (_isDisappeared) return const SizedBox.shrink();

            return ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.child,
              ),
            );
          },
        ),
      );

  /// Проигрыает анимации вперед
  void _forwardAnimations() {
    for (final controller in _controllers) {
      controller.forward();
    }
  }

  /// Проигрыает анимации в обратную сторону
  void _reverseAnimations() {
    for (final controller in _controllers) {
      controller.reverse();
    }
  }

  /// Возвращает контроллеры анимаций
  List<AnimationController> get _controllers =>
      [_scaleController, _fadeController];

  /// Возвращает анимацию масштаба
  Animation<double> get _scaleAnimation => _scaleController.view;

  /// Возвращает анимацию выцветания
  Animation<double> get _fadeAnimation => _fadeController.view;

  /// Возвращает true, если значение анимации меньше или равно значению в
  /// [widget.disappearPoint]
  bool get _isDisappeared {
    final animation = widget.disappearPoint.disappearAnimation;

    final point = widget.disappearPoint.point;

    return switch (animation) {
              DisappearAnimationType.fade => _fadeAnimation.value <= point,
              DisappearAnimationType.scale => _scaleAnimation.value <= point,
            } &&
            _fadeAnimation.status == AnimationStatus.reverse ||
        _fadeAnimation.status == AnimationStatus.dismissed;
  }
}
