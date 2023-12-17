import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/features/toaster/toaster_config.dart';

/// {@template toaster}
/// Тостер
/// {@endtemplate}
@immutable
class Toaster extends StatefulWidget {
  /// {@macro toaster_config}
  final ToasterConfig config;

  /// Обработчик на исчезновение тоста
  final VoidCallback onDismiss;

  /// {@macro toaster}
  const Toaster({
    required this.config,
    required this.onDismiss,
    super.key,
  });

  @override
  State<Toaster> createState() => _ToasterState();
}

class _ToasterState extends State<Toaster> with TickerProviderStateMixin {
  /// {@macro slide_controller}
  late final AnimationController _slideController;

  /// {@macro fade_controller}
  late final AnimationController _fadeController;

  /// {@template pre_dismiss_slide_controller}
  /// Контроллер анимации скольжения перед исчезновением
  /// {@endtemplate}
  late final AnimationController _preDismissSlideController;

  /// {@template pre_dismiss_scale_controller}
  /// Контроллер анимации масштаба перед исчезновением
  /// {@endtemplate}
  late final AnimationController _preDismissScaleController;

  /// {@template slide_animation}
  /// Анимация скольжения
  /// {@endtemplate}
  late final Animation<Offset> _slideAnimation;

  /// {@template pre_dismiss_slide}
  /// Анимация скольжения перед исчезновением
  /// {@endtemplate}
  late final Animation<Offset> _preDismissSlide;

  /// @macro timer}
  late final Timer timer;

  /// {@template per_tick_interval}
  /// Интервал между тиками таймера
  /// {@endtemplate}
  late final Duration _perTickInterval;

  /// {@template slide_duration}
  /// Длительность скольжения
  /// {@endtemplate}
  static const Duration _slideDuration = Duration(milliseconds: 200);

  /// {@template fade_duration}
  /// Длительность выцветания
  /// {@endtemplate}
  static const Duration _fadeDuration = Duration(milliseconds: 250);

  /// {@template pre_dismiss_slide_duration}
  /// Длительность скольжения перед исчезновением
  /// {@endtemplate}
  static const Duration _preDismissSlideDuration = Duration(milliseconds: 175);

  /// {@template pre_dismiss_scale_duration}
  /// Длительность масштабирования перед исчезновением
  /// {@endtemplate}
  static const Duration _preDismissScaleDuration = Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();
    // Инициализация контроллеров и анимаций
    _initControllersAndAnimations();
    // Инициализация отложенного исчезновения
    _initDelayedDismiss();
  }

  @override
  void dispose() {
    timer.cancel();
    _slideController.dispose();
    _fadeController.dispose();
    _preDismissSlideController.dispose();
    _preDismissScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: ScaleTransition(
              scale: _preDismissScaleController.view,
              child: SlideTransition(
                position: _preDismissSlide,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeController.view,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: context.colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 24),
                        child: Row(
                          children: [
                            widget.config.icon ?? const SizedBox.shrink(),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  widget.config.message,
                                  style: context.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: context.colors.white,
                                  ),
                                ),
                              ),
                            ),
                            widget.config.action ?? const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  /// Инициализирует контроллеры анимаций и анимации
  void _initControllersAndAnimations() {
    // Инициализация контроллеров и анимаций
    _slideController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: _fadeDuration,
    );
    _preDismissSlideController = AnimationController(
      vsync: this,
      duration: _preDismissSlideDuration,
    );
    _preDismissScaleController = AnimationController(
      value: 1.0,
      lowerBound: 0.95,
      upperBound: 1.0,
      duration: _preDismissScaleDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_slideController);
    _preDismissSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, .5),
    ).animate(_preDismissSlideController);
    // Запуск анимаций
    for (final controller in _primaryControllers) {
      controller.forward();
    }
  }

  /// Инициализирует отложенное исчезновение
  void _initDelayedDismiss() {
    // Инициализация интервала
    _perTickInterval =
        Duration(milliseconds: widget.config.duration.inMilliseconds);
    // Инициализация таймера
    timer = Timer.periodic(_perTickInterval, _onTick);
  }

  /// Обработчик на тик таймера
  void _onTick(Timer timer) {
    if (timer.tick >= 1) {
      timer.cancel();
      _playDismissAnimations();
    }
  }

  /// Проигрывает анимации исчезновения
  void _playDismissAnimations() {
    _preDismissScaleController.reverse();
    _preDismissSlideController.forward().whenComplete(
      () async {
        _preDismissScaleController.forward();
        _preDismissSlideController
          ..duration = _preDismissSlideReverseDuration
          ..reverse().whenComplete(
            () {
              _slideController
                ..duration = _slideReverseDuration
                ..reverse().whenComplete(widget.onDismiss);
              _fadeController
                ..duration = _fadeReverseDuration
                ..reverse();
            },
          );
      },
    );
  }

  /// Возвращает основные контроллеры анимаций
  List<AnimationController> get _primaryControllers => [
        _slideController,
        _fadeController,
      ];

  /// Возвращает длительность обратной анимации выцветания
  Duration get _fadeReverseDuration =>
      Duration(milliseconds: _fadeDuration.inMilliseconds ~/ 1.5);

  /// Возвращает длительность обратной анимации скольжения
  Duration get _slideReverseDuration =>
      Duration(milliseconds: _slideDuration.inMilliseconds ~/ 1.5);

  /// Возвращает длительность обратной анимации скольжения перед исчезновением
  Duration get _preDismissSlideReverseDuration =>
      Duration(milliseconds: _preDismissSlideDuration.inMilliseconds ~/ 1.5);
}
