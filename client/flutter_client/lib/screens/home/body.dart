import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';
import 'package:flutter_client/screens/channelChat/channelChat.dart';
import 'package:flutter_client/services/databaseHandler.dart';

class Body extends StatelessWidget {
  final innerDrawerKey;

  const Body({Key key, @required this.innerDrawerKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MainAppBar(
            innerDrawerKey: innerDrawerKey,
            title: 'sensei',
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: RoundedTextField(
                  hintText: 'Jump to...',
                  borderRadius: 5,
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Admin channels',
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 18 / 360,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ChannelsStream(channel: Channel.adminChannels),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Private channels',
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 18 / 360,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ChannelsStream(
                channel: Channel.privateChannels,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 8),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.add_circled_solid,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 8 / 360,
                    ),
                    Text(
                      'Add Channel',
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 15 / 360,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Public channels',
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 18 / 360,
                      fontWeight: FontWeight.w600),
                ),
              ),
              ChannelsStream(channel: Channel.publicChannels),
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 8),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.add_circled_solid,
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 8 / 360,
                    ),
                    Text(
                      'Add Channel',
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 15 / 360,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChannelTile extends StatelessWidget {
  final Channel channel;
  final String title;
  final DocumentReference reference;

  const ChannelTile(
      {Key key,
      @required this.channel,
      @required this.title,
      @required this.reference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChannelChat(
                      reference: reference,
                      title: title,
                      channel: channel,
                    )));
      },
      child: Row(
        children: [
          SizedBox(
            width: 12,
          ),
          iconType(channel),
          SizedBox(
            width: SizeConfig.screenWidth * 8 / 360,
          ),
          Text(
            '# $title',
            style: TextStyle(
                fontSize: SizeConfig.screenWidth * 16 / 360,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Icon iconType(Channel channel) {
    switch (channel) {
      case Channel.adminChannels:
        return Icon(
          CupertinoIcons.circle,
          color: Colors.redAccent,
          size: 8,
        );
      case Channel.privateChannels:
        return Icon(
          CupertinoIcons.circle,
          color: Colors.yellow,
          size: 8,
        );
      case Channel.publicChannels:
        return Icon(
          CupertinoIcons.circle,
          color: Colors.green,
          size: 8,
        );
      default:
        return Icon(
          CupertinoIcons.circle,
          color: Colors.black,
          size: 8,
        );
    }
  }
}

enum Channel { publicChannels, privateChannels, adminChannels }

extension ParseToString on Channel {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class ChannelsStream extends StatelessWidget {
  final Channel channel;

  const ChannelsStream({Key key, @required this.channel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DatabaseHandler().channels(context, channel.toShortString()),
      builder: (context, snapshot) {
        double l = 0;
        if (snapshot.hasData) {
          var docs = snapshot.data.docs;
          l = docs.length.toDouble();
          List<ChannelTile> tiles = [];
          for (var doc in docs) {
            String title = doc.data()['title'];
            DocumentReference ref = doc.reference;
            ChannelTile tile =
                new ChannelTile(channel: channel, title: title, reference: ref);
            tiles.add(tile);
          }
          return Column(
            children: tiles,
          );
        } else
          return SizedBox(
            height: l * SizeConfig.screenHeight * 1 / 10,
          );
      },
    );
  }
}
