import 'package:flutter/widgets.dart';
import 'package:pro_words/core/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template key_local_storage}
/// Локальное key-value хранилище
/// {@endtemplate}
@immutable
abstract interface class IKeyLocalStorage {
  /// Записывает значение
  Future<void> setValue(String key, String value);

  /// Получает значение
  String? getValue(String key);

  /// Возвращает все ключи
  Set<String>? getKeys();

  /// Возвращает все ключи
  bool? containsKey(String key);

  /// Удаляет значение
  Future<bool?> remove(String key);

  /// Очищает хранилище
  Future<bool?> clear();
}

/// {@macro key_local_storage}
@immutable
class KeyLocalStorage implements IKeyLocalStorage {
  /// Экземпляр SharedPreferences
  final SharedPreferences _sharedPreferences;

  /// {@macro key_local_storage}
  const KeyLocalStorage({
    required final SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<void> setValue(String key, String value) async {
    try {
      _sharedPreferences.setString(key, value).timeout(
            const Duration(milliseconds: 15000),
          );
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during setting value',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  String? getValue(String key) {
    try {
      return _sharedPreferences.getString(key);
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during getting value',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Set<String>? getKeys() {
    try {
      return _sharedPreferences.getKeys();
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during getting keys',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  bool? containsKey(String key) {
    try {
      return _sharedPreferences.containsKey(key);
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during key contain check',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<bool?> remove(String key) async {
    try {
      return await _sharedPreferences.remove(key).timeout(
            const Duration(milliseconds: 15000),
          );
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during removing value',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  @override
  Future<bool?> clear() async {
    try {
      return await _sharedPreferences.clear().timeout(
            const Duration(milliseconds: 15000),
          );
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong during clearing',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }
}
