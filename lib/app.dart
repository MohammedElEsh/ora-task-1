import 'package:flutter/material.dart';

import 'core/wrappers/screen_util_wrapper.dart';
import 'features/scanner/presentation/views/event_preparation_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenUtilWrapper(
      child: MaterialApp(
        title: 'Gate Scanner',
        debugShowCheckedModeBanner: false,
        home: EventPreparationView(),
      ),
    );
  }
}
