import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';

/// {@template title_deleage}
/// Делегат заголовка
/// {@endtemplate}
@immutable
class TitleDelegate extends SliverPersistentHeaderDelegate {
  /// Заголовок
  final String title;

  /// {@macro title_deleage}
  const TitleDelegate({required this.title});

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Material(
        color: context.theme.bottomSheetTheme.backgroundColor,
        elevation: shrinkOffset > 0.0 ? 8 : 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  style: context.theme.textTheme.headlineLarge?.copyWith(
                    color: context.colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: AnimatedOpacity(
                  opacity: shrinkOffset > 0.0 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: SizedBox.fromSize(
                    size: const Size.fromHeight(1),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.grey,
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.black.withOpacity(.015),
                            offset: const Offset(0, .15),
                            blurRadius: 0,
                            spreadRadius: 0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  double get maxExtent => 65;

  @override
  double get minExtent => 65;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
