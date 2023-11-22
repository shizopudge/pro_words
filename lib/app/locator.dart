import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Locator {
  const Locator._();

  static final Map<String, Object?> _map = {
    kLogger: null,
  };

  static Map<String, Object?> get map => _map;

  /// ------
  /// Logger
  /// ------
  static Logger get logger {
    final logger = _map[kLogger] as Logger?;
    if (logger == null) {
      throw Exception('Logger was not initialized yet');
    }
    return logger;
  }

  static String get kLogger => 'logger';

  static set logger(Logger logger) => _map[kLogger] = logger;

  /// ------
  /// Shared preferences
  /// ------
  static SharedPreferences get sharedPreferences {
    final sharedPreferences = _map[kSharedPreferences] as SharedPreferences?;
    if (sharedPreferences == null) {
      throw Exception('Shared preferences was not initialized yet');
    }
    return sharedPreferences;
  }

  static String get kSharedPreferences => 'sharedPreferences';

  static set sharedPreferences(SharedPreferences sharedPreferences) =>
      _map[kSharedPreferences] = sharedPreferences;
}
