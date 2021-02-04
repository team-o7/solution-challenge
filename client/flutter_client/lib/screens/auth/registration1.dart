import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/authTextField.dart';

class Registration1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 30 / 640,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 15 / 360),
              child: Center(
                child: Text(
                  'Create username',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 22 / 360,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor1,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 10 / 640,
            ),
            Container(
              child: Center(
                child: Text(
                  'You can always change it later',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 12 / 360,
                    fontWeight: FontWeight.w300,
                    color: kPrimaryColor1,
                  ),
                ),
              ),
            ),
            Container(
              height: SizeConfig.screenHeight * 40 / 640,
              margin: EdgeInsets.only(
                left: SizeConfig.screenWidth * 15 / 360,
                right: SizeConfig.screenWidth * 15 / 360,
                top: SizeConfig.screenHeight * 15 / 640,
                bottom: SizeConfig.screenHeight * 25 / 640,
              ),
              child: AuthTextField(hintText: 'Username'),
            ),
            Divider(
              color: kPrimaryColor1,
              thickness: SizeConfig.screenWidth * 1.5 / 360,
              indent: SizeConfig.screenWidth * 40 / 360,
              endIndent: SizeConfig.screenWidth * 40 / 360,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 25 / 640,
            ),
            Container(
                height: SizeConfig.screenHeight * 40 / 640,
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 15 / 360),
                child: AuthTextField(
                  hintText: 'First Name',
                )),
            SizedBox(
              height: SizeConfig.screenHeight * 10 / 640,
            ),
            Container(
                height: SizeConfig.screenHeight * 40 / 640,
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 15 / 360),
                child: AuthTextField(hintText: 'Last Name')),
            SizedBox(
              height: SizeConfig.screenHeight * 15 / 640,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 15 / 360),
              child: MaterialButton(
                onPressed: () {
                  //todo:
                },
                height: SizeConfig.screenHeight * 40 / 640,
                color: kPrimaryColor1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 5 / 360),
                ),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 16 / 360,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
