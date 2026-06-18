import 'package:hive_ce_flutter/hive_ce_flutter.dart';

abstract class HiveStorageService {
  Future<void> write<T>(String key, T value);

  T? read<T>(String key);

  Map<String, dynamic> readAll();

  Future<void> delete(String key);

  Future<void> clear();
}

class HiveStorageServiceImpl implements HiveStorageService {
  HiveStorageServiceImpl(this.boxName);

  final String boxName;

  static Future<void> init(String boxName) async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(boxName);
  }

  Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  @override
  Future<void> write<T>(String key, T value) async {
    await _box.put(key, value);
  }

  @override
  T? read<T>(String key) {
    return _box.get(key) as T?;
  }

  @override
  Map<String, dynamic> readAll() {
    return Map<String, dynamic>.from(_box.toMap());
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clear() async {
    await _box.clear();
  }
}
