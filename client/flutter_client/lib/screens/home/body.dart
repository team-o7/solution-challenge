import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin channels',
                style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 18 / 360,
                    fontWeight: FontWeight.w600),
              ),
              ChannelTile(
                hasSendAccess: false,
                title: 'documents',
              ),
              ChannelTile(
                hasSendAccess: false,
                title: 'announcements',
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Public channels',
                style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 18 / 360,
                    fontWeight: FontWeight.w600),
              ),
              ChannelTile(
                hasSendAccess: true,
                title: 'general',
              ),
              ChannelTile(
                hasSendAccess: true,
                title: 'random',
              ),
              ChannelTile(
                hasSendAccess: true,
                title: 'team 7',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 12),
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
  final bool hasSendAccess;
  final String title;

  const ChannelTile(
      {Key key, @required this.hasSendAccess, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/channelChat', arguments: title);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 12),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.heart_circle,
              color: hasSendAccess ? Colors.green : Colors.redAccent,
            ),
            SizedBox(
              width: SizeConfig.screenWidth * 8 / 360,
            ),
            Text(
              '#$title',
              style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 15 / 360,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
