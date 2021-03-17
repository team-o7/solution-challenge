import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/createTopicModalSheet.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/myTopicTile.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class CreateTopic extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const CreateTopic({Key key, @required this.innerDrawerKey}) : super(key: key);

  @override
  _CreateTopicState createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  static bool _isPrivate = false;
  String _title, _description, _dp;
  File imageFile;
  String imageName;
  bool isLoading = false;

  Widget myIndicator() {
    if (isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: MainAppBar(
              innerDrawerKey: widget.innerDrawerKey,
              title: 'Your topics',
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create_outlined),
          heroTag: 'create',
          tooltip: 'Create new topic',
          onPressed: () {
            createTopicBottomSheet(context);
          },
        ),
        body: MyTopics());
  }
}

class MyTopics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseHandler().myTopics(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          var topics = snapshot.data.docs;
          List<MyTopicTile> tiles = [];
          for (var topic in topics) {
            var data = topic.data();
            String title = data['title'];
            String description = data['description'];
            bool isPrivate = data['private'];
            String link = data['link'];
            int noOfPeoples = data['peoples'].length;
            double rating = data['avgRating'].toDouble();
            MyTopicTile widget = new MyTopicTile(
              title: title,
              description: description,
              isPrivate: isPrivate,
              noOfPeoples: noOfPeoples,
              rating: rating,
              link: link,
            );
            tiles.add(widget);
          }
          return tiles.length == 0
              ? Center(
                  child: Text('Create your first topic'),
                )
              : ListView(
                  children: tiles,
                );
        } else {
          return Container();
        }
      },
    );
  }
}
