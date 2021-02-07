import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/routes/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UiNotifier>(create: (_) => UiNotifier())
      ],
      child: MaterialApp(
        title: 'sensei',
        debugShowCheckedModeBanner: false,
        initialRoute: '/welcome',
        onGenerateRoute: Routes.generateRoute,
        theme:
            ThemeData(accentColor: kPrimaryColor1, splashColor: kPrimaryColor1),
      ),
    );
  }
}
