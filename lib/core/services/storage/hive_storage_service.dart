import 'package:hive_ce_flutter/hive_ce_flutter.dart';

abstract class HiveStorageService {
  static const String _boxName = 'app_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(_boxName);
  }

  Future<void> write<T>(String key, T value);

  T? read<T>(String key);

  Future<void> delete(String key);

  Future<void> clear();
}

class HiveStorageServiceImpl implements HiveStorageService {
  Box<dynamic> get _box => Hive.box<dynamic>(HiveStorageService._boxName);

  @override
  Future<void> write<T>(String key, T value) async {
    await _box.put(key, value);
  }

  @override
  T? read<T>(String key) {
    return _box.get(key) as T?;
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
