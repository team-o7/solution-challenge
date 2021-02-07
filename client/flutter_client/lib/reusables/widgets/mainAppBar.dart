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
        bottom: bottom,
        automaticallyImplyLeading: false,
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            innerDrawerKey.currentState
                .open(direction: InnerDrawerDirection.start);
          },
        ),
        backgroundColor: kPrimaryColor0,
        actions: [
          IconButton(
              icon: Icon(Icons.messenger_outline_sharp),
              onPressed: () {
                innerDrawerKey.currentState
                    .open(direction: InnerDrawerDirection.end);
              })
        ]);
  }
}
