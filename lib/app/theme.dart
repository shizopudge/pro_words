import 'package:flutter/material.dart';

@immutable
class ThemeScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Theme scope
  const ThemeScope({
    required this.child,
    super.key,
  });

  static ThemeScopeData of(BuildContext context, {bool watch = true}) {
    _Scope? scope;

    if (watch) {
      scope = context.dependOnInheritedWidgetOfExactType<_Scope>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_Scope>();
    }

    if (scope == null) {
      throw FlutterError(
        'ThemeScopeData was requested with a context that does not include an ThemeScopeData.',
      );
    }

    return scope.themeScopeData;
  }

  @override
  State<ThemeScope> createState() => ThemeScopeData();
}

class ThemeScopeData extends State<ThemeScope> {
  /// Dark theme
  static final darkTheme = ThemeData.dark();

  /// Light theme
  static final lightTheme = ThemeData.light();

  /// {@template theme_controller}
  /// Theme controller
  /// {@endtemplate}
  late final ValueNotifier<ThemeData> _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = ValueNotifier(darkTheme);
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _Scope(
        themeScopeData: this,
        child: widget.child,
      );

  /// Toggle theme method
  void toggleTheme() {
    if (isDarkTheme) {
      theme = lightTheme;
    } else {
      theme = darkTheme;
    }
  }

  /// Theme controller
  ValueNotifier<ThemeData> get controller => _themeController;

  /// Theme getter
  ThemeData get theme => _themeController.value;

  /// Theme setter
  set theme(ThemeData data) {
    if (_themeController.value != data) {
      _themeController.value = data;
    }
  }

  /// Returns true when theme is dark
  bool get isDarkTheme => _themeController.value == darkTheme;

  /// Returns true when theme is light
  bool get isLightheme => _themeController.value == lightTheme;
}

@immutable
class _Scope extends InheritedWidget {
  /// Theme scope data
  final ThemeScopeData themeScopeData;

  /// Scope
  const _Scope({
    required this.themeScopeData,
    required super.child,
  });

  @override
  bool updateShouldNotify(_Scope oldWidget) => true;
}
