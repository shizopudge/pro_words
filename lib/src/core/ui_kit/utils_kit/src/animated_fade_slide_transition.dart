import 'package:flutter/material.dart';

@immutable
class AnimatedFadeSlideTransition extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Если true, то отображается дочерний виджет
  final bool isVisible;

  /// Длительность анимации
  final Duration? duration;

  /// Анимированное появление/исчезновение виджета c скольжением м выцветанием
  const AnimatedFadeSlideTransition({
    required this.child,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 400),
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
  late final AnimationController _slideAnimationController;

  /// {@template fade_controller}
  /// Контроллер анимации выцветания
  /// {@endtemplate}
  late final AnimationController _fadeAnimationController;

  /// {@template offset_tween}
  /// Анимация скольжения
  /// {@endtemplate}
  late Animation<Offset> _slideAnimation;

  /// Начальное смещение
  final Tween<Offset> _initialOffset = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  );

  /// Смещение при исчезновении
  final Tween<Offset> _disappearOffset = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  );

  @override
  void initState() {
    super.initState();
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _fadeAnimationController = AnimationController(
      value: widget.isVisible ? 1.0 : 0.0,
      vsync: this,
      duration: widget.duration,
    );
    _slideAnimation = _initialOffset.animate(_slideAnimationController);
  }

  @override
  void didUpdateWidget(AnimatedFadeSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      _playAnimations();
    }
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
          animation: Listenable.merge(_controllers),
          builder: (context, _) {
            if (_isDisappeared) return const SizedBox.shrink();

            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimationController,
                child: widget.child,
              ),
            );
          },
        ),
      );

  void _playAnimations() {
    if (widget.isVisible) {
      // Появление виджета
      _fadeAnimationController.forward();
      // Переопределение анимации скольжения с новым смещением, чтобы
      // анимируемый виджет выезжал сверху при появлении
      _slideAnimation = _initialOffset.animate(_slideAnimationController);
    } else {
      // Исчезновение виджета
      _fadeAnimationController.reverse();
      // Переопределение анимации скольжения с новым смещением, чтобы
      // анимируемый виджет уходил вниз при исчезновении
      _slideAnimation = _disappearOffset.animate(_slideAnimationController);
    }
    // Сброс состояния контроллера и запуск анимации с обновленным смещением
    _slideAnimationController
      ..reset()
      ..forward();
  }

  /// Возвращает контроллеры анимаций
  List<AnimationController> get _controllers => [
        _slideAnimationController,
        _fadeAnimationController,
      ];

  /// Возвращает true, если значение анимации выцветания меньше или равно 0.15
  bool get _isDisappeared => _fadeAnimationController.value <= 0.15;
}
