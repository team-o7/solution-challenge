import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/topicChannelTile.dart';
import 'package:flutter_client/screens/leftDrawer/peoples.dart';
import 'package:flutter_client/screens/leftDrawer/requests.dart';
import 'package:flutter_client/services/authProvider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class LeftDrawer extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //todo: mute notification, dark mode, notifications, peoples, rate, leave, invite
    //todo: ADMIN remove people,
    return Scaffold(
      body: SafeArea(
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
                                    .selectedTopicTitle ==
                                null
                            ? ''
                            : Provider.of<UiNotifier>(context, listen: true)
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
                                    .leftNavIndex ==
                                null
                            ? ''
                            : Provider.of<UiNotifier>(context, listen: true)
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PeoplesInTopicStream()));
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                  title: 'Invite people',
                  icon: Icons.insert_invitation,
                  onPressed: () {
                    Navigator.pushNamed(context, '/invitePage');
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                  title: 'Mute notification',
                  icon: Icons.notifications_off_outlined,
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                      title: Text('Receive all'),
                                      value: true,
                                      groupValue: false,
                                      onChanged: (val) {}),
                                  RadioListTile(
                                      title: Text('Mute public channels'),
                                      value: false,
                                      groupValue: false,
                                      onChanged: (val) {}),
                                ],
                              ),
                            ));
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 40,
                ),
                TopicOptionTile(
                  title: 'Requests',
                  icon: CupertinoIcons.bell,
                  onPressed: () async {
                    _firestore
                        .collection('topics')
                        .doc(Provider.of<UiNotifier>(context, listen: false)
                            .leftNavIndex)
                        .get()
                        .then((value) {
                      var data = value.data();
                      List<dynamic> requests = data['requests'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => TopicRequestsStream(
                                    reqs: requests,
                                  )));
                    });
                  },
                ),
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
                  icon: CupertinoIcons.arrow_left_circle,
                  onPressed: () {
                    var callable = _functions.httpsCallable('leaveTopic',
                        options: HttpsCallableOptions(
                            timeout: Duration(seconds: 60)));
                    var params = {
                      'topic': Provider.of<UiNotifier>(context, listen: false)
                          .leftNavIndex,
                    };
                    callable.call(params).then((value) {
                      Provider.of<UiNotifier>(context, listen: false)
                          .onTopicleave();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value.data)));
                    });
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 1 / 4.0,
                ),
                InkWell(
                  onTap: () async {
                    double newRating = 0.0;
                    await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text('Rate this topic'),
                              content: RatingBar.builder(
                                itemBuilder: (_, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  newRating = rating;
                                },
                                itemCount: 5,
                                direction: Axis.horizontal,
                                initialRating: 0,
                                itemSize: 26,
                                unratedColor: Colors.grey,
                              ),
                              actions: [
                                MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')),
                                MaterialButton(
                                    onPressed: () {
                                      var callable = _functions.httpsCallable(
                                          'rate',
                                          options: HttpsCallableOptions(
                                              timeout: Duration(seconds: 60)));
                                      var params = {
                                        'topic': Provider.of<UiNotifier>(
                                                context,
                                                listen: false)
                                            .leftNavIndex,
                                        'rating': newRating,
                                      };
                                      callable.call(params).then((value) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(value.data)));
                                      });
                                    },
                                    child: Text('Submit')),
                              ],
                            ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Rate this topic',
                      style: TextStyle(
                          fontSize: SizeConfig.screenWidth * 1 / 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
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
