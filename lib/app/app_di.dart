import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:pro_words/app/initialization.dart';
import 'package:pro_words/core/router/router.dart';

@immutable
abstract class AppDI {
  /// Провайдер основных модулей приложения
  static final appCoreModulesProvider = Provider.autoDispose<AppCoreModules>(
    (ref) => throw UnimplementedError(),
  );

  /// Провайдер навигации приложения
  static final appRouter = Provider.autoDispose<AppRouter>(
    (ref) {
      final router = AppRouter();
      ref.onDispose(router.dispose);
      return router;
    },
  );
}
