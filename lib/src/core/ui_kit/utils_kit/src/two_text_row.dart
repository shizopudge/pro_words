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

  /// Если true, то первый текст главный
  final bool isFirstPrimary;

  /// Фактор минимальной ширины не главного текста
  final double minNonPrimaryWidthFactor;

  /// {@macro two_text_row}
  const TwoTextRow({
    required this.leftText,
    required this.rightText,
    required this.spaceBetween,
    required this.isFirstPrimary,
    this.minNonPrimaryWidthFactor = 0.25,
    super.key,
  }) : assert(
            minNonPrimaryWidthFactor >= 0.05 &&
                minNonPrimaryWidthFactor <= 0.95,
            'minNonPrimaryWidthFactor out of range');

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => _TwoTextRow(
          leftText: leftText,
          rightText: rightText,
          spaceBetween: spaceBetween,
          isFirstPrimary: isFirstPrimary,
          minNonPrimaryWidthFactor: minNonPrimaryWidthFactor.clamp(0.05, 0.95),
          availableWidth: constraints.maxWidth,
        ),
      );
}

@immutable
class _TwoTextRow extends StatefulWidget {
  /// Левый текст
  final TextInRow leftText;

  /// Правый текст
  final TextInRow rightText;

  /// Расстояние между текстами
  final double spaceBetween;

  /// Если true, то первый текст главный
  final bool isFirstPrimary;

  /// Фактор минимальной ширины не главного текста
  final double minNonPrimaryWidthFactor;

  /// Доступная ширина
  final double availableWidth;

  const _TwoTextRow({
    required this.leftText,
    required this.rightText,
    required this.spaceBetween,
    required this.isFirstPrimary,
    required this.minNonPrimaryWidthFactor,
    required this.availableWidth,
  });

  @override
  State<_TwoTextRow> createState() => _TwoTextRowState();
}

class _TwoTextRowState extends State<_TwoTextRow> {
  /// Если true, то первый текст расширяется
  late final bool isFirstTextExpanded;

  /// Если true, то второй текст расширяется
  late final bool isSecondTextExpanded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final leftTextPainter = TextPainter(
      text: TextSpan(
        text: widget.leftText.data,
        style: widget.leftText.style ?? DefaultTextStyle.of(context).style,
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      ellipsis: '...',
      maxLines: widget.leftText.maxLines,
      textAlign: widget.leftText.textAlign ?? TextAlign.start,
      textDirection: widget.leftText.textDirection ?? TextDirection.ltr,
    )..layout(maxWidth: widget.availableWidth);
    final rightTextPainter = TextPainter(
      text: TextSpan(
        text: widget.rightText.data,
        style: widget.rightText.style ?? DefaultTextStyle.of(context).style,
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      ellipsis: '...',
      maxLines: widget.rightText.maxLines,
      textAlign: widget.rightText.textAlign ?? TextAlign.end,
      textDirection: widget.rightText.textDirection ?? TextDirection.ltr,
    )..layout(maxWidth: widget.availableWidth);

    final leftTextWidth = leftTextPainter.width;

    final rightTextWidth = rightTextPainter.width;

    final availableWidth = widget.availableWidth -
        widget.spaceBetween -
        (widget.availableWidth * widget.minNonPrimaryWidthFactor);

    if (widget.isFirstPrimary) {
      isFirstTextExpanded = leftTextWidth > availableWidth;
      isSecondTextExpanded = true;
    } else {
      isSecondTextExpanded = rightTextWidth > availableWidth;
      isFirstTextExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: isFirstTextExpanded ? 1 : 0,
            child: Text(
              widget.leftText.data,
              maxLines: widget.leftText.maxLines,
              overflow: widget.leftText.maxLines != null
                  ? TextOverflow.ellipsis
                  : null,
              textAlign: widget.leftText.textAlign ?? TextAlign.start,
              textDirection: widget.leftText.textDirection ?? TextDirection.ltr,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              style:
                  widget.leftText.style ?? DefaultTextStyle.of(context).style,
            ),
          ),
          SizedBox(width: widget.spaceBetween),
          Expanded(
            flex: isSecondTextExpanded ? 1 : 0,
            child: Text(
              widget.rightText.data,
              maxLines: widget.rightText.maxLines,
              overflow: widget.rightText.maxLines != null
                  ? TextOverflow.ellipsis
                  : null,
              textAlign: widget.rightText.textAlign ?? TextAlign.end,
              textDirection:
                  widget.rightText.textDirection ?? TextDirection.ltr,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              style:
                  widget.rightText.style ?? DefaultTextStyle.of(context).style,
            ),
          ),
        ],
      );
}

/// Пример:
///
/// @override
/// Widget build(BuildContext context) => Scaffold(
///   body: SafeArea(
///     child: Center(
///       child: TwoTextRow(
///         leftText: TextInRow(
///           'text1text1text1text1text1text1text1text1text1text1text1',
///           maxLines: 1,
///           style: context.theme.textTheme.titleMedium?.copyWith(
///             color: context.colors.black,
///           ),
///         ),
///         rightText: TextInRow(
///           'text2text2te',
///           maxLines: 1,
///           style: context.theme.textTheme.titleSmall?.copyWith(
///             color: context.colors.black,
///           ),
///         ),
///         spaceBetween: 20,
///         isFirstPrimary: false,
///         minNonPrimaryWidthFactor: .25,
///       ),
///     ),
///   ),
/// );
