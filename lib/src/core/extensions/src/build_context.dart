import 'package:flutter/material.dart';
import 'package:pro_words/src/core/router/router.dart';
import 'package:pro_words/src/core/theme/theme.dart';
import 'package:pro_words/src/features/app/di/dependencies.dart';
import 'package:pro_words/src/features/toaster/domain/toaster_config.dart';
import 'package:pro_words/src/features/toaster/logic/toaster_scope.dart';

extension BuildContextX on BuildContext {
  /// Media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// {@macro dependencies}
  Dependencies get dependencies => Dependencies.of(this);

  /// {@macro app_colors}
  IAppColors get colors => Dependencies.of(this).appTheme.colors;

  /// {@macro app_theme}
  IAppTheme get appTheme => Dependencies.of(this).appTheme;

  /// Слушает текущую тему
  ThemeData get theme => ThemeScope.getTheme(this);

  /// Возвращает текущую тему
  ThemeData get themeRead => ThemeScope.getTheme(this, listen: false);

  /// Возвращает stream подключения к интернету
  Stream<bool> get hasConnect =>
      Dependencies.of(this).appConnect.onConnectChanged;

  /// Возвращает состояние подключения к интернету
  Future<bool> get hasConnectRead =>
      Dependencies.of(this).appConnect.hasConnect();

  /// Возвращает область видмости тостера
  ToasterScopeState get toaster => ToasterScope.of(this);

  /// Возвращает роутер
  AppRouter get router => Dependencies.of(this).router;

  /// Показывает тостер
  void showToaster({
    required String message,
    Widget? icon,
    Widget? action,
    Duration duration = const Duration(milliseconds: 3000),
    ToasterType type = ToasterType.message,
    bool isHighPriority = false,
  }) =>
      ToasterScope.of(this).showToast(
        this,
        config: ToasterConfig(
          message: message,
          icon: icon,
          action: action,
          duration: duration,
          type: type,
          isHighPriority: isHighPriority,
        ),
      );
}
