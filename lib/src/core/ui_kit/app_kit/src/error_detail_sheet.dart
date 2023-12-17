import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

/// {@tempalte error_detail_sheet}
/// Всплывающее нижнее окно с подробной информацией об ошибке
/// {@endtemplate}
@immutable
class ErrorDetailSheet extends StatelessWidget {
  /// Заголовок
  final String title;

  /// Сообщение
  final String message;

  /// {@macro error_detail_sheet}
  const ErrorDetailSheet._({
    required this.title,
    required this.message,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) =>
      showPrimaryBottomSheet<void>(
        isScrollControlled: false,
        context: context,
        builder: (context) => ErrorDetailSheet._(
          title: title,
          message: message,
        ),
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        left: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: TitleDelegate(title: title),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 16,
                  right: 16,
                ),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    message,
                    style: context.theme.textTheme.bodyLarge
                        ?.copyWith(color: context.colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
