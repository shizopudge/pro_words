import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template toaster_config}
/// Конфигурация тостера
/// {@endtemplate}
@immutable
class ToasterConfig extends Equatable {
  /// Сообщение
  final String message;

  /// Иконка
  final Widget? icon;

  /// Действие
  final Widget? action;

  /// Длительность
  final Duration duration;

  /// {@macro toaster_type}
  final ToasterType type;

  /// Если true, то тостер добавиться в самое начало очереди и будет показан
  /// без замедления
  final bool isHighPriority;

  /// {@macro toaster_config}
  const ToasterConfig({
    required this.message,
    this.icon,
    this.action,
    this.duration = const Duration(milliseconds: 3000),
    this.type = ToasterType.message,
    this.isHighPriority = false,
  });

  @override
  List<Object?> get props => [
        message,
        icon,
        action,
        duration,
        type,
      ];
}

/// {@template toaster_type}
/// Тип тостера
/// {@endtemplate}
enum ToasterType {
  error,
  message,
  warning,
  success;
}
