import 'package:flutter/material.dart';
import 'package:pro_words/core/extensions/extensions.dart';

@immutable
class PrimaryLoadingIndicator extends StatelessWidget {
  /// Размер
  final double size;

  /// Внутренние отступы
  final EdgeInsets innerPadding;

  /// Внешние отступы
  final EdgeInsets? outerPadding;

  /// Ширина линии, используемой для рисования круга
  final double strokeWidth;

  /// Цвет заднего фона
  final Color? backgroundColor;

  /// Цвет индикатора
  final Color? indicatorColor;

  /// Цвет границ
  final Color? borderColor;

  /// Primary loading indicator
  const PrimaryLoadingIndicator({
    this.size = 48.0,
    this.innerPadding = const EdgeInsets.all(12),
    this.strokeWidth = 1.25,
    this.outerPadding,
    this.backgroundColor,
    this.indicatorColor,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: outerPadding ?? EdgeInsets.zero,
        child: SizedBox.square(
          dimension: size,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor ?? context.colors.purple.withOpacity(.45),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: context.colors.black.withOpacity(.15),
                  blurRadius: 8,
                  spreadRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
              border: Border.all(
                color: borderColor ?? context.colors.white.withOpacity(.75),
                width: .75,
              ),
            ),
            child: Padding(
              padding: innerPadding,
              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                color: indicatorColor ?? context.colors.white,
              ),
            ),
          ),
        ),
      );
}
