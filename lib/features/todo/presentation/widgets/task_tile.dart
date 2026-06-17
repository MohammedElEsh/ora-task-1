import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../../data/models/task_model.dart';
import '../manager/todo_cubit.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => context.read<TodoCubit>().toggleTask(task),
        activeColor: AppColors.primary,
        checkColor: AppColors.surfaceLight,
      ),
      title: Text(
        task.title,
        style: AppTypography.regular14.copyWith(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted
              ? AppColors.textSecondary
              : AppColors.textPrimaryLight,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => context.read<TodoCubit>().deleteTask(task.id),
        color: AppColors.error,
      ),
    );
  }
}
