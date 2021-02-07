import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/screens/createTopic/create.dart';
import 'package:flutter_client/screens/home/body.dart';
import 'package:flutter_client/screens/profile/profile.dart';
import 'package:flutter_client/screens/search/search.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class Home extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  Home({Key key, this.innerDrawerKey}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _baccha;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _baccha = [
      Body(
        innerDrawerKey: widget.innerDrawerKey,
      ),
      Search(
        innerDrawerKey: widget.innerDrawerKey,
      ),
      CreateTopic(
        innerDrawerKey: widget.innerDrawerKey,
      ),
      Profile(
        innerDrawerKey: widget.innerDrawerKey,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: size.height * 0.07,
          child: BottomNavigationBar(
            elevation: 12.0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey[400],
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: kBottomNavIconTextStyle,
            unselectedLabelStyle: kBottomNavIconTextStyle,
            currentIndex: _selectedIndex,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            backgroundColor: kPrimaryColor1,
            onTap: (_index) {
              _selectedIndex = _index;
              // context.read()<UiNotifier>().setBottomNavIndex(_index);
              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_filled,
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.create_outlined), label: 'Create'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: 'Profile'),
            ],
          ),
        ),
        body: _baccha[_selectedIndex]);
  }
}
