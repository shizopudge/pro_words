import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro_words/app/app_di.dart';
import 'package:pro_words/core/key_local_storage/key_local_storage.dart';
import 'package:pro_words/core/logger/logger.dart';
import 'package:pro_words/core/theme/theme.dart';

@immutable
class ThemeScope extends ConsumerStatefulWidget {
  /// Child widget
  final Widget child;

  /// Theme scope
  const ThemeScope({
    required this.child,
    super.key,
  });

  /// Возвращает стейт области видимости темы приложения, если BuildContext
  /// содержит ThemeScope, иначе выкидывает ошибку [FlutterError]
  static ThemeScopeState of(BuildContext context, {bool listen = false}) {
    _ThemeProvider? scope;

    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<_ThemeProvider>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_ThemeProvider>();
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
  static ThemeData getTheme(BuildContext context, {bool listen = false}) {
    _ThemeProvider? scope;

    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<_ThemeProvider>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_ThemeProvider>();
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
  ConsumerState<ThemeScope> createState() => ThemeScopeState();
}

class ThemeScopeState extends ConsumerState<ThemeScope> {
  /// {@template theme_controller}
  /// Контроллер темы приложения
  /// {@endtemplate}
  late final ValueNotifier<ThemeData> _themeController;

  /// {@macro key_local_storage}
  late final IKeyLocalStorage _keyLocalStorage;

  @override
  void initState() {
    super.initState();
    _keyLocalStorage = ref.read(AppDI.appCoreModulesProvider).keyLocalStorage;
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
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) => _ThemeProvider(
          state: this,
          theme: theme,
          child: widget.child,
        ),
      );

  /// Перекючает тему
  void toggleTheme() {
    if (isDarkTheme) {
      theme = AppTheme.lightTheme;
    } else {
      theme = AppTheme.darkTheme;
    }
  }

  /// Метод вызывающийся при смене темы
  Future<void> _onThemeChange() async {
    try {
      late final String newThemeKey;
      if (theme == AppTheme.darkTheme) {
        newThemeKey = AppTheme.darkThemeKey;
      } else {
        newThemeKey = AppTheme.lightThemeKey;
      }
      await _keyLocalStorage.setValue(
        StorageKeys.theme.key,
        newThemeKey,
      );
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while new theme key was writing to local storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Возвращает текущую тему и локального хранилища
  ThemeData get _currentThemeFromLocalStorage {
    final themeKey = _keyLocalStorage.getValue(StorageKeys.theme.key) ??
        AppTheme.darkThemeKey;
    if (themeKey == AppTheme.darkThemeKey) {
      return AppTheme.darkTheme;
    }
    return AppTheme.lightTheme;
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
  bool get isDarkTheme => _themeController.value == AppTheme.darkTheme;

  /// Возвращает true, если тема cdtnkfz
  bool get isLightTheme => _themeController.value == AppTheme.lightTheme;

  /// Возвращает контроллер темы приложения
  ValueNotifier<ThemeData> get controller => _themeController;
}

@immutable
class _ThemeProvider extends InheritedWidget {
  /// Стейт области видимости темы приложения
  final ThemeScopeState state;

  /// Тема приложения
  final ThemeData theme;

  /// Поставщик стейта области видимости темы приложения
  const _ThemeProvider({
    required this.state,
    required this.theme,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemeProvider oldWidget) =>
      oldWidget.state != state || oldWidget.theme != theme;
}
