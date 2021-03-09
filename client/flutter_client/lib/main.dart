import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/routes/routes.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
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
        initialRoute: '/',
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
            brightness: Brightness.dark,
            accentColor: kPrimaryColor1,
            splashColor: kPrimaryColor0),
      ),
    );
  }
}
