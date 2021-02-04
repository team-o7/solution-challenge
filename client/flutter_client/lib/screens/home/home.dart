import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/screens/createTopic/create.dart';
import 'package:flutter_client/screens/home/body.dart';
import 'package:flutter_client/screens/profile/profile.dart';
import 'package:flutter_client/screens/search/search.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
    @required PageController controller,
  })  : _controller = controller,
        super(key: key);

  final PageController _controller;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _screens = [Body(), Search(), Create(), Profile()];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('sensei'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              widget._controller.animateToPage(0,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
          ),
          backgroundColor: kPrimaryColor0,
          actions: [
            IconButton(
                icon: Icon(Icons.messenger_outline_sharp),
                onPressed: () {
                  widget._controller.animateToPage(2,
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
          currentIndex: _selectedIndex,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (_index) {
            setState(() {
              _selectedIndex = _index;
            });
          },
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
      body: _screens.elementAt(_selectedIndex),
    );
  }
}
