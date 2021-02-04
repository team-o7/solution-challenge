import 'package:flutter/material.dart';

import '../constants.dart';
import '../sizeConfig.dart';

//used in authScreens
class AuthTextField extends StatelessWidget {
  final String hintText;

  const AuthTextField({Key key, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true, // to trigger disabledBorder
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: kPrimaryColor1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: kPrimaryColor1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: kPrimaryColor1),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.screenWidth * 5 / 360)),
              borderSide: BorderSide(
                width: 1,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.screenWidth * 5 / 360)),
              borderSide: BorderSide(width: 1, color: Colors.black)),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: Colors.yellowAccent),
          ),
          hintText: hintText),
      style: TextStyle(
        fontSize: SizeConfig.screenWidth * 16 / 360,
        fontWeight: FontWeight.w400,
        color: kTextColor,
        letterSpacing: 1.5,
      ),
    );
  }
}
