import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pro_words/src/features/toaster/toaster.dart';
import 'package:pro_words/src/features/toaster/toaster_config.dart';

@immutable
class ToasterScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// Область видимости тостера
  const ToasterScope({
    required this.child,
    super.key,
  });

  /// Возвращает стейт области видимости тостера, если BuildContext
  /// содержит ToasterScope, иначе выкидывает ошибку [FlutterError]
  static ToasterScopeState of(BuildContext context, {bool listen = true}) {
    _InheritedToaster? scope;

    if (listen) {
      scope = context.dependOnInheritedWidgetOfExactType<_InheritedToaster>();
    } else {
      scope = context.getInheritedWidgetOfExactType<_InheritedToaster>();
    }

    if (scope == null) {
      throw FlutterError(
        'ToasterScope was requested with a context that does not include an'
        ' ToasterScope.',
      );
    }

    return scope.state;
  }

  @override
  State<ToasterScope> createState() => ToasterScopeState();
}

class ToasterScopeState extends State<ToasterScope> {
  /// Очередь тостов
  late final Queue<ToasterController> _queue;

  /// Последний контроллер
  ToasterController? _currentController;

  /// Оверлей
  OverlayState? _overlay;

  @override
  void initState() {
    super.initState();
    _queue = Queue<ToasterController>();
  }

  @override
  void dispose() {
    _currentController = null;
    _overlay?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedToaster(
        state: this,
        child: widget.child,
      );

  /// Показывает тост
  void showToast(
    BuildContext context, {
    required ToasterConfig config,
  }) {
    _overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Toaster(
        config: config,
        listener: _listener,
      ),
    );
    _queue.addLast(ToasterController(config: config, entry: entry));
    _updateToast();
  }

  /// Очистить очередь тостов
  void clearToasts() {
    _queue.clear();
    _hideCurrentToast();
  }

  /// Обновление тоста
  void _updateToast() {
    if (_queue.isEmpty) return;
    final controller = _queue.removeFirst();
    if (controller == _currentController) return;
    if (_currentController != null) _hideCurrentToast();
    _overlay?.insert(controller.entry);
    _currentController = controller;
  }

  /// Очистить очередь тостов
  void _hideCurrentToast() {
    _currentController?.entry.remove();
    _currentController?.entry.dispose();
    _currentController = null;
  }

  /// Слушатель статуса анимации тостера
  void _listener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) _hideCurrentToast();
  }
}

/// {@template inherited_toaster}
/// Поставщик стейта области видимости тостера
/// {@endtemplate}
@immutable
class _InheritedToaster extends InheritedWidget {
  /// Состояние области видимости тостера
  final ToasterScopeState state;

  /// {@macro inherited_toaster}
  const _InheritedToaster({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedToaster oldWidget) =>
      state != oldWidget.state;
}

/// {@template toaster_controller}
/// Контроллер тостера
/// {@endtemplate}
@immutable
class ToasterController extends Equatable {
  /// {@macro toast_config}
  final ToasterConfig config;

  /// Текущее наложение
  final OverlayEntry entry;

  /// {@macro toaster_controller}
  const ToasterController({
    required this.config,
    required this.entry,
  });

  @override
  List<Object?> get props => [config];
}
