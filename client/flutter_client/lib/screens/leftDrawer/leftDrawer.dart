import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/topicChannelTile.dart';
import 'package:flutter_client/services/authProvider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //todo: mute notification, dark mode, notifications, peoples, rate, leave, invite
    //todo: ADMIN remove people,
    return Drawer(
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: SizeConfig.screenWidth * 1 / 4,
              child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TopicsStream(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                            height: SizeConfig.screenHeight * 0.1,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenWidth * 10 / 360),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.screenWidth * 10 / 360),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: SizeConfig.screenHeight * 0.1,
                                    color: Colors.black26,
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.screenHeight * 1 / 10, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<UiNotifier>(context, listen: true)
                            .selectedTopicTitle,
                        style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 1 / 16,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        Provider.of<UiNotifier>(context, listen: true)
                            .leftNavIndex,
                        style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 1 / 32,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 5.5,
                ),
                TopicOptionTile(
                  title: 'Peoples',
                  icon: Icons.perm_contact_cal_outlined,
                  onPressed: () {},
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                    title: 'Invite people', icon: Icons.insert_invitation),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                    title: 'Mute notification',
                    icon: Icons.notifications_off_outlined),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(title: 'Requests', icon: CupertinoIcons.bell),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                  title: 'Sign out',
                  icon: Icons.logout,
                  onPressed: () {
                    AuthProvider().signOut();
                    Navigator.pushNamed(context, '/logIn');
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                    title: 'Leave topic',
                    icon: CupertinoIcons.arrow_left_circle),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 4.5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Rate this topic',
                    style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 1 / 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4, top: 8),
                  child: RatingBar.builder(
                    itemBuilder: (_, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                    itemCount: 5,
                    direction: Axis.horizontal,
                    initialRating: 0,
                    itemSize: 26,
                    unratedColor: Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TopicOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onPressed;

  const TopicOptionTile(
      {Key key, @required this.title, @required this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 8,
          ),
          Icon(icon),
          SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: SizeConfig.screenWidth * 1 / 25,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
