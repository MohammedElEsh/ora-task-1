import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../manager/todo_cubit.dart';
import '../manager/todo_state.dart';
import '../widgets/add_task_bar.dart';
import '../widgets/task_tile.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TodoCubit>()..loadTasks(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tasks'),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surfaceLight,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<TodoCubit, TodoState>(
                builder: (context, state) {
                  return switch (state) {
                    TodoInitial() => const SizedBox.shrink(),
                    TodoLoading() => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    TodoLoaded(tasks: final tasks) => tasks.isEmpty
                        ? Center(
                            child: Text(
                              'No tasks yet',
                              style: AppTypography.regular14.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) =>
                                TaskTile(task: tasks[index]),
                          ),
                    TodoError(message: final message) => Center(
                        child: Text(
                          message,
                          style: AppTypography.regular14.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                  };
                },
              ),
            ),
            const AddTaskBar(),
          ],
        ),
      ),
    );
  }
}
