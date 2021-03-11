import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/routes/routes.dart';
import 'package:flutter_client/services/databaseHandler.dart';
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

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void nextPage() async {
    var user = FirebaseAuth.instance.currentUser;
    bool registered = await DatabaseHandler().userHasDataBase();
    if (user == null) {
      Navigator.pushNamed(context, '/logIn');
    } else if (user != null && !registered) {
      // if user signed in but quit app without filling rest of the information
      await Navigator.pushNamed(context, '/registration1');
    } else {
      await Provider.of<UiNotifier>(context, listen: false)
          .setSelectedTopicDataFromCache();
      Provider.of<UiNotifier>(context, listen: false).setUserData().then(
            (value) => Navigator.pushNamed(context, '/drawerHolder'),
          );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    nextPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UiNotifier>(create: (_) => UiNotifier())
      ],
      child: MaterialApp(
        title: 'sensei',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
            brightness: Brightness.light,
            accentColor: kPrimaryColor1,
            splashColor: kPrimaryColor0),
      ),
    );
  }
}
