import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../shared/enums/enums.dart';

class StorageRepository {
  StorageRepository._();
  static final StorageRepository _instance = StorageRepository._();
  factory StorageRepository() {
    return _instance;
  }

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<dynamic> get(StorageKeys key) async {
    String? value = await storage.read(key: key.toString());
    return value == null ? null : jsonDecode(value);
  }

  Future<Map<String, String>> getAll() {
    return storage.readAll();
  }

  Future<void> set({required StorageKeys key, required Object value}) {
    Object encodableValue = value;
    if (encodableValue is Map) {
      encodableValue = encodableValue.map((k, v) {
        return MapEntry(
          k is Enum ? k.name : k,
          v is Enum ? v.name : v,
        );
      });
    }
    return storage.write(key: key.toString(), value: jsonEncode(encodableValue));
  }

  Future<void> remove(StorageKeys key) {
    return storage.delete(key: key.toString());
  }

  Future<void> clear() {
    return storage.deleteAll();
  }
}