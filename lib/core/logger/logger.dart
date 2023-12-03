import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// {@template logger}
/// Логгер
/// {@endtemplate}
@immutable
class L {
  /// {@macro logger}
  const L._();

  /// Экземпляр логгера
  static Logger? _logger;

  /// Инициализирует логгер
  static void init() => _logger = Logger();

  /// Логирование обычного сообщения
  static void log(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger?.d(
        message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );

  /// Логирование ошибки
  static void error(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _logger?.e(
        message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      );

  /// Метод вызывающийся при удалении из дерева навсегда
  static Future<void> dispose() async {
    if (_isClosed) return;
    await _logger?.close();
    _logger = null;
  }

  /// Возвращает true, если логгер закрыт или null
  static bool get _isClosed => _logger?.isClosed() ?? true;
}
