import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// {@template logger}
/// Logger
/// {@endtemplate}
@immutable
class L {
  /// {@macro logger}
  const L._();

  /// Logger instance
  static Logger? _logger;

  /// Init method
  static void init() => _logger = Logger();

  /// Log a default message
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

  /// Log an error message
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

  /// Dispose method
  static Future<void> dispose() async {
    if (_isClosed) return;
    await _logger?.close();
    _logger = null;
  }

  /// Returns true if logger is closed or null
  static bool get _isClosed => _logger?.isClosed() ?? true;
}
