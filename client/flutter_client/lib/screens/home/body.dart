import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';

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
            title: 'Team 7',
          )),
      //todo: Admin channels:- documents, announcements
      //todo: Public channels:- general, random, topic_name
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
              ChannelTile(
                channel: Channel.admin,
                title: 'documents',
              ),
              ChannelTile(
                channel: Channel.admin,
                title: 'announcements',
              ),
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
              ChannelTile(
                channel: Channel.private,
                title: 'Suggestion',
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
              ChannelTile(
                channel: Channel.public,
                title: 'general',
              ),
              ChannelTile(
                channel: Channel.public,
                title: 'random',
              ),
              ChannelTile(
                channel: Channel.public,
                title: 'team 7',
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

  const ChannelTile({Key key, @required this.channel, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.all(0),
      onPressed: () {
        Navigator.pushNamed(context, '/channelChat', arguments: title);
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
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Icon iconType(Channel channel) {
    switch (channel) {
      case Channel.admin:
        return Icon(
          CupertinoIcons.circle,
          color: Colors.redAccent,
          size: 8,
        );
      case Channel.private:
        return Icon(
          CupertinoIcons.circle,
          color: Colors.yellow,
          size: 8,
        );
      case Channel.public:
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

enum Channel { public, private, admin }
