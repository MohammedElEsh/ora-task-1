import '../../../../core/di/injection.dart';
import '../../../../core/services/storage/hive_storage_service.dart';
import '../models/task_model.dart';
import 'task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final _storage = sl<HiveStorageService>();

  @override
  Future<List<TaskModel>> getTasks() async {
    final data = _storage.readAll().values.map(
      (e) => Map<String, dynamic>.from(e as Map),
    );
    return data.map((e) => TaskModel.fromMap(e)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> addTask(TaskModel task) async {
    await _storage.write(task.id, task.toMap());
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await _storage.write(task.id, task.toMap());
  }

  @override
  Future<void> deleteTask(String id) async {
    await _storage.delete(id);
  }
}
