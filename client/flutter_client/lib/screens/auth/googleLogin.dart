import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/services/authProvider.dart';
import 'package:provider/provider.dart';

class GoogleLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 20 / 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 32 / 360,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor0,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 5 / 640,
                  ),
                  Text(
                    'Sign in to continue your\nsensei account',
                    style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 22 / 360,
                      fontWeight: FontWeight.w300,
                      color: kPrimaryColor1,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 40 / 640,
                  ),
                  MaterialButton(
                    onPressed: () {
                      AuthProvider().signInWithGoogle().then((user) {
                        if (!user.additionalUserInfo.isNewUser) {
                          Provider.of<UiNotifier>(context, listen: false)
                              .setUserData()
                              .then((value) => Navigator.pushNamed(
                                  context, '/drawerHolder'));
                        } else {
                          Navigator.pushNamed(context, '/registration1');
                        }
                      }).catchError((e) {
                        print(e);
                      });
                    },
                    height: SizeConfig.screenHeight * 40 / 640,
                    color: kPrimaryColor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.screenWidth * 5 / 360),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.screenWidth * 5 / 360),
                          child: Image.asset(
                            'images/googleLogo.png',
                            height: SizeConfig.screenWidth * 25 / 360,
                            width: SizeConfig.screenWidth * 25 / 360,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: SizeConfig.screenWidth * 16 / 360,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 10 / 640,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
