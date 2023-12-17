import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pro_words/src/features/toaster/toaster.dart';
import 'package:pro_words/src/features/toaster/toaster_config.dart';

/// {@template toaster_scope}
/// Область видимости тостера
/// {@endtemplate}
@immutable
class ToasterScope extends StatefulWidget {
  /// Дочерний виджет
  final Widget child;

  /// {@macro toaster_scope}
  const ToasterScope({
    required this.child,
    super.key,
  });

  /// Возвращает стейт области видимости тостера, если BuildContext
  /// содержит ToasterScope, иначе выкидывает ошибку [FlutterError]
  static ToasterScopeState of(BuildContext context) {
    _InheritedToaster? scope;

    scope = context.getInheritedWidgetOfExactType<_InheritedToaster>();

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

  /// {@macro toaster_state}
  late ToasterState _state;

  /// {@macro toaster_controller}
  ToasterController? _currentController;

  /// {template stored_config}
  /// Сохраненный конфиг тостера
  /// {@endtemplate}
  ToasterConfig? _storedConfig;

  /// {@template overlay}
  /// Оверлей
  /// {@endtemplate}
  OverlayState? _overlay;

  @override
  void initState() {
    super.initState();
    _queue = Queue<ToasterController>();
    _state = ToasterState.idle;
  }

  @override
  void dispose() {
    _currentController?.entry
      ?..remove()
      ..dispose();
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
    _overlay ??= Overlay.of(context);
    final entry = _createEntry(config);
    final controller = ToasterController(config: config, entry: entry);
    if (config.isHighPriority) {
      if (!_isCanBeAddedToQueueForHighPriority(controller)) return;
      _queue.addFirst(controller);
      _storeToasterConfig();
      _hideCurrentToast();
      _updateToast();
      _restoreToasterController();
    } else {
      if (_isCanBeAddedToQueue(controller)) _queue.addLast(controller);
      if (_state != ToasterState.showed) _updateToast();
    }
  }

  /// Очистить очередь тостов
  void clearToasts() {
    _queue.clear();
    _hideCurrentToast();
  }

  /// Восстанавливает контроллер тостера и помещает его в начало очереди
  void _restoreToasterController() {
    final config = _storedConfig;
    if (config != null) {
      final entry = _createEntry(config);
      final restoredController =
          ToasterController.restored(config: config, entry: entry);
      _queue.addFirst(restoredController);
    }
  }

  /// Создает [OverlayEntry]
  OverlayEntry _createEntry(ToasterConfig config) => OverlayEntry(
        builder: (context) => Toaster(
          config: config,
          onDismiss: _onDismiss,
        ),
      );

  /// Сохраняет текущую конфигурацию контроллера, если [_state] == [ToasterState.showed]
  void _storeToasterConfig() {
    if (_state != ToasterState.showed) return;
    _storedConfig = _currentController?.config;
  }

  /// Обновление тоста
  void _updateToast() {
    if (_queue.isEmpty) return;
    final controller = _queue.removeFirst();
    if (controller == _currentController) return;
    if (_currentController != null) _hideCurrentToast();
    _overlay?.insert(controller.entry);
    _currentController = controller;
    _state = ToasterState.showed;
  }

  /// Исчезновение текущего тоста
  void _hideCurrentToast() {
    _currentController?.entry.remove();
    _currentController?.entry.dispose();
    if (_currentController?.isRestored ?? false) _storedConfig = null;
    _currentController = null;
    _state = ToasterState.idle;
  }

  /// Возвращает true, если тостер может быть добавлен в очередь
  ///
  /// ## Условия
  ///
  /// 1. В очереди нет контроллеров равынх передавемому
  /// 2. Длина очереди не больше 3
  /// 3. Текущий контроллер не равен передаваемеому
  bool _isCanBeAddedToQueue(ToasterController controller) =>
      _queue.where((element) => element == controller).isEmpty &&
      _queue.length <= 3 &&
      _currentController != controller;

  /// Возвращает true, если в очереди нет контроллеров равынх передавемому и
  /// текущий контроллер не равен передаваемому
  bool _isCanBeAddedToQueueForHighPriority(ToasterController controller) =>
      _queue.where((element) => element == controller).isEmpty &&
      _currentController != controller;

  /// Слушатель статуса анимации тостера
  void _onDismiss() {
    _hideCurrentToast();
    _updateToast();
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
  bool updateShouldNotify(_InheritedToaster oldWidget) => false;
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

  /// Если true, значит контроллер был восстановлен
  final bool isRestored;

  /// {@macro toaster_controller}
  const ToasterController({
    required this.config,
    required this.entry,
  }) : isRestored = false;

  /// Конструктор восстановленного контроллера
  const ToasterController.restored({
    required this.config,
    required this.entry,
  }) : isRestored = true;

  @override
  List<Object?> get props => [config];
}

/// {@template toaster_state}
/// Состояние тостера
/// {@endtemplate}
enum ToasterState {
  /// Ожидание
  idle,

  /// Отображение
  showed;
}
