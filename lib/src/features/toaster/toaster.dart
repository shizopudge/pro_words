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

  /// Слушатель статуса анимации
  final FutureOr<void> Function(AnimationStatus status) listener;

  /// Тостер
  const Toaster({
    required this.config,
    required this.listener,
    super.key,
  });

  @override
  State<Toaster> createState() => _ToasterState();
}

class _ToasterState extends State<Toaster> with SingleTickerProviderStateMixin {
  /// {@macro animation_controller}
  late final AnimationController _animationController;

  /// {@macro offset_tween}
  late Animation<Offset> _slideAnimation;

  /// @macro timer}
  late final Timer timer;

  /// Интервал между тиками
  static const perTickInterval = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )
      ..addStatusListener(widget.listener)
      ..forward();
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_animationController);
    _initTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    _animationController
      ..removeStatusListener(widget.listener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _animationController.view,
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              widget.config.message,
                              style:
                                  context.theme.textTheme.bodyMedium?.copyWith(
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
      );

  /// Инициализирует отложенное исчезновение
  void _initTimer() => timer = Timer.periodic(perTickInterval, _onTick);

  /// Обработчик на тик таймера
  void _onTick(Timer timer) {
    final duration = widget.config.duration;

    if (timer.tick >= duration.inSeconds) {
      timer.cancel();
      _animationController.reverse();
    }
  }
}
