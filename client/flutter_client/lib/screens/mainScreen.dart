import 'package:flutter/material.dart';
import 'package:flutter_client/screens/leftDrawer/leftDrawer.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import 'DMscreen/dmScreen.dart';
import 'home/home.dart';

class DrawerHolder extends StatefulWidget {
  @override
  _DrawerHolderState createState() => _DrawerHolderState();
}

class _DrawerHolderState extends State<DrawerHolder> {
  GlobalKey<InnerDrawerState> _innerDrawerKey;

  @override
  void initState() {
    _innerDrawerKey = new GlobalKey<InnerDrawerState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InnerDrawer(
      scaffold: Home(
        innerDrawerKey: _innerDrawerKey,
      ),
      leftChild: LeftDrawer(),
      rightChild: DmScreen(innerDrawerKey: _innerDrawerKey),
      key: _innerDrawerKey,
      offset: IDOffset.only(left: 0.7, right: 1.0),
      swipeChild: true,
      onTapClose: true,
    );
  }
}
