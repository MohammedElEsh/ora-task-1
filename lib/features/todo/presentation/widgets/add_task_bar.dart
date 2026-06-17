import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/shared/buttons/app_button.dart';
import '../../../../core/shared/inputs/app_text_field.dart';
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
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _controller,
              hint: 'Add a task...',
              onSubmitted: (_) => _onAdd(),
              textInputAction: TextInputAction.done,
            ),
          ),
          12.horizontalSpace,
          AppButton(
            label: 'Add',
            onPressed: _onAdd,
            variant: AppButtonVariant.elevated,
            prefixIcon: const Icon(Icons.add),
            expanded: false,
          ),
        ],
      ),
    );
  }
}
