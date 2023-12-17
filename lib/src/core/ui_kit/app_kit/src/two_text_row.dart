import 'package:flutter/material.dart';

/// {@template text_in_row}
/// Модель для текста внутри виджета [TwoTextRow]
/// {@endtemplate}
@immutable
class TextInRow {
  /// Данные
  final String data;

  /// Максимальное количество строк
  final int? maxLines;

  /// Стиль текста
  final TextStyle? style;

  /// Выравнивание текста
  final TextAlign? textAlign;

  /// Направление текста
  final TextDirection? textDirection;

  /// {@macro text_in_row}
  const TextInRow(
    this.data, {
    this.maxLines,
    this.style,
    this.textAlign,
    this.textDirection,
  });
}

/// {@template two_text_row}
/// Виджет для корректного отображения двух текстов в строке
/// {@endtemplate}
@immutable
class TwoTextRow extends StatelessWidget {
  /// Левый текст
  final TextInRow leftText;

  /// Правый текст
  final TextInRow rightText;

  /// Расстояние между текстами
  final double spaceBetween;

  /// {@macro two_text_row}
  const TwoTextRow({
    required this.leftText,
    required this.rightText,
    required this.spaceBetween,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => _TwoTextRow(
          leftText: leftText,
          rightText: rightText,
          spaceBetween: spaceBetween,
          availableWidth: constraints.maxWidth,
        ),
      );
}

@immutable
class _TwoTextRow extends StatelessWidget {
  /// Левый текст
  final TextInRow leftText;

  /// Правый текст
  final TextInRow rightText;

  /// Расстояние между текстами
  final double spaceBetween;

  /// Доступная ширина
  final double _availableWidth;

  _TwoTextRow({
    required this.leftText,
    required this.rightText,
    required this.spaceBetween,
    required double availableWidth,
  }) : _availableWidth = availableWidth.floorToDouble();

  @override
  Widget build(BuildContext context) {
    final leftTextPainter = TextPainter(
      text: TextSpan(
        text: leftText.data,
        style: leftText.style ?? DefaultTextStyle.of(context).style,
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      ellipsis: '...',
      maxLines: leftText.maxLines,
      textAlign: leftText.textAlign ?? TextAlign.start,
      textDirection: leftText.textDirection ?? TextDirection.ltr,
    )..layout(maxWidth: _availableWidth);
    final rightTextPainter = TextPainter(
      text: TextSpan(
        text: rightText.data,
        style: rightText.style ?? DefaultTextStyle.of(context).style,
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      ellipsis: '...',
      maxLines: rightText.maxLines,
      textAlign: rightText.textAlign ?? TextAlign.end,
      textDirection: rightText.textDirection ?? TextDirection.ltr,
    )..layout(maxWidth: _availableWidth);

    final leftTextWidth = leftTextPainter.width;

    final rightTextWidth = rightTextPainter.width;

    final totalContentWidth = leftTextWidth + rightTextWidth + spaceBetween;

    int leftTextFlexFactor = 0;

    int rightTextFlexFactor = 0;

    if (leftTextWidth > _availableWidth - rightTextWidth - spaceBetween ||
        rightTextWidth > _availableWidth - leftTextWidth - spaceBetween) {
      if (totalContentWidth >= _availableWidth) {
        if (leftTextWidth >= _availableWidth / 2) {
          leftTextFlexFactor =
              (leftTextWidth / ((_availableWidth - spaceBetween) / 100))
                  .round();
        }
        if (rightTextWidth >= _availableWidth / 2) {
          rightTextFlexFactor =
              (rightTextWidth / ((_availableWidth - spaceBetween) / 100))
                  .round();
        }
      } else {
        if (leftTextWidth >= rightTextWidth) {
          leftTextFlexFactor =
              (leftTextWidth / ((_availableWidth - spaceBetween) / 100))
                  .round();
        } else {
          rightTextFlexFactor =
              (rightTextWidth / ((_availableWidth - spaceBetween) / 100))
                  .round();
        }
      }

      print('First text factor: $leftTextFlexFactor.\n'
          'Second text factor: $rightTextFlexFactor');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: leftTextFlexFactor,
          child: Text(
            leftText.data,
            maxLines: leftText.maxLines,
            overflow: leftText.maxLines != null ? TextOverflow.ellipsis : null,
            textAlign: leftText.textAlign ?? TextAlign.start,
            textDirection: leftText.textDirection ?? TextDirection.ltr,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: leftText.style ?? DefaultTextStyle.of(context).style,
          ),
        ),
        SizedBox(width: spaceBetween),
        Expanded(
          flex: rightTextFlexFactor,
          child: Text(
            rightText.data,
            maxLines: rightText.maxLines,
            overflow: rightText.maxLines != null ? TextOverflow.ellipsis : null,
            textAlign: rightText.textAlign ?? TextAlign.end,
            textDirection: rightText.textDirection ?? TextDirection.ltr,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: rightText.style ?? DefaultTextStyle.of(context).style,
          ),
        ),
      ],
    );
  }
}
