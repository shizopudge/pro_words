import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

@immutable
class PrimaryAnimatedIcon extends StatefulWidget {
  /// Название иконки
  final String name;

  /// Размер
  final double size;

  /// Обработчик слушатель анимации
  final FutureOr<void> Function(AnimationController controller)? listener;

  /// Обработчик на конец анимации
  final VoidCallback? onAnimationEnd;

  /// Основная анимированная иконка
  const PrimaryAnimatedIcon({
    required this.name,
    required this.size,
    this.listener,
    this.onAnimationEnd,
    super.key,
  });

  @override
  State<PrimaryAnimatedIcon> createState() => _PrimaryAnimatedIconState();
}

class _PrimaryAnimatedIconState extends State<PrimaryAnimatedIcon>
    with SingleTickerProviderStateMixin {
  /// {@template animation_controller}
  /// Контроллер анимации
  /// {@endtemplate}
  late final AnimationController _animationController;

  /// Слушатель анимации
  late final FutureOr<void> Function(AnimationController controller)? _listener;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _listener = widget.listener;
    if (_listener != null) {
      _animationController.addListener(_animationListener);
    }
  }

  @override
  void dispose() {
    if (_listener != null) {
      _animationController.removeListener(_animationListener);
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LottieBuilder.asset(
        widget.name,
        controller: _animationController,
        onLoaded: (composition) {
          _animationController.duration = composition.duration;
          _animationController
              .forward()
              .whenComplete(() => widget.onAnimationEnd?.call());
        },
        width: widget.size,
        height: widget.size,
      );

  /// Слушатель анимации
  void _animationListener() => _listener?.call(_animationController);
}
