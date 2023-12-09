import 'package:flutter/cupertino.dart';
import 'package:pro_words/src/app/di/dependencies_scope.dart';
import 'package:pro_words/src/core/key_local_storage/key_local_storage.dart';
import 'package:pro_words/src/core/router/router.dart';
import 'package:pro_words/src/core/theme/src/app_theme.dart';

abstract interface class Dependencies {
  /// Возвращает зависимости приложения из [DependenciesScope]
  factory Dependencies.of(BuildContext context) =>
      DependenciesScope.of(context);

  /// Локальное key-value хранилище
  abstract final IKeyLocalStorage keyLocalStorage;

  /// Роутер
  abstract final AppRouter appRouter;

  /// Роутер
  abstract final IAppTheme appTheme;

  /// Вызывается при удалении зависимостей
  Future<void> dispose();
}

/// {@template mutable_dependencies}
/// Мутабельные зависимости
/// {@endtemplate}
final class $MutableDependencies implements Dependencies {
  @override
  late IKeyLocalStorage keyLocalStorage;

  @override
  late AppRouter appRouter;

  @override
  late IAppTheme appTheme;

  /// Возвращает иммутабельные зависимости
  Dependencies freeze() => _$ImmutableDependencies(
        keyLocalStorage: keyLocalStorage,
        appRouter: appRouter,
        appTheme: appTheme,
      );

  @override
  Future<void> dispose() async {
    appRouter.dispose();
  }
}

/// {@template immutable_dependencies}
/// Иммутабельные зависимости
/// {@endtemplate}
final class _$ImmutableDependencies implements Dependencies {
  /// {@macro immutable_dependencies}
  const _$ImmutableDependencies({
    required this.keyLocalStorage,
    required this.appRouter,
    required this.appTheme,
  });

  @override
  final IKeyLocalStorage keyLocalStorage;

  @override
  final AppRouter appRouter;

  @override
  final IAppTheme appTheme;

  @override
  Future<void> dispose() async {
    appRouter.dispose();
  }
}
