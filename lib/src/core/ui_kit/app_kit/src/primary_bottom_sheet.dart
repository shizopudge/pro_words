import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';

/// {@template primary_bottom_sheet}
/// Основной виджет всплывающего нижнего меню
/// {@endtemplate}
@immutable
class PrimaryBottomSheet extends StatelessWidget {
  /// Дочерний виджет
  final Widget child;

  /// Заголовок
  final String title;

  /// Цвет драга
  final Color? dragColor;

  /// Цвет заднего фона
  final Color? backgroundColor;

  /// {@macro primary_bottom_sheet}
  const PrimaryBottomSheet._({
    required this.child,
    this.title = '',
    this.dragColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: backgroundColor ?? context.colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 5,
                  width: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: dragColor ?? context.colors.grey,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title.isNotEmpty) ...[
                    _SheetAppBar(title: title),
                  ],
                  Flexible(
                    child: child,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

@immutable
class _SheetAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Заголовок
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  const _SheetAppBar({
    required this.title,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 16,
          right: 16,
        ),
        child: Text(
          title,
          style: context.theme.textTheme.titleLarge?.copyWith(
            color: context.colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
