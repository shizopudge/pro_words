import 'package:flutter/cupertino.dart';
import 'package:pro_words/src/core/key_local_storage/key_local_storage.dart';
import 'package:pro_words/src/core/router/router.dart';
import 'package:pro_words/src/core/theme/src/app_theme.dart';
import 'package:pro_words/src/features/app/di/dependencies_scope.dart';
import 'package:pro_words/src/features/app_connect/data/app_connect.dart';

/// {@template dependencies}
/// Зависимости приложения
/// {@endtemplate}
abstract interface class Dependencies {
  /// Возвращает зависимости приложения из [DependenciesScope]
  factory Dependencies.of(BuildContext context) =>
      DependenciesScope.of(context);

  /// {@macro key_local_storage}
  abstract final IKeyLocalStorage keyLocalStorage;

  /// {@macro app_router}
  abstract final AppRouter router;

  /// {@macro app_theme}
  abstract final IAppTheme appTheme;

  /// {@macro app_connect}
  abstract final IAppConnect appConnect;

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
  late AppRouter router;

  @override
  late IAppTheme appTheme;

  @override
  late IAppConnect appConnect;

  /// Возвращает иммутабельные зависимости
  Dependencies freeze() => _$ImmutableDependencies(
        keyLocalStorage: keyLocalStorage,
        router: router,
        appTheme: appTheme,
        appConnect: appConnect,
      );

  @override
  Future<void> dispose() async {
    router.dispose();
  }
}

/// {@template immutable_dependencies}
/// Иммутабельные зависимости
/// {@endtemplate}
final class _$ImmutableDependencies implements Dependencies {
  /// {@macro immutable_dependencies}
  const _$ImmutableDependencies({
    required this.keyLocalStorage,
    required this.router,
    required this.appTheme,
    required this.appConnect,
  });

  @override
  final IKeyLocalStorage keyLocalStorage;

  @override
  final AppRouter router;

  @override
  final IAppTheme appTheme;

  @override
  final IAppConnect appConnect;

  @override
  Future<void> dispose() async {
    router.dispose();
  }
}
