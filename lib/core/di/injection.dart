import 'package:get_it/get_it.dart';

import '../../features/scanner/data/datasources/barcode_database.dart';
import '../../features/scanner/data/repositories/barcode_repository.dart';
import '../../features/scanner/data/repositories/barcode_repository_impl.dart';
import '../../features/scanner/presentation/manager/scanner_cubit.dart';
import '../services/logger/logger_service.dart';

final sl = GetIt.instance;

void initDependencies() {
  LoggerService.d('Registering dependencies');
  sl.registerSingleton<BarcodeDatabase>(BarcodeDatabase());
  LoggerService.d('Registered BarcodeDatabase');
  sl.registerSingleton<BarcodeRepository>(
    BarcodeRepositoryImpl(sl<BarcodeDatabase>()),
  );
  LoggerService.d('Registered BarcodeRepository');
  sl.registerFactory<ScannerCubit>(() => ScannerCubit(sl<BarcodeRepository>()));
  LoggerService.d('Registered ScannerCubit');
  LoggerService.i('All dependencies registered');
}
