import 'package:flutter/material.dart';

import '../constants.dart';
import '../sizeConfig.dart';

//used in authScreens
class AuthTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final int maxLength;

  const AuthTextField({Key key, this.hintText, this.onChanged, this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: kPrimaryColorLight,
      onChanged: onChanged,
      enabled: true, // to trigger disabledBorder
      decoration: InputDecoration(
          filled: true,
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
        letterSpacing: 1.5,
      ),
    );
  }
}
