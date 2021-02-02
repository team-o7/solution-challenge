import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';

import 'screens/mainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'backbench',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: kPrimaryColor1,
      ),
      home: MainScreen(),
    );
  }
}
