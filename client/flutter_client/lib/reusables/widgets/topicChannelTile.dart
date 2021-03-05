import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../sizeConfig.dart';

class TopicChannelTile extends StatelessWidget {
  final String topicAcronym;
  final String index;
  final DocumentReference reference;
  final String dp;
  final Map<String, dynamic> data;

  const TopicChannelTile(
      {Key key,
      @required this.topicAcronym,
      this.index,
      this.reference,
      this.dp = '',
      this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        Provider.of<UiNotifier>(context, listen: false).setLeftNavIndex(data);
      },
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8, top: 8),
        height: SizeConfig.screenHeight * 0.1,
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  Provider.of<UiNotifier>(context, listen: true).leftNavIndex ==
                          index
                      ? kPrimaryColor0
                      : Colors.grey,
              width:
                  Provider.of<UiNotifier>(context, listen: true).leftNavIndex ==
                          index
                      ? 2
                      : 1),
          borderRadius:
              BorderRadius.circular(SizeConfig.screenWidth * 10 / 360),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenWidth * 10 / 360),
            ),
            child: CachedNetworkImage(
              imageUrl: dp,
              fadeInDuration: Duration(microseconds: 0),
              fadeOutDuration: Duration(microseconds: 0),
              imageBuilder: (context, imageProvider) => Container(
                width: SizeConfig.screenWidth * 65 / 360,
                height: SizeConfig.screenWidth * 65 / 360,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 4 / 360),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                child: Text(
                  topicAcronym,
                  style: TextStyle(
                      fontSize: SizeConfig.screenHeight * 0.05,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopicsStream extends StatelessWidget {
  static DatabaseHandler _databaseHandler = new DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseHandler.joinedTopics(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<TopicChannelTile> tiles = [];
          var docs = snapshot.data.docs;
          for (var doc in docs) {
            var data = doc.data();
            var reference = doc.reference;
            String acronym = data['title'][0];
            String id = data['id'];
            String dp = data['dp'];
            TopicChannelTile tile = new TopicChannelTile(
              topicAcronym: acronym,
              index: id,
              reference: reference,
              dp: dp,
              data: data,
            );
            tiles.add(tile);
          }
          return Column(
            children: tiles,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
