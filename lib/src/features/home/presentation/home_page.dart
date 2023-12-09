import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

@immutable
@RoutePage<void>()
class HomePage extends StatelessWidget {
  /// Домашний экран
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ErrorLayout(
          message: 'Error on home page',
          // error: FlutterError('Flutter error'),
          // stackTrace: StackTrace.current,
        ),
      );
}
