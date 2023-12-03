import 'package:flutter/material.dart';
import 'package:pro_words/core/ui_kit/utils_kit/utils_kit.dart';

/// {@template child_or_shrinked_box}
/// Виджет возвращающий дочерний виджет или замещающий виджет,
/// по умолчанию [SizedBox.shrink]
/// {@endtemplate}
@immutable
class ChildOrShrinkedBox extends StatelessWidget {
  /// Если true, то возвращает дочерний виджет
  final bool isVisible;

  /// Дочерний виджет
  final Widget child;

  /// Если true, то смена виджета происходит с анимацией
  final bool _isAnimated;

  /// {@macro child_or_shrinked_box}
  const ChildOrShrinkedBox({
    required this.isVisible,
    required this.child,
    super.key,
  }) : _isAnimated = false;

  /// Конструктор для анимированной замены виджета
  const ChildOrShrinkedBox.animated({
    required this.isVisible,
    required this.child,
    super.key,
  }) : _isAnimated = true;

  @override
  Widget build(BuildContext context) {
    if (_isAnimated) {
      return AnimatedDisappear(
        isVisible: isVisible,
        child: child,
      );
    }

    if (isVisible) return const SizedBox.shrink();

    return child;
  }
}
