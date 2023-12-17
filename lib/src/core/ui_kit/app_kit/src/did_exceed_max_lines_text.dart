import 'package:flutter/material.dart';

/// {@template did_exceed_max_lines_text}
/// Виджет текста, который вызывает [onExceedMaxLines] обработчик в случае,
/// если он занимает больше места, чем ему было выделено.
/// {@endtemplate}
@immutable
class DidExceedMaxLinesText extends StatelessWidget {
  /// Данные
  final String data;

  /// Обработчик вызывющийся если текст занимает больше места, чем ему выделено
  final VoidCallback onExceedMaxLines;

  /// Максимальное количество строк
  final int maxLines;

  /// Стиль текста
  final TextStyle? style;

  /// Выравнивание текста
  final TextAlign? textAlign;

  /// Направление текста
  final TextDirection? textDirection;

  const DidExceedMaxLinesText(
    this.data, {
    required this.onExceedMaxLines,
    this.maxLines = 1,
    this.style,
    this.textAlign,
    this.textDirection,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => _DidExceedMaxLinesText(
          data,
          style: style ?? DefaultTextStyle.of(context).style,
          maxLines: maxLines,
          textAlign: textAlign ?? TextAlign.start,
          textDirection: textDirection,
          onExceedMaxLines: onExceedMaxLines,
          width: constraints.maxWidth,
        ),
      );
}

@immutable
class _DidExceedMaxLinesText extends StatefulWidget {
  /// Данные
  final String data;

  /// Обработчик вызывющийся если текст занимает больше места, чем ему выделено
  final VoidCallback onExceedMaxLines;

  /// Ширина
  final double width;

  /// Максимальное количество строк
  final int maxLines;

  /// Стиль текста
  final TextStyle? style;

  /// Выравнивание текста
  final TextAlign? textAlign;

  /// Направление текста
  final TextDirection? textDirection;

  const _DidExceedMaxLinesText(
    this.data, {
    required this.onExceedMaxLines,
    required this.width,
    required this.maxLines,
    required this.style,
    required this.textAlign,
    required this.textDirection,
    super.key,
  });

  @override
  State<_DidExceedMaxLinesText> createState() => _DidExceedMaxLinesTextState();
}

class _DidExceedMaxLinesTextState extends State<_DidExceedMaxLinesText> {
  /// {@template text_painter}
  /// Рисовальщик текста
  /// {@endtemplate}
  late TextPainter _textPainter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _textPainter = TextPainter(
      text: TextSpan(
        text: widget.data,
        style: widget.style ?? DefaultTextStyle.of(context).style,
      ),
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      ellipsis: '...',
      maxLines: widget.maxLines,
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? TextDirection.ltr,
    )..layout(maxWidth: widget.width);
    if (_didExceedMaxLines) _onExceedMaxLines();
  }

  @override
  Widget build(BuildContext context) => Text(
        widget.data,
        style: widget.style ?? DefaultTextStyle.of(context).style,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        overflow: TextOverflow.ellipsis,
        maxLines: widget.maxLines,
        textAlign: widget.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
      );

  /// Обработчик на превышение текстом выделенных размеров
  void _onExceedMaxLines() => WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onExceedMaxLines.call(),
      );

  /// Возвращет true, если текст занял больше места, чем ему было выделено
  bool get _didExceedMaxLines => _textPainter.didExceedMaxLines;
}
