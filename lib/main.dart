import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/services/storage/hive_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorageServiceImpl.init('tasks');
  initDependencies();

  runApp(const App());
}
