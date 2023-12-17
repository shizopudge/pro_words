import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// {@template primary_animated_icon}
/// Основная анимировання иконка}
/// {@endtemplate}
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

  /// Если true, то анимация зациклена
  final bool _isLooped;

  /// Цвет иконки
  final Color? color;

  /// {@macro primary_animated_icon}
  const PrimaryAnimatedIcon({
    required this.name,
    required this.size,
    this.listener,
    this.onAnimationEnd,
    this.color,
    super.key,
  }) : _isLooped = false;

  /// {@macro primary_animated_icon}
  const PrimaryAnimatedIcon.looped({
    required this.name,
    required this.size,
    this.color,
    super.key,
  })  : _isLooped = true,
        listener = null,
        onAnimationEnd = null;

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
  Widget build(BuildContext context) {
    final icon = LottieBuilder.asset(
      widget.name,
      controller: _animationController,
      onLoaded: (composition) {
        _animationController.duration = composition.duration;
        _playAnimation();
      },
      width: widget.size,
      height: widget.size,
    );

    final color = widget.color;

    if (color == null) return icon;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
      child: icon,
    );
  }

  /// Проигрывает анимацию
  void _playAnimation() {
    if (widget._isLooped) {
      _animationController.repeat();
    } else {
      _animationController
          .forward()
          .whenComplete(() => widget.onAnimationEnd?.call());
    }
  }

  /// Слушатель анимации
  void _animationListener() => _listener?.call(_animationController);
}
