import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/ui_kit/app_kit/src/two_text_row.dart';

@immutable
@RoutePage<void>()
class HomePage extends StatefulWidget {
  /// Домашний экран
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TwoTextRow(
            leftText: TextInRow(
              'Посылки (только по России, Казахстан)',
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: context.colors.black,
              ),
            ),
            rightText: TextInRow(
              '12 шт.',
              maxLines: 1,
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: context.colors.black,
              ),
            ),
            spaceBetween: 20,
          ),
        ),
      ),
    );
  }
}
