import 'package:flutter/material.dart';

import 'core/theme/colors/app_colors.dart';
import 'core/wrappers/screen_util_wrapper.dart';
import 'features/todo/presentation/views/todo_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      child: MaterialApp(
        title: 'My Tasks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AppColors.primary,
        ),
        home: const TodoView(),
      ),
    );
  }
}
