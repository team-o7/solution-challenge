import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class Profile extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const Profile({Key key, @required this.innerDrawerKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MainAppBar(
            innerDrawerKey: innerDrawerKey,
            title: 'Profile',
          )),
    );
  }
}
