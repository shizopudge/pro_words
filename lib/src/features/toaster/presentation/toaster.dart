import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/features/toaster/domain/toaster_config.dart';

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

  /// {@template scale_controller}
  /// Контроллер масштаба
  /// {@endtemplate}
  late final AnimationController _scaleController;

  /// {@template slide_animation}
  /// Анимация скольжения
  /// {@endtemplate}
  late Animation<Offset> _slideAnimation;

  /// @macro timer}
  late final Timer timer;

  /// {@template per_tick_interval}
  /// Интервал между тиками таймера
  /// {@endtemplate}
  late final Duration _perTickInterval;

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
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: ScaleTransition(
              scale: _scaleController.view,
              child: AnimatedBuilder(
                animation: _slideController,
                builder: (context, child) => SlideTransition(
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
    _scaleController = AnimationController(
      value: 1.0,
      lowerBound: 0.95,
      upperBound: 1.0,
      duration: _scaleDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_slideController);
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
  Future<void> _playDismissAnimations() async {
    // Начинает уменьшение размера
    _scaleController.reverse();

    // Сброс значения контроллера скольжения на 0.0, после чего запуск с
    // обновленной [_slideAnimation] с [Offset.zero] до [Offset(0, .5)]
    _slideController.reset();
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, .5),
    ).animate(_slideController);
    await _slideController.forward();

    // По завершении анимации скольжения перед исчезновением начинается анимация
    // возвращения масштаба
    _scaleController.forward();

    // Запуск анимации скольжения на стандартный оффсет и обновление
    // длительности
    _slideController.duration =
        Duration(milliseconds: _slideDuration.inMilliseconds ~/ 2);
    await _slideController.reverse();

    // Запуск анимации выцветания в обратном направлении
    _fadeController.reverse();

    // Сброс значения контроллера скольжения на 0.0, после чего запуск с
    // обновленной [_slideAnimation] с [Offset.zero] до [Offset(0, -1)]
    _slideController.reset();
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(_slideController);
    await _slideController.forward();

    // Вызов колбэка на исчезновение тостера
    widget.onDismiss.call();
  }

  /// Возвращает основные контроллеры анимаций
  List<AnimationController> get _primaryControllers => [
        _slideController,
        _fadeController,
      ];

  /// {@template slide_duration}
  /// Длительность скольжения
  /// {@endtemplate}
  Duration get _slideDuration => const Duration(milliseconds: 250);

  /// {@template fade_duration}
  /// Длительность выцветания
  /// {@endtemplate}
  Duration get _fadeDuration => const Duration(milliseconds: 200);

  /// {@template pre_dismiss_scale_duration}
  /// Длительность масштабирования перед исчезновением
  /// {@endtemplate}
  Duration get _scaleDuration => const Duration(milliseconds: 100);
}
