import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/buttons/app_button.dart';
import '../../../../core/shared/inputs/app_text_field.dart';
import '../../../../core/shared/widgets/glass_container.dart';
import '../../../../core/theme/colors/app_colors.dart';
import '../manager/todo_cubit.dart';

class AddTaskBar extends StatefulWidget {
  const AddTaskBar({super.key});

  @override
  State<AddTaskBar> createState() => _AddTaskBarState();
}

class _AddTaskBarState extends State<AddTaskBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAdd() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<TodoCubit>().addTask(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      blurSigma: 16,
      borderRadius: 20,
      backgroundColor: AppColors.surfaceDark80,
      borderColor: AppColors.white8,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _controller,
              hint: 'Add a task...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15.sp,
              ),
              textStyle: TextStyle(color: Colors.white, fontSize: 15.sp),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _onAdd(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
              fillColor: Colors.transparent,
            ),
          ),
          SizedBox(width: 8.w),
          AppButton(
            variant: AppButtonVariant.icon,
            label: 'Add',
            onPressed: _onAdd,
            prefixIcon: const Icon(Icons.add_rounded),
            expanded: false,
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(
                AppColors.secondary,
              ),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              shape: const WidgetStatePropertyAll(CircleBorder()),
              elevation: const WidgetStatePropertyAll(8),
              shadowColor: const WidgetStatePropertyAll(AppColors.secondary40),
              fixedSize: WidgetStatePropertyAll(Size(48.r, 48.r)),
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            ),
          ),
        ],
      ),
    );
  }
}
