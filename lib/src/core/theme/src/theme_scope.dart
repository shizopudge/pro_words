import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/key_local_storage/key_local_storage.dart';
import 'package:pro_words/src/core/logger/src/logger.dart';

/// {@template theme_scope}
/// Theme scope
/// {@endtemplate}
@immutable
class ThemeScope extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// {@macro theme_scope}
  const ThemeScope({
    required this.child,
    super.key,
  });

  /// Возвращает стейт области видимости темы приложения, если BuildContext
  /// содержит ThemeScope, иначе выкидывает ошибку [FlutterError]
  static ThemeScopeState of(BuildContext context, {bool listen = true}) {
    _InheritedTheme? scope;

    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_InheritedTheme>();
    }

    if (scope == null) {
      throw FlutterError(
        'ThemeScope was requested with a context that does not include an'
        ' ThemeScope.',
      );
    }

    return scope.state;
  }

  /// Возвращает тему приложения, если BuildContext содержит ThemeScope,
  /// иначе выкидывает ошибку [FlutterError]
  static ThemeData getTheme(BuildContext context, {bool listen = true}) {
    _InheritedTheme? scope;

    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_InheritedTheme>();
    }

    if (scope == null) {
      throw FlutterError(
        'ThemeScope was requested with a context that does not include an'
        ' ThemeScope.',
      );
    }

    return scope.theme;
  }

  @override
  State<ThemeScope> createState() => ThemeScopeState();
}

class ThemeScopeState extends State<ThemeScope> {
  /// {@template theme_controller}
  /// Контроллер ключа темы приложения
  /// {@endtemplate}
  late final ValueNotifier<String> _themeKeyController;

  /// {@macro key_local_storage}
  late final IKeyLocalStorage _keyLocalStorage;

  @override
  void initState() {
    super.initState();
    _keyLocalStorage = context.dependencies.keyLocalStorage;
    _themeKeyController =
        ValueNotifier<String>(_currentThemeKeyFromLocalStorage)
          ..addListener(_onThemeChange);
  }

  @override
  void dispose() {
    _themeKeyController
      ..removeListener(_onThemeChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _themeKeyController,
        builder: (context, _) => _InheritedTheme(
          state: this,
          theme: theme,
          child: widget.child,
        ),
      );

  /// Перекючает тему
  void toggleTheme() => themeKey =
      isDark ? context.appTheme.lightThemeKey : context.appTheme.darkThemeKey;

  /// Метод вызывающийся при смене темы
  Future<void> _onThemeChange() async {
    try {
      final String newThemeKey = isDark
          ? context.appTheme.darkThemeKey
          : context.appTheme.lightThemeKey;
      await _keyLocalStorage.setValue(
        StorageKeys.theme.key,
        newThemeKey,
      );
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during new theme key was writing to local storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Возвращает текущий ключ темы из локального хранилища
  String get _currentThemeKeyFromLocalStorage {
    try {
      return _keyLocalStorage.getValue(StorageKeys.theme.key) ??
          context.appTheme.darkThemeKey;
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during theme key was reading from local storage',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Возвращает ключ темы
  String get themeKey => _themeKeyController.value;

  /// Устанавливает ключ темs
  set themeKey(String newThemeKey) {
    if (themeKey == newThemeKey) return;
    _themeKeyController.value = newThemeKey;
  }

  /// Возвращает true, если тема темная
  bool get isDark => context.appTheme.isDark(themeKey);

  /// Возвращает true, если тема светлая
  bool get isLight => context.appTheme.isLight(themeKey);

  /// Возвращает тему
  ThemeData get theme =>
      isDark ? context.appTheme.darkTheme : context.appTheme.lightTheme;
}

@immutable
class _InheritedTheme extends InheritedWidget {
  /// Стейт области видимости темы приложения
  final ThemeScopeState state;

  /// Тема приложения
  final ThemeData theme;

  /// Поставщик стейта области видимости темы приложения
  const _InheritedTheme({
    required this.state,
    required this.theme,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(_InheritedTheme oldWidget) =>
      oldWidget.state != state || oldWidget.theme != theme;
}
