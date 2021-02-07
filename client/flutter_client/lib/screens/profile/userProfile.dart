import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stued/reusables/constants.dart';
import 'package:stued/reusables/sizeConfig.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: SizeConfig.screenWidth * 25 / 360,
            ),
            onPressed: () {}),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 5 / 640),
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 10 / 360),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Icon(
                    Icons.account_circle,
                    size: SizeConfig.screenWidth * 80 / 360,
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
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 20 / 360),
                    child: Text(
                      'Shubham Mandan',
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
                      '@mandanshimpi',
                      style: TextStyle(
                        fontSize: SizeConfig.screenWidth * 12 / 360,
                        fontWeight: FontWeight.w400,
                        color: kPrimaryColor1,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 65 / 360,
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
              'These are My Specifications',
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
