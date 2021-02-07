import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class Search extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const Search({Key key, this.innerDrawerKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: MainAppBar(
                innerDrawerKey: innerDrawerKey,
                title: 'Search',
              )),
        ));
  }
}
