import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatefulWidget {
  static List<TopicChannelTile> _list = [
    TopicChannelTile(
      topicAcronym: 'T7',
      index: 0,
    ),
    TopicChannelTile(
      topicAcronym: 'ML',
      index: 1,
    ),
    TopicChannelTile(
      topicAcronym: 'AI',
      index: 2,
    ),
  ];

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
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
                      children: LeftDrawer._list,
                    ),
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.screenHeight * 1 / 10, left: 8),
                  child: Text(
                    'Machine learning',
                    style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 1 / 16,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 5.35,
                ),
                TopicOptionTile(
                  title: 'People',
                  icon: Icons.perm_contact_cal_outlined,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                    title: 'Invite people', icon: Icons.insert_invitation),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.notifications_off_outlined),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Mute notification',
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 1 / 25,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 1 / 60,
                    ),
                    Switch(value: true, onChanged: (val) {})
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.nights_stay_outlined),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Dark mode',
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 1 / 25,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: SizeConfig.screenWidth * 1 / 7.8,
                    ),
                    Switch(value: false, onChanged: (val) {})
                  ],
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(title: 'Sign out', icon: Icons.logout),
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

  const TopicOptionTile({Key key, @required this.title, @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class TopicChannelTile extends StatelessWidget {
  final String topicAcronym;
  final int index;

  const TopicChannelTile({
    Key key,
    @required this.topicAcronym,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<UiNotifier>(context, listen: false).setLeftNavIndex(index);
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
            child: Center(
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
    );
  }
}
