import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/myTopicTile.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class CreateTopic extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const CreateTopic({Key key, @required this.innerDrawerKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.height);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MainAppBar(
            innerDrawerKey: innerDrawerKey,
            title: 'Your topics',
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create_outlined),
        tooltip: 'Create new topic',
        onPressed: () {
          //TODO Alert or bottomSheet with required fields for creating topic
          //topic title
          //public / private
          //Short disrciption
          //ideal for
        },
      ),
      body: ListView(
        children: [
          //TODO Create tile which shows topics that you have created.
          //30 enrolled
          //rating
          //title
          //description
          //delete topic
          //invite
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
          MyTopicTile(size: size),
        ],
      ),
    );
  }
}
