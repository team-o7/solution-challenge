import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';

class UserProfile extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserProfile({Key key, this.userData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 5 / 640),
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 10 / 360),
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
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 8 / 640,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.screenWidth * 200 / 360,
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 20 / 360),
                    child: Text(
                      '${userData['firstName']} ${userData['lastName']}',
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 18 / 360,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 5 / 640,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 20 / 360),
                    child: Text(
                      '@${userData['userName']}',
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 12 / 360,
                        fontWeight: FontWeight.w400,
                        color: kPrimaryColor1,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: MaterialButton(
                  onPressed: () {
                    //todo:
                  },
                  height: SizeConfig.screenHeight * 30 / 640,
                  color: kPrimaryColor1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        SizeConfig.screenWidth * 20 / 360),
                  ),
                  child: Center(
                    child: Text(
                      'Add Friend',
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 14 / 360,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 20 / 640,
          ),
          Container(
            height: SizeConfig.screenHeight * 40 / 640,
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * 10 / 360),
            decoration: BoxDecoration(
              color: Color(0xffF5F5F5),
              borderRadius:
                  BorderRadius.circular(SizeConfig.screenWidth * 10 / 360),
              border: Border.all(
                  color: kPrimaryColor1,
                  width: SizeConfig.screenHeight * 0.2 / 640),
            ),
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
          SizedBox(
            height: SizeConfig.screenHeight * 20 / 640,
          ),
          ListTile(
            leading: Icon(
              Icons.school,
              size: SizeConfig.screenWidth * 25 / 360,
              color: Colors.black54,
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
          SizedBox(
            height: SizeConfig.screenHeight * 20 / 640,
          ),
          Container(
            height: SizeConfig.screenHeight * 150 / 640,
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.all(SizeConfig.screenWidth * 10 / 360),
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * 10 / 360),
            decoration: BoxDecoration(
                color: Color(0xffF5F5F5),
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenWidth * 10 / 360),
                border: Border.all(
                    color: kPrimaryColor1,
                    width: SizeConfig.screenHeight * 0.2 / 640)),
            child: Text(
              userData['bio'],
              style: TextStyle(
                fontSize: SizeConfig.screenWidth * 14 / 360,
                fontWeight: FontWeight.w300,
                color: kPrimaryColor1,
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
