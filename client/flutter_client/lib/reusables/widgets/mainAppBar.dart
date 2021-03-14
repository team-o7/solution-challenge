import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import '../constants.dart';

class MainAppBar extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final String title;
  final PreferredSizeWidget bottom;

  const MainAppBar(
      {Key key, @required this.innerDrawerKey, this.title, this.bottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        bottom: bottom,
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: TextStyle(color: kPrimaryColor1),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.blueAccent),
          onPressed: () {
            innerDrawerKey.currentState
                .open(direction: InnerDrawerDirection.start);
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.message_rounded, color: Colors.blueAccent),
              onPressed: () {
                innerDrawerKey.currentState
                    .open(direction: InnerDrawerDirection.end);
              })
        ]);
  }
}
