import 'package:flutter/material.dart';

import 'core/wrappers/screen_util_wrapper.dart';
import 'features/todo/presentation/views/todo_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenUtilWrapper(
      child: MaterialApp(
        title: 'My Tasks',
        debugShowCheckedModeBanner: false,
        home: TodoView(),
      ),
    );
  }
}
