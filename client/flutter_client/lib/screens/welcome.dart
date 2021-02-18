import 'package:flutter/material.dart';
import 'package:flutter_client/services/authProvider.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  void nextPage() async {
    var user = await AuthProvider().currentUser();
    if (user == null) {
      Navigator.pushNamed(context, '/logIn');
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
