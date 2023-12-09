import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pro_words/src/core/resources/resources.dart';

@immutable
class PrimaryLoadingIndicator extends StatelessWidget {
  /// Размер
  final double size;

  /// Primary loading indicator
  const PrimaryLoadingIndicator({
    this.size = 48.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LottieBuilder.asset(
        Assets.animations.loading,
        repeat: true,
        width: size,
        height: size,
      );
}
