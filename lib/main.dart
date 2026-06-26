import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/services/logger/logger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerService.i('App starting');
  initDependencies();
  LoggerService.i('Dependencies initialized');
  runApp(const App());
  LoggerService.i('App running');
}
