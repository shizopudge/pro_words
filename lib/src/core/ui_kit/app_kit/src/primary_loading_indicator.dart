import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro_words/src/core/resources/resources.dart';

/// {@template primary_loading_indicator}
/// Primary loading indicator
/// {@endtemplate}
@immutable
class PrimaryLoadingIndicator extends StatelessWidget {
  /// Размер
  final double size;

  /// Цвет индикатора
  final Color? color;

  /// {@macro primary_loading_indicator}
  const PrimaryLoadingIndicator({
    this.size = 48.0,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final indicator = LottieBuilder.asset(
      Assets.animations.loading,
      repeat: true,
      width: size,
      height: size,
    );

    final color = this.color;

    if (color == null) return indicator;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
      child: indicator,
    );
  }
}
