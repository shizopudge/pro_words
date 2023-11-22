import 'package:flutter/material.dart';
import 'package:pro_words/app/locator.dart';

// TODO: Вынести эти переменные по темам и придумать, где хранить ключи для
// локального хранилища. Вынести сами темы.

const String kDarkThemeKey = 'dark';

const String kLightThemeKey = 'light';

const String kThemeLocalStorageKey = 'theme';

/// Dark theme
final darkTheme = ThemeData.dark();

/// Light theme
final lightTheme = ThemeData.light();

@immutable
class ThemeProvider extends StatefulWidget {
  /// Child widget
  final Widget child;

  /// Theme scope data
  const ThemeProvider({
    required this.child,
    super.key,
  });

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
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
  Widget build(BuildContext context) => ThemeScope(
        themeController: _themeController,
        child: widget.child,
      );

  /// Method that would be executed when theme changes
  Future<void> _onThemeChange() async {
    try {
      late final String newThemeKey;
      if (_themeController.value == darkTheme) {
        newThemeKey = kDarkThemeKey;
      } else {
        newThemeKey = kLightThemeKey;
      }
      await Locator.sharedPreferences.setString(
        kThemeLocalStorageKey,
        newThemeKey,
      );
    } on Object catch (error, stackTrace) {
      Locator.logger.e(
        'Something went wrong while new theme key was writing to local storage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Returns current theme from local storage
  ThemeData get _currentThemeFromLocalStorage {
    final themeKey =
        Locator.sharedPreferences.getString(kThemeLocalStorageKey) ??
            kDarkThemeKey;
    if (themeKey == kDarkThemeKey) {
      return darkTheme;
    }
    return lightTheme;
  }
}

@immutable
class ThemeScope extends InheritedWidget {
  /// {@macro theme_controller}
  final ValueNotifier<ThemeData> themeController;

  /// Scope
  const ThemeScope({
    required this.themeController,
    required super.child,
    super.key,
  });

  static ThemeScope of(BuildContext context, {bool watch = true}) {
    ThemeScope? scope;

    if (watch) {
      scope = context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    } else {
      scope = context.getInheritedWidgetOfExactType<ThemeScope>();
    }

    if (scope == null) {
      throw FlutterError(
        'ThemeScope was requested with a context that does not include an ThemeScope.',
      );
    }

    return scope;
  }

  @override
  bool updateShouldNotify(ThemeScope oldWidget) => true;

  /// Toggle theme method
  void toggleTheme() {
    if (isDarkTheme) {
      theme = lightTheme;
    } else {
      theme = darkTheme;
    }
  }

  /// Theme controller
  ValueNotifier<ThemeData> get controller => themeController;

  /// Theme data getter
  ThemeData get theme => themeController.value;

  /// Theme setter
  set theme(ThemeData data) {
    if (themeController.value != data) {
      themeController.value = data;
    }
  }

  /// Returns true when theme is dark
  bool get isDarkTheme => themeController.value == darkTheme;

  /// Returns true when theme is light
  bool get isLightTheme => themeController.value == lightTheme;
}
