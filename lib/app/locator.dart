import 'package:logger/logger.dart';

class Locator {
  const Locator._();

  static final Map<String, Object?> _map = {
    kLogger: null,
  };

  static Map<String, Object?> get map => _map;

  /// ------
  /// Logger
  /// ------
  static String get kLogger => 'logger';

  static Logger get logger {
    final logger = _map[kLogger] as Logger?;
    if (logger == null) {
      throw Exception('Logger was not initialized yet');
    }
    return logger;
  }

  static set logger(Logger logger) => _map[kLogger] = logger;
}
