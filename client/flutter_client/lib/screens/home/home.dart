import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor0,
        ),
        body: Container(),
        drawer: Container(
          width: size.width * 0.8,
          child: Drawer(),
        ));
  }
}
