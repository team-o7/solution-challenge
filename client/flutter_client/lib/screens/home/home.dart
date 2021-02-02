import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';

class Home extends StatelessWidget {
  const Home({
    Key key,
    @required PageController controller,
  })  : _controller = controller,
        super(key: key);

  final PageController _controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('topictitle'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _controller.animateToPage(0,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
          ),
          backgroundColor: kPrimaryColor0,
          actions: [
            IconButton(
                icon: Icon(Icons.messenger_outline_sharp),
                onPressed: () {
                  _controller.animateToPage(2,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                })
          ]),
      bottomNavigationBar: SizedBox(
        height: size.height * 0.07,
        child: BottomNavigationBar(
          elevation: 12.0,
          selectedItemColor: kPrimaryColor0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: kBottomNavIconTextStyle,
          unselectedLabelStyle: kBottomNavIconTextStyle,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              label: 'Search',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.create_outlined), label: 'Create'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
