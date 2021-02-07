import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class Profile extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const Profile({Key key, @required this.innerDrawerKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MainAppBar(
            innerDrawerKey: innerDrawerKey,
            title: 'Profile',
          )),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 5 / 640),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Icon(
                      Icons.account_circle,
                      size: SizeConfig.screenWidth * 120 / 360,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 10 / 640,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 15 / 360),
              child: Center(
                child: Text(
                  'Shubham Mandan',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 22 / 360,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 5 / 640,
            ),
            Container(
              child: Text(
                '@mandanshimpi',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 12 / 360,
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor1,
                ),
              ),
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
                    count: '96',
                    onTap: () {
                      //todo:
                    },
                  ),
                  ProfileWidget0(
                    text: 'Channels',
                    count: '5',
                    onTap: () {
                      //todo:
                    },
                  ),
                  ProfileWidget0(
                    text: 'Requests',
                    count: '13',
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
                'Indian Institute of information Technology, Surat',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.celebration,
                size: SizeConfig.screenWidth * 25 / 360,
                color: Colors.black54,
              ),
              title: Text(
                '18 Novemeber, 2000',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person_outline,
                size: SizeConfig.screenWidth * 25 / 360,
                color: Colors.black54,
              ),
              title: Text(
                'Male',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.library_books_sharp,
                size: SizeConfig.screenWidth * 25 / 360,
                color: Colors.black54,
              ),
              title: Text(
                'About me',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            Container(
              height: SizeConfig.screenHeight * 100 / 640,
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
                'These are My Specifications',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w300,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: SizeConfig.screenWidth * 25 / 360,
                color: Colors.black54,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
          ],
        ),
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
