import 'package:flutter/material.dart';

import 'enter_token_screen.dart';

void main() => runApp(
  /* ProviderScope(
    child:  MyApp()
  ) */
  MyApp()
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EnterTokenScreen(),
    );
  }
}
