import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pro_words/src/core/extensions/extensions.dart';
import 'package:pro_words/src/core/resources/resources.dart';
import 'package:pro_words/src/core/ui_kit/ui_kit.dart';

/// {@template app_connect_listener}
/// Слушатель подключения приложения к интернету
/// {@endtemplate}
@immutable
class AppConnectListener extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// {@macro app_connect_listener}
  const AppConnectListener({
    required this.child,
    super.key,
  });

  @override
  State<AppConnectListener> createState() => AppConnectListenerState();
}

class AppConnectListenerState extends State<AppConnectListener> {
  /// {@template stream_subscription}
  /// Подписка на стрим
  /// {@endtemplate}
  late final StreamSubscription<bool> _streamSubscription;

  /// {@template is_checking_controller}
  /// Контроллер состояния проверки
  /// {@endtemplate}
  late final ValueNotifier<bool> _isCheckingController;

  /// {@template no_connect_sheet_visibility_controller}
  /// Контроллер видимости шита "Нет подключения к интернету"
  /// {@endtemplate}
  late final ValueNotifier<bool> _noConnectSheetVisibilityController;

  @override
  void initState() {
    super.initState();
    _isCheckingController = ValueNotifier<bool>(false);
    _noConnectSheetVisibilityController = ValueNotifier<bool>(false);
    _streamSubscription = context.hasConnect.listen(_listener);
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _isCheckingController.dispose();
    _noConnectSheetVisibilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: context.theme,
            child: AnimatedBuilder(
              animation: _noConnectSheetVisibilityController,
              builder: (context, child) => Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AbsorbPointer(
                    absorbing: _isNoConnectSheetIsVisible,
                    child: widget.child,
                  ),
                  _AppConnectSheet(
                    onTap: _checkInternetConnection,
                    isCheckingController: _isCheckingController,
                    isVisible: _isNoConnectSheetIsVisible,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Слушатель изменений интернет подключения
  void _listener(bool hasConnect) {
    if (!hasConnect) {
      _isNoConnectSheetVisible = true;
    } else {
      _isNoConnectSheetVisible = false;
    }
  }

  /// Проверяет интернет подключение
  Future<void> _checkInternetConnection() async {
    _isCheckingController.value = true;
    final hasConnect = await context.hasConnectRead;
    if (!mounted) return;
    _isCheckingController.value = false;
    if (!hasConnect) {
      _isNoConnectSheetVisible = true;
    } else {
      _isNoConnectSheetVisible = false;
    }
  }

  /// Сеттер для [_noConnectSheetVisibilityController]
  set _isNoConnectSheetVisible(bool value) {
    if (_noConnectSheetVisibilityController.value != value) {
      _noConnectSheetVisibilityController.value = value;
    }
  }

  /// Возвращает true, если шит "Нет подключения к интернету" показан
  bool get _isNoConnectSheetIsVisible =>
      _noConnectSheetVisibilityController.value;
}

/// Шит с информацией о том, что у пользователя нет подключения к интернету
@immutable
class _AppConnectSheet extends StatefulWidget {
  /// Обработчик нажатитя
  final VoidCallback onTap;

  /// {@macro is_checking_controller}
  final ValueNotifier<bool> isCheckingController;

  /// Если true, то шит отображается
  final bool isVisible;

  const _AppConnectSheet({
    required this.onTap,
    required this.isCheckingController,
    required this.isVisible,
  });

  @override
  State<_AppConnectSheet> createState() => _AppConnectSheetState();
}

class _AppConnectSheetState extends State<_AppConnectSheet>
    with TickerProviderStateMixin {
  /// {@macro slide_controller}
  late final AnimationController _slideController;

  /// {@macro fade_controller}
  late final AnimationController _fadeController;

  /// {@template slide_animation}
  /// Анимация скольжения
  /// {@endtemplate}
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  @override
  void didUpdateWidget(covariant _AppConnectSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVisible != widget.isVisible) _playAnimations();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge(_controllers),
        builder: (context, child) {
          // Если шит не виден и анимации остановлены в начале, то возвращаем
          // SizedBox.shrink, иначе возвращаем шит обернутый в BackdropFilter
          if (!widget.isVisible && _isControllersDismissed) {
            return const SizedBox.shrink();
          }

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: SafeArea(
              top: false,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeController.view,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(32)),
                      color: context.colors.white,
                      border: Border.all(
                        color: context.colors.grey.withOpacity(.75),
                        width: 1.25,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.black.withOpacity(.075),
                          offset: const Offset(0, -1.5),
                          blurRadius: 4,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _Title(),
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: _InternetIcon(size: 175),
                          ),
                          AnimatedBuilder(
                            animation: widget.isCheckingController,
                            builder: (context, child) => PrimaryElevatedButton(
                              onTap: widget.onTap,
                              padding: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 16,
                              ),
                              isLoading: _isChecking,
                              child: const Text(
                                'Проверить подключение',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

  /// Возвращает значение [_isCheckingController]
  bool get _isChecking => widget.isCheckingController.value;

  /// Инициализирует анимации
  void _initAnimations() {
    _slideController = AnimationController(
      value: widget.isVisible ? 1 : 0,
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fadeController = AnimationController(
      value: widget.isVisible ? 1 : 0,
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(_slideController);
  }

  /// Проигрывает анимации
  void _playAnimations() {
    if (widget.isVisible) {
      for (final controller in _controllers) {
        controller.forward();
      }
    } else {
      for (final controller in _controllers) {
        controller.reverse();
      }
    }
  }

  /// Контроллеры анимаций
  List<AnimationController> get _controllers => [
        _slideController,
        _fadeController,
      ];

  /// Возвращает true, сли все контроллеры анимаций остановлены в начале
  bool get _isControllersDismissed {
    for (final controller in _controllers) {
      if (!controller.isDismissed) return false;
    }
    return true;
  }
}

/// Заголовок шита
@immutable
class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'Нет подключения к интернету...',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.headlineLarge?.copyWith(
            color: context.colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
}

/// Иконка "Интернет"
@immutable
class _InternetIcon extends StatelessWidget {
  /// Размер
  final double size;

  const _InternetIcon({
    required this.size,
  });

  @override
  Widget build(BuildContext context) => PrimaryAnimatedIcon.looped(
        name: Assets.animations.internet,
        size: size,
      );
}
