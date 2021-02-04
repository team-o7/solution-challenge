import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/myTopicTile.dart';

class Create extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.height);
    return Scaffold(
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
