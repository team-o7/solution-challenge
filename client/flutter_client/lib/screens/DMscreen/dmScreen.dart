import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/dmtile.dart';
import 'package:flutter_client/reusables/widgets/searchTextField.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class DmScreen extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const DmScreen({Key key, this.innerDrawerKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor0,
        title: Text('DMs'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            innerDrawerKey.currentState
                .close(direction: InnerDrawerDirection.end);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchTextField(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
              DmTile(),
            ],
          ),
        ),
      ),
    );
  }
}
