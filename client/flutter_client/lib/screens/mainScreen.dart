import 'package:flutter/material.dart';

import 'DMscreen/dmScreen.dart';
import 'home/home.dart';
import 'leftDrawer/leftDrawer.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (index) {
        index = index;
        // _controller = PageController(viewportFraction: index == 0 ? 0.8 : 1);
        setState(() {});
      },
      controller: _controller,
      children: [
        LeftDrawer(),
        Home(controller: _controller),
        DmScreen(
          controller: _controller,
        )
      ],
    );
  }
}
