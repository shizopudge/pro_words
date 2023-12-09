import 'package:flutter/material.dart';
import 'package:pro_words/src/core/theme/src/app_colors.dart';

@immutable
abstract interface class IAppTheme {
  /// Material Dark Theme Data
  ThemeData get darkTheme;

  /// Material Light Theme Data
  ThemeData get lightTheme;

  /// Цвета
  ///
  /// См. также [IAppColors]
  IAppColors get colors;

  /// Ключ темной темы
  String get darkThemeKey;

  /// Ключ светлой темы
  String get lightThemeKey;

  /// Возвращает true, если тема темная
  bool isDarkTheme(ThemeData theme);

  /// Возвращает true, если тема светлая
  bool isLightTheme(ThemeData theme);
}

/// {@template app_theme}
/// Тема приложения
/// {@endtemplate}
@immutable
class AppTheme implements IAppTheme {
  /// {@macro app_colors}
  final IAppColors appColors;

  /// {@macro app_theme}
  const AppTheme({
    required this.appColors,
  });

  @override
  String get darkThemeKey => 'dark';

  @override
  String get lightThemeKey => 'light';

  @override
  IAppColors get colors => appColors;

  @override
  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        textTheme: _textTheme,
        scaffoldBackgroundColor: colors.white,
        dividerTheme: _dividerThemeData,
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonThemeData,
        colorSchemeSeed: colors.black,
        outlinedButtonTheme: _outlinedButtonThemeData,
        textButtonTheme: _textButtonThemeData,
        progressIndicatorTheme: _progressIndicatorThemeData,
        tabBarTheme: _tabBarThemeData,
        bottomNavigationBarTheme: _bottomNavigationBarThemeData,
        iconButtonTheme: _iconButtonThemeData,
        checkboxTheme: _checkboxThemeData,
        switchTheme: _switchThemeData,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  @override
  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        textTheme: _textTheme,
        scaffoldBackgroundColor: colors.grey,
        dividerTheme: _dividerThemeData,
        appBarTheme: _appBarTheme,
        elevatedButtonTheme: _elevatedButtonThemeData,
        colorSchemeSeed: colors.black,
        outlinedButtonTheme: _outlinedButtonThemeData,
        textButtonTheme: _textButtonThemeData,
        progressIndicatorTheme: _progressIndicatorThemeData,
        tabBarTheme: _tabBarThemeData,
        bottomNavigationBarTheme: _bottomNavigationBarThemeData,
        iconButtonTheme: _iconButtonThemeData,
        checkboxTheme: _checkboxThemeData,
        switchTheme: _switchThemeData,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  @override
  bool isDarkTheme(ThemeData theme) => theme == darkTheme;

  @override
  bool isLightTheme(ThemeData theme) => theme == lightTheme;

  /// AppBar Theme
  AppBarTheme get _appBarTheme => AppBarTheme(
        titleTextStyle: _textTheme.headlineLarge?.copyWith(
          color: colors.black,
        ),
        toolbarHeight: 80,
        foregroundColor: colors.black,
        shadowColor: colors.grey,
        surfaceTintColor: colors.white,
        scrolledUnderElevation: 0.5,
        elevation: 0,
        centerTitle: false,
        backgroundColor: colors.white,
      );

  /// Text Style
  TextTheme get _textTheme => const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.5,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.2,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.5,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.2,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.6,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.63,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.3,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.4,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.0,
          height: 1.6,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.63,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.0,
          height: 1.86,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          inherit: false,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.0,
          height: 1.3,
          textBaseline: TextBaseline.alphabetic,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      );

  /// Button style
  ElevatedButtonThemeData get _elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: _textTheme.titleMedium,
          backgroundColor: colors.black,
          foregroundColor: colors.white,
          minimumSize: const Size.fromHeight(64),
          maximumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Outlined button style
  OutlinedButtonThemeData get _outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: _textTheme.titleMedium,
          foregroundColor: colors.black,
          backgroundColor: colors.white,
          minimumSize: const Size.fromHeight(64),
          maximumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          side: BorderSide(color: colors.black),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Text button style
  TextButtonThemeData get _textButtonThemeData => TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: _textTheme.titleMedium,
          foregroundColor: colors.black,
          backgroundColor: colors.white,
          minimumSize: const Size.fromHeight(64),
          maximumSize: const Size.fromHeight(64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Icon button style
  IconButtonThemeData get _iconButtonThemeData => IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: colors.black,
          backgroundColor: colors.white,
          minimumSize: const Size.square(40),
          maximumSize: const Size.square(40),
          padding: const EdgeInsets.all(8),
          iconSize: 24,
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
      );

  /// Tab bar style
  TabBarTheme get _tabBarThemeData => TabBarTheme(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: colors.white,
          border: Border.all(
            color: colors.black,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: colors.black,
        labelPadding: EdgeInsets.zero,
        labelStyle: _textTheme.bodyMedium,
        unselectedLabelColor: colors.grey,
        unselectedLabelStyle: _textTheme.bodyMedium,
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      );

  /// Bottom navigation bar style
  BottomNavigationBarThemeData get _bottomNavigationBarThemeData =>
      BottomNavigationBarThemeData(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: colors.white,
        selectedIconTheme: IconThemeData(
          color: colors.black,
        ),
        unselectedIconTheme: IconThemeData(
          color: colors.grey,
        ),
        selectedLabelStyle: _textTheme.labelSmall?.copyWith(
          color: colors.black,
        ),
        unselectedLabelStyle: _textTheme.labelSmall?.copyWith(
          color: colors.grey,
        ),
      );

  /// Checkbox style
  CheckboxThemeData get _checkboxThemeData => CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? colors.black
              : colors.white,
        ),
        checkColor: MaterialStateProperty.all(colors.white),
        splashRadius: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: MaterialStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: states.contains(MaterialState.selected)
                ? colors.black
                : colors.grey,
          ),
        ),
      );

  /// Switch style
  SwitchThemeData get _switchThemeData => SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => colors.white,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? colors.black
              : colors.grey,
        ),
        trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
        trackOutlineWidth: MaterialStateProperty.all(0),
        splashRadius: 0,
      );

  /// Progress indicator style
  ProgressIndicatorThemeData get _progressIndicatorThemeData =>
      ProgressIndicatorThemeData(color: colors.black);

  /// Divider style
  DividerThemeData get _dividerThemeData => DividerThemeData(
        color: colors.grey,
        thickness: 1,
        indent: 0,
        space: 0,
      );
}
