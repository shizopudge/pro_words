import 'package:flutter/material.dart';

/// {@template primary_animated_switcher}
/// Виджет анимированно меняющий свой дочерний виджет
/// {@endtemplate}
@immutable
class PrimaryAnimatedSwitcher extends StatelessWidget {
  /// Первый дочерний виджет
  final Widget firstChild;

  /// Если true, то отображается [firstChild], иначе отображается [secondChild]
  final bool showFirst;

  /// Второй дочерний виджет
  ///
  /// По умолчанию [SizedBox.shrink]
  final Widget secondChild;

  /// Длительность анимации смены виджетов
  final Duration switchAnimationDuration;

  /// Длительность анимации смены размера
  final Duration sizeAnimationDuration;

  const PrimaryAnimatedSwitcher({
    required this.showFirst,
    required this.firstChild,
    this.secondChild = const SizedBox.shrink(),
    this.switchAnimationDuration = const Duration(milliseconds: 250),
    this.sizeAnimationDuration = const Duration(milliseconds: 100),
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedSize(
        duration: sizeAnimationDuration,
        child: AnimatedSwitcher(
          duration: switchAnimationDuration,
          child: showFirst ? firstChild : secondChild,
        ),
      );
}
