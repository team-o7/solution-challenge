import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/myIcon.dart';

class UserProfile extends StatelessWidget {
  final Map<String, dynamic> userData;
  static FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  UserProfile({Key key, this.userData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.blue[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 10 / 360,
                      vertical: SizeConfig.screenHeight * 5 / 640),
                  child: CachedNetworkImage(
                    imageUrl: userData['dp'],
                    fadeInDuration: Duration(microseconds: 0),
                    fadeOutDuration: Duration(microseconds: 0),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Icon(
                      Icons.account_circle,
                      size: SizeConfig.screenWidth * 120 / 360,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              title: Text(
                '${userData['firstName']} ${userData['lastName']}',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 18 / 360,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor1,
                ),
              ),
              subtitle: Text(
                '@${userData['userName']}',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 12 / 360,
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor1,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.person_add_alt_1,
                  color: Colors.blueAccent,
                  size: SizeConfig.screenWidth * 30 / 360,
                ),
                onPressed: () {
                  Map<String, dynamic> params = {'otherUid': userData['uid']};
                  var callable = _functions.httpsCallable('onFriendRequesting',
                      options:
                          HttpsCallableOptions(timeout: Duration(seconds: 60)));
                  try {
                    callable.call(params).then((value) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value.data)));
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              height: SizeConfig.screenHeight * 40 / 640,
              child: Row(
                children: [
                  ProfileWidget0(
                    text: 'Friends',
                    count: userData['friends'].length.toString(),
                    onTap: () {
                      //todo:
                    },
                  ),
                  ProfileWidget0(
                    text: 'Topics',
                    count: userData['topics'].length.toString(),
                    onTap: () {
                      //todo:
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 20 / 640,
          ),
          Card(
            child: ListTile(
              leading: MyIcon(
                color: Colors.orange,
                iconData: Icons.school,
              ),
              title: Text(
                userData['college'],
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 20 / 640,
          ),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              title: Text(
                'Bio',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              height: SizeConfig.screenHeight * 110 / 640,
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.all(SizeConfig.screenWidth * 10 / 360),
              child: Text(
                userData['bio'],
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w300,
                  color: kPrimaryColor1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileWidget0 extends StatelessWidget {
  final String text;
  final String count;
  final Function onTap;
  final double countFontSize;

  ProfileWidget0({
    @required this.text,
    @required this.count,
    @required this.onTap,
    this.countFontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: onTap,
              child: Text(
                count,
                style: TextStyle(
                  fontSize: countFontSize,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: SizeConfig.screenWidth * 12 / 360,
                fontWeight: FontWeight.w600,
                color: Color(0x803F0E40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
