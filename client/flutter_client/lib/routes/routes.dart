import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/screens/auth/googleLogin.dart';
import 'package:flutter_client/screens/auth/registration1.dart';
import 'package:flutter_client/screens/auth/registration2.dart';
import 'package:flutter_client/screens/channelChat/channelChat.dart';
import 'package:flutter_client/screens/leftDrawer/invitePage.dart';
import 'package:flutter_client/screens/mainScreen.dart';
import 'package:flutter_client/screens/profile/editProfile.dart';
import 'package:flutter_client/screens/profile/requests.dart';
import 'package:flutter_client/screens/profile/userProfile.dart';
import 'package:flutter_client/screens/welcome.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => Welcome());
      case '/logIn':
        return CupertinoPageRoute(
          builder: (_) => GoogleLogin(),
        );
      case '/registration1':
        return CupertinoPageRoute(builder: (_) => Registration1());
      case '/registration2':
        return CupertinoPageRoute(builder: (_) => Registration2());
      case '/drawerHolder':
        return CupertinoPageRoute(builder: (_) => DrawerHolder());
      case '/invitePage':
        return CupertinoPageRoute(builder: (_) => InvitePage());
      // case '/userProfile':
      //   return MaterialPageRoute(builder: (_) => UserProfile());
      case '/editProfile':
        return CupertinoPageRoute(builder: (_) => EditProfile());
      case '/profile/requests':
        return CupertinoPageRoute(
            builder: (_) => Requests(
                  requests: args,
                ));
      case '/userProfile':
        return CupertinoPageRoute(
            builder: (_) => UserProfile(
                  userData: args,
                ));
      case '/channelChat':
        return CupertinoPageRoute(
            builder: (_) => ChannelChat(
                  title: args,
                ));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
