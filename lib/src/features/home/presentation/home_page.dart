import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';
import 'package:pro_words/src/features/toaster/toaster_config.dart';
import 'package:pro_words/src/features/toaster/toaster_scope.dart';

@immutable
@RoutePage<void>()
class HomePage extends StatelessWidget {
  /// Домашний экран
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ErrorLayout(
                  onTap: () =>
                      ToasterScope.of(context, listen: false).showToast(
                    context,
                    config: const ToasterConfig(message: 'Сообщение'),
                  ),
                  message: 'Error on home page',
                  // error: FlutterError('Flutter error'),
                  // stackTrace: StackTrace.current,
                ),
              ),
              PrimaryElevatedButton(
                onTap: () => ToasterScope.of(context, listen: false).showToast(
                  context,
                  config: const ToasterConfig(message: 'Работа'),
                ),
                child: Text('Работа'),
              ),
            ],
          ),
        ),
      );
}