import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/screens/profile/editProfile.dart';
import 'package:flutter_client/services/authProvider.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const Profile({Key key, @required this.innerDrawerKey}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _firstName, _lastName, _userName, _dp, _bio, _college;
  Timestamp _dob;
  List _friends, _topics, _requests;
  var refresh = false;

  void initData() {
    var data = Provider.of<UiNotifier>(context, listen: false).userData;
    print(data);
    _firstName = data['firstName'];
    _lastName = data['lastName'];
    _userName = data['userName'];
    _dp = data['dp'];
    _bio = data['bio'];
    _college = data['college'];
    _dob = data['dateOfBirth'];
    _friends = data['friends'];
    _requests = data['friendRequestsReceived'];
    _topics = data['topics'];
  }

  //todo: FUCKUP i have changed 'friendRequest' to 'friendRequestsReceived' in DS
  ///update any error as you see

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MainAppBar(
            innerDrawerKey: widget.innerDrawerKey,
            title: 'Profile',
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 5 / 640),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: kPrimaryColor1,
                  ),
                  onPressed: () async {
                    refresh = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfile(
                          dp: _dp,
                          userName: _userName,
                          firstName: _firstName,
                          lastName: _lastName,
                          bio: _bio,
                          college: _college,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: CachedNetworkImage(
                    imageUrl: _dp,
                    fadeInDuration: Duration(microseconds: 0),
                    fadeOutDuration: Duration(microseconds: 0),
                    imageBuilder: (context, imageProvider) => Container(
                      width: 120.0,
                      height: 120.0,
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
              height: SizeConfig.screenHeight * 10 / 640,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 15 / 360),
              child: Center(
                child: Text(
                  '$_firstName $_lastName',
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
                '@$_userName',
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
                color: Color(0x80F5F5F5),
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
                    count: _friends?.length.toString(),
                    onTap: () {
                      //todo:
                      print('Clicked on Friends');
                    },
                  ),
                  ProfileWidget0(
                    text: 'Topics',
                    count: _topics?.length.toString(),
                    onTap: () {
                      //todo:
                    },
                  ),
                  ProfileWidget0(
                    text: 'Requests',
                    count: _requests?.length.toString(),
                    onTap: () {
                      //todo:
                      print('Clicked on request');
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
                _college,
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
                _dob.toDate().toString(),
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            Container(
              height: SizeConfig.screenHeight * 80 / 640,
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
                _bio == '' ? 'Bio' : _bio,
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w300,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.nights_stay_outlined,
                size: SizeConfig.screenWidth * 25 / 360,
                color: Colors.black54,
              ),
              title: Text(
                'Night mode',
                style: TextStyle(
                  fontSize: SizeConfig.screenWidth * 14 / 360,
                  fontWeight: FontWeight.w500,
                  color: kPrimaryColor1,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                await AuthProvider().signOut();
                Navigator.pushNamed(context, '/logIn');
              },
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
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: countFontSize,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor1,
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
      ),
    );
  }
}
