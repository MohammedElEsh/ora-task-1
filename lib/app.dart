import 'package:flutter/material.dart';
import 'package:ora_task_1/core/wrappers/screen_util_wrapper.dart';

import 'core/theme/typography/app_typography.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        home: Scaffold(
          appBar: AppBar(title: Text('My App', style: AppTypography.bold28)),
          body: Center(
            child: Text('Hello, World!', style: AppTypography.bold28),
          ),
        ),
      ),
    );
  }
}
