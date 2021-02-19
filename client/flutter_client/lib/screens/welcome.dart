import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/services/databaseHandler.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  void nextPage() async {
    var user = FirebaseAuth.instance.currentUser;
    bool registered = await DatabaseHandler().userHasDataBase();
    if (user == null) {
      Navigator.pushNamed(context, '/logIn');
    } else if (user != null && !registered) {
      // if user signed in but quit app without filling rest of the information
      await Navigator.pushNamed(context, '/registration1');
    } else {
      await Navigator.pushNamed(context, '/drawerHolder');
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
    return Scaffold(
      body: Center(
        child: Text('welcome'),
      ),
    );
  }
}
