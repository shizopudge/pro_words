import 'package:flutter/cupertino.dart';

/// {@template scroll_controller_mixin}
/// Миксин контроллера скролла
/// {@endtemplate}
mixin ScrollControllerMixin<T extends StatefulWidget> on State<T> {
  /// {@template scroll_controller}
  /// Контроллер скролла
  /// {@endtemplate}
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// {@macro scroll_controller}
  ScrollController get scrollController => _scrollController;

  /// Возвращает текущее смещение скролла
  double get scrollOffset {
    if (!_scrollController.hasClients) return 0.0;
    return _scrollController.offset;
  }

  /// Возвращает true, если скролл достиг нижней границы
  bool get isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
