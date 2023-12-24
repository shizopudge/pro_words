import 'package:flutter/material.dart';

/// {@template animated_dade_slide_transition}
/// Анимированное появление/исчезновение виджета c скольжением и выцветанием
/// {@endtemplate}
@immutable
class AnimatedFadeSlideTransition extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Если true, то отображается дочерний виджет
  final bool isVisible;

  /// Длительность анимации
  final Duration? duration;

  /// {@macro animated_dade_slide_transition}
  const AnimatedFadeSlideTransition({
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 350),
    super.key,
  });

  @override
  State<AnimatedFadeSlideTransition> createState() =>
      _AnimatedFadeSlideTransitionState();
}

class _AnimatedFadeSlideTransitionState
    extends State<AnimatedFadeSlideTransition> with TickerProviderStateMixin {
  /// {@template slide_controller}
  /// Контроллер анимации скольжения
  /// {@endtemplate}
  late final AnimationController _slideController;

  /// {@template fade_controller}
  /// Контроллер анимации выцветания
  /// {@endtemplate}
  late final AnimationController _fadeController;

  /// {@macro slide_animation}
  late Animation<Offset> _slideAnimation;

  /// Смещение при появлении
  final Tween<Offset> _appearOffset = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  );

  /// Смещение при исчезновении
  final Tween<Offset> _disappearOffset = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 1),
  );

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void didUpdateWidget(covariant AnimatedFadeSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isWidgetUpdated(oldWidget)) _playAnimations();
  }

  @override
  void dispose() {
    // Уничтожает все контроллеры
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedSize(
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, _) => _isDisappeared
              ? const SizedBox.shrink()
              : SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeController,
                    child: widget.child,
                  ),
                ),
        ),
      );

  /// Проигрывает анимации
  void _playAnimations() {
    if (_isVisible) {
      // Появление виджета
      _fadeController.forward();
      // Переопределение анимации скольжения с новым смещением, чтобы
      // анимируемый виджет выезжал сверху при появлении
      _slideAnimation = _appearOffset.animate(_slideController);
    } else {
      // Исчезновение виджета
      _fadeController.reverse();
      // Переопределение анимации скольжения с новым смещением, чтобы
      // анимируемый виджет уходил вниз при исчезновении
      _slideAnimation = _disappearOffset.animate(_slideController);
    }
    // Сброс состояния контроллера и запуск анимации с обновленным смещением
    _slideController
      ..reset()
      ..forward();
  }

  /// Инициализация анимаций
  void _initAnimations() {
    _slideController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeController = AnimationController(
      value: _isVisible ? 1.0 : 0.0,
      vsync: this,
      duration: widget.duration,
    );
    _slideAnimation = (_isVisible ? _disappearOffset : _appearOffset)
        .animate(_slideController);
  }

  /// Возвращает true, если виджет обновился
  bool _isWidgetUpdated(covariant AnimatedFadeSlideTransition oldWidget) =>
      oldWidget.isVisible != _isVisible;

  /// Возвращает контроллеры анимаций
  List<AnimationController> get _controllers => [
        _slideController,
        _fadeController,
      ];

  /// Возвращает true, если значение анимации выцветания меньше или равно 0.15
  bool get _isDisappeared => _fadeController.value <= 0.15;

  /// Возвращает true, если виджет отображен на экране
  bool get _isVisible => widget.isVisible;
}
