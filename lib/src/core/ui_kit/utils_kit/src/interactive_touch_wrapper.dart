import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// {@template interaction_hold_wrapper}
/// Обертка добавления интерактивного нажатия на виджет
/// {@endtemplate}
@immutable
class InteractionHoldWrapper extends StatefulWidget {
  /// Постройщик дочернего виджета
  final Widget Function(BuildContext context, bool isHeldDown) builder;

  /// Если true, то интерактивность включена
  final bool isEnabled;

  /// Обработчик на взаимодействие с виджетом
  final ValueChanged<bool>? onInteraction;

  /// {@macro interaction_hold_wrapper}
  const InteractionHoldWrapper({
    required this.builder,
    this.isEnabled = true,
    this.onInteraction,
    super.key,
  });

  @override
  State<InteractionHoldWrapper> createState() => _InteractionHoldWrapperState();
}

class _InteractionHoldWrapperState extends State<InteractionHoldWrapper> {
  /// {@template child_held_down_controller}
  /// Контроллер зажатия дочернего виджета
  /// {@endtemplate}
  late final ValueNotifier<bool> _childHeldDownController;

  @override
  void initState() {
    super.initState();
    _childHeldDownController = ValueNotifier<bool>(false);
    if (widget.onInteraction != null) {
      _childHeldDownController.addListener(_onInteraction);
    }
  }

  @override
  void dispose() {
    if (widget.onInteraction != null) {
      _childHeldDownController.removeListener(_onInteraction);
    }
    _childHeldDownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.isEnabled ? _handleTapDown : null,
        onTapUp: widget.isEnabled ? _handleTapUp : null,
        onTapCancel: widget.isEnabled ? _handleTapCancel : null,
        child: AnimatedBuilder(
          animation: _childHeldDownController,
          builder: (context, _) =>
              widget.builder.call(context, _isChildHeldDown),
        ),
      );

  /// Обработчик на взаимодействие с виджетом
  void _onInteraction() =>
      widget.onInteraction?.call(_childHeldDownController.value);

  /// Обработчик на зажатие виджета
  void _handleTapDown(TapDownDetails event) => _isChildHeldDown = true;

  /// Обработчик на отжатие виджета
  void _handleTapUp(TapUpDetails event) => _isChildHeldDown = false;

  /// Обработчик на отжатие виджета
  void _handleTapCancel() => _isChildHeldDown = false;

  /// Возвращает true, если дочерний виджет зажат
  bool get _isChildHeldDown => _childHeldDownController.value;

  /// Устанавливает новое значение для контроллера зажатия дочернего виджета
  set _isChildHeldDown(bool newValue) {
    if (_childHeldDownController.value == newValue) return;
    _childHeldDownController.value = newValue;
  }
}
