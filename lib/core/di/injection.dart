import 'package:get_it/get_it.dart';

// import '../../features/todo/data/repositories/task_repository.dart';
// import '../../features/todo/data/repositories/task_repository_impl.dart';
// import '../../features/todo/presentation/manager/todo_cubit.dart';
import '../../features/scanner/data/datasources/barcode_database.dart';
import '../../features/scanner/data/repositories/barcode_repository.dart';
import '../../features/scanner/data/repositories/barcode_repository_impl.dart';
import '../../features/scanner/presentation/manager/scanner_cubit.dart';
import '../services/storage/hive_storage_service.dart';

final sl = GetIt.instance;

void initDependencies() {
  sl.registerSingleton<HiveStorageService>(HiveStorageServiceImpl('tasks'));
  // sl.registerSingleton<TaskRepository>(TaskRepositoryImpl());
  // sl.registerFactory<TodoCubit>(() => TodoCubit(sl<TaskRepository>()));

  sl.registerSingleton<BarcodeDatabase>(BarcodeDatabase());
  sl.registerSingleton<BarcodeRepository>(
    BarcodeRepositoryImpl(sl<BarcodeDatabase>()),
  );
  sl.registerFactory<ScannerCubit>(() => ScannerCubit(sl<BarcodeRepository>()));
}
