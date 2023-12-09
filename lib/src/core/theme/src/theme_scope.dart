import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/key_local_storage/key_local_storage.dart';
import 'package:pro_words/src/core/logger/src/logger.dart';

@immutable
class ThemeScope extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Theme scope
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
  /// Контроллер темы приложения
  /// {@endtemplate}
  late final ValueNotifier<ThemeData> _themeController;

  /// {@macro key_local_storage}
  late final IKeyLocalStorage _keyLocalStorage;

  @override
  void initState() {
    super.initState();
    _keyLocalStorage = context.dependencies.keyLocalStorage;
    _themeController = ValueNotifier<ThemeData>(_currentThemeFromLocalStorage)
      ..addListener(_onThemeChange);
  }

  @override
  void dispose() {
    _themeController
      ..removeListener(_onThemeChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _themeController,
        builder: (context, _) => _InheritedTheme(
          state: this,
          theme: theme,
          child: widget.child,
        ),
      );

  /// Перекючает тему
  void toggleTheme() {
    if (isDarkTheme) {
      theme = context.appTheme.lightTheme;
    } else {
      theme = context.appTheme.darkTheme;
    }
  }

  /// Метод вызывающийся при смене темы
  Future<void> _onThemeChange() async {
    try {
      late final String newThemeKey;
      if (theme == context.appTheme.darkTheme) {
        newThemeKey = context.appTheme.darkThemeKey;
      } else {
        newThemeKey = context.appTheme.lightThemeKey;
      }
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

  /// Возвращает текущую тему и локального хранилища
  ThemeData get _currentThemeFromLocalStorage {
    try {
      final themeKey = _keyLocalStorage.getValue(StorageKeys.theme.key) ??
          context.appTheme.darkThemeKey;
      if (themeKey == context.appTheme.darkThemeKey) {
        return context.appTheme.darkTheme;
      }
      return context.appTheme.lightTheme;
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during theme was reading from local storage',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Возвращает тему
  ThemeData get theme => _themeController.value;

  /// Устанавливает тему
  set theme(ThemeData data) {
    if (_themeController.value != data) {
      _themeController.value = data;
    }
  }

  /// Возвращает true, если тема темная
  bool get isDarkTheme => context.appTheme.isDarkTheme(theme);

  /// Возвращает true, если тема светлая
  bool get isLightTheme => context.appTheme.isLightTheme(theme);

  /// Возвращает контроллер темы приложения
  ValueNotifier<ThemeData> get controller => _themeController;
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
  });

  @override
  bool updateShouldNotify(_InheritedTheme oldWidget) =>
      oldWidget.state != state || oldWidget.theme != theme;
}
