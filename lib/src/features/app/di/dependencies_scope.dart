import 'package:flutter/material.dart';
import 'package:pro_words/src/features/app/di/dependencies.dart';

/// {@template dependencies_scope}
/// Область видимости зависимостей приложения
/// {@endtemplate}
@immutable
class DependenciesScope extends StatefulWidget {
  /// {@macro dependencies}
  final Dependencies dependencies;

  /// Дочерний виджет
  final Widget child;

  /// {@macro dependencies_scope}
  const DependenciesScope({
    required this.dependencies,
    required this.child,
    super.key,
  });

  /// Возвращает зависимости приложения или завершается с [ArgumentError] - Out
  /// of scope
  static Dependencies of(BuildContext context) {
    final inheritedDependencies =
        context.getInheritedWidgetOfExactType<_InheritedDependencies>();

    if (inheritedDependencies == null) {
      throw ArgumentError(
        'Out of scope, not found InheritedDependencies',
        'out_of_scope',
      );
    }

    return inheritedDependencies.dependencies;
  }

  @override
  State<DependenciesScope> createState() => _DependenciesScopeState();
}

class _DependenciesScopeState extends State<DependenciesScope> {
  @override
  void dispose() {
    widget.dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _InheritedDependencies(
        dependencies: widget.dependencies,
        child: widget.child,
      );
}

/// {@template inherited_dependencies}
/// Виджет хранящий в себе зависимости приложения
/// {@endtemplate}
class _InheritedDependencies extends InheritedWidget {
  /// {@macro dependencies}
  final Dependencies dependencies;

  /// {@macro inherited_dependencies}
  const _InheritedDependencies({
    required this.dependencies,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedDependencies oldWidget) => false;
}
