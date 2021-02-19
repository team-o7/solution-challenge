import 'package:flutter/material.dart';
import 'package:flutter_client/screens/DMscreen/chat.dart';
import 'package:flutter_client/screens/auth/googleLogin.dart';
import 'package:flutter_client/screens/auth/registration1.dart';
import 'package:flutter_client/screens/auth/registration2.dart';
import 'package:flutter_client/screens/channelChat/channelChat.dart';
import 'package:flutter_client/screens/mainScreen.dart';
import 'package:flutter_client/screens/profile/editProfile.dart';
import 'package:flutter_client/screens/profile/userProfile.dart';
import 'package:flutter_client/screens/welcome.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Welcome());
      case '/logIn':
        return MaterialPageRoute(
          builder: (_) => GoogleLogin(),
        );
      case '/registration1':
        return MaterialPageRoute(builder: (_) => Registration1());
      case '/registration2':
        return MaterialPageRoute(builder: (_) => Registration2());
      case '/drawerHolder':
        return MaterialPageRoute(builder: (_) => DrawerHolder());
      case '/userProfile':
        return MaterialPageRoute(builder: (_) => UserProfile());
      case '/editProfile':
        return MaterialPageRoute(builder: (_) => EditProfile());
      case '/chat':
        return MaterialPageRoute(builder: (_) => Chat());
      case '/channelChat':
        return MaterialPageRoute(
            builder: (_) => ChannelChat(
                  title: args,
                ));
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
