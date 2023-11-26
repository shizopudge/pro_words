import 'package:flutter/material.dart';
import 'package:pro_words/core/key_local_storage/src/key_local_storage.dart';
import 'package:pro_words/core/key_local_storage/src/storage_keys.dart';
import 'package:pro_words/core/logger/logger.dart';
import 'package:pro_words/core/theme/theme.dart';

@immutable
class ThemeScope extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Theme scope
  const ThemeScope({
    required this.child,
    super.key,
  });

  /// Return a theme scope state if BuildContext include a ThemeScope,
  /// otherwise throws an [FlutterError]
  static ThemeScopeState of(BuildContext context, {bool listen = true}) {
    _ThemeProvider? scope;

    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<_ThemeProvider>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_ThemeProvider>();
    }

    if (scope == null) {
      throw FlutterError(
        'ThemeScope was requested with a context that does not include an ThemeScope.',
      );
    }

    return scope.state;
  }

  /// Return a theme data if BuildContext include a ThemeScope,
  /// otherwise throws an [FlutterError]
  static ThemeData getTheme(BuildContext context, {bool listen = true}) {
    _ThemeProvider? scope;

    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<_ThemeProvider>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_ThemeProvider>();
    }

    if (scope == null) {
      throw FlutterError(
        'ThemeScope was requested with a context that does not include an ThemeScope.',
      );
    }

    return scope.theme;
  }

  @override
  State<ThemeScope> createState() => ThemeScopeState();
}

class ThemeScopeState extends State<ThemeScope> {
  /// {@template theme_controller}
  /// Controller of theme
  /// {@endtemplate}
  late final ValueNotifier<ThemeData> _themeController;

  @override
  void initState() {
    super.initState();
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

  /// Toggle theme method
  void toggleTheme() {
    if (isDarkTheme) {
      theme = AppTheme.lightTheme;
    } else {
      theme = AppTheme.darkTheme;
    }
  }

  /// Method that would be executed when theme changes
  Future<void> _onThemeChange() async {
    try {
      late final String newThemeKey;
      if (theme == AppTheme.darkTheme) {
        newThemeKey = AppTheme.darkThemeKey;
      } else {
        newThemeKey = AppTheme.lightThemeKey;
      }
      await KeyLocalStorage.setValue(
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

  /// Returns current theme from local storage
  ThemeData get _currentThemeFromLocalStorage {
    final themeKey = KeyLocalStorage.getValue(StorageKeys.theme.key) ??
        AppTheme.darkThemeKey;
    if (themeKey == AppTheme.darkThemeKey) {
      return AppTheme.darkTheme;
    }
    return AppTheme.lightTheme;
  }

  /// Theme data getter
  ThemeData get theme => _themeController.value;

  /// Theme setter
  set theme(ThemeData data) {
    if (_themeController.value != data) {
      _themeController.value = data;
    }
  }

  /// Returns true when theme is dark
  bool get isDarkTheme => _themeController.value == AppTheme.darkTheme;

  /// Returns true when theme is light
  bool get isLightTheme => _themeController.value == AppTheme.lightTheme;
}

@immutable
class _ThemeProvider extends InheritedWidget {
  /// Theme scope state
  final ThemeScopeState state;

  /// Theme data
  final ThemeData theme;

  /// Theme provider
  const _ThemeProvider({
    required this.state,
    required this.theme,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemeProvider oldWidget) =>
      oldWidget.state != state || oldWidget.theme != theme;
}
