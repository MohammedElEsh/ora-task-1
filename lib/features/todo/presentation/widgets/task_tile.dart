import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/widgets/glass_container.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../../../../core/theme/typography/app_typography.dart';
import '../../data/models/task_model.dart';
import '../manager/todo_cubit.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodoCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Dismissible(
        key: ValueKey(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => cubit.deleteTask(task.id),
        background: _buildDeleteBackground(),
        child: GlassContainer(
          blurSigma: 12,
          borderRadius: 16,
          backgroundColor: task.isCompleted
              ? AppColors.primary10
              : AppColors.surface,
          borderColor: AppColors.border,
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 60.h,
                  color: task.isCompleted
                      ? AppColors.primary30
                      : AppColors.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => cubit.toggleTask(task),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24.r,
                            height: 24.r,
                            decoration: BoxDecoration(
                              color: task.isCompleted
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                              border: task.isCompleted
                                  ? null
                                  : Border.all(
                                      color: AppColors.border,
                                      width: 1.5,
                                    ),
                            ),
                            child: task.isCompleted
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Text(
                            task.title,
                            style: AppTypography.regular14.copyWith(
                              color: task.isCompleted
                                  ? AppColors.textTertiary
                                  : AppColors.textPrimary,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => cubit.deleteTask(task.id),
                          child: Container(
                            width: 32.r,
                            height: 32.r,
                            decoration: const BoxDecoration(
                              color: AppColors.grey100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: AppColors.error,
                              size: 16.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: AppColors.error10,
          borderRadius: BorderRadius.circular(16.r),
        ),
      child: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
    );
  }
}
