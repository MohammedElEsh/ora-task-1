import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/services/logger/logger_service.dart';

void main() async {
  // Flutter Engine
  WidgetsFlutterBinding.ensureInitialized();
  LoggerService.i('App starting');
  // App Services
  initDependencies();
  LoggerService.i('Dependencies initialized');
  runApp(const App());
  LoggerService.i('App running');
}
