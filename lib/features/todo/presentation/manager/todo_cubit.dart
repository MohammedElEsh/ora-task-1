import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repository) : super(const TodoInitial());

  final TaskRepository _repository;

  Future<void> loadTasks() async {
    LoggerService.d('Loading tasks...', tag: 'TodoCubit');
    emit(const TodoLoading());
    try {
      final tasks = await _repository.getTasks();
      LoggerService.d('Loaded ${tasks.length} tasks', tag: 'TodoCubit');
      emit(TodoLoaded(tasks));
    } catch (e) {
      LoggerService.e('Failed to load tasks', error: e, tag: 'TodoCubit');
      emit(TodoError(e.toString()));
    }
  }

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title.trim(),
      createdAt: DateTime.now(),
    );
    LoggerService.d('Adding task: ${task.title}', tag: 'TodoCubit');
    await _repository.addTask(task);
    loadTasks();
  }

  Future<void> toggleTask(TaskModel task) async {
    LoggerService.d('Toggling task: ${task.id}', tag: 'TodoCubit');
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await _repository.updateTask(updated);
    loadTasks();
  }

  Future<void> deleteTask(String id) async {
    LoggerService.d('Deleting task: $id', tag: 'TodoCubit');
    await _repository.deleteTask(id);
    loadTasks();
  }
}
