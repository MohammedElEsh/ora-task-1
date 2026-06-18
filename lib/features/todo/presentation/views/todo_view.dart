import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../../data/models/task_model.dart';
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
        backgroundColor: AppColors.backgroundDark,
        extendBody: true,
        body: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<TodoCubit, TodoState>(
                builder: (context, state) => switch (state) {
                  TodoInitial() || TodoLoading() => _buildLoading(),
                  TodoLoaded(:final tasks) =>
                    tasks.isEmpty ? _buildEmpty() : _buildList(tasks),
                  TodoError(:final message) => _buildError(message),
                },
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AddTaskBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  static Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.r,
            height: 100.r,
            decoration: const BoxDecoration(
              color: AppColors.primary10,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt_rounded,
              size: 48.r,
              color: AppColors.primary50,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No tasks yet',
            style: AppTypography.semiBold20.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your first task to get started',
            style: AppTypography.regular14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildList(List<TaskModel> tasks) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 120.h),
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskTile(task: tasks[index]),
    );
  }

  static Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.r,
              height: 80.r,
              decoration: const BoxDecoration(
                color: AppColors.error10,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 40,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: AppTypography.regular14.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
