import 'package:flutter/material.dart';
import 'package:pro_words/core/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template key_local_storage}
/// Key local storage
/// {@endtemplate}
@immutable
class KeyLocalStorage {
  /// {@macro key_local_storage}
  const KeyLocalStorage._();

  /// Shared preferences
  static SharedPreferences? _sharedPreferences;

  /// Initialization
  static Future<void> init() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while KeyLocalStorage was initializing',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Set value
  static Future<void> setValue(String key, String value) async {
    try {
      _sharedPreferences?.setString(key, value);
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while setting value',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get value
  static String? getValue(String key) {
    try {
      return _sharedPreferences?.getString(key);
    } on Object catch (error, stackTrace) {
      L.error(
        'Something went wrong while getting value',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return null;
  }
}
