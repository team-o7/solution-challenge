import 'package:flutter/material.dart';

import '../constants.dart';
import '../sizeConfig.dart';

class CreateTopicTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final double topMargin;
  final Function(String) onChanged;

  CreateTopicTextField(
      {@required this.hintText,
      @required this.maxLines,
      this.topMargin,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
        left: SizeConfig.screenWidth * 15 / 360,
        right: SizeConfig.screenWidth * 15 / 360,
        bottom: SizeConfig.screenHeight * 10 / 640,
      ),
      child: TextField(
        maxLines: maxLines,
        onChanged: onChanged,
        enabled: true, // to trigger disabledBorder
        cursorColor: kPrimaryColor0,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            top: SizeConfig.screenHeight * 10 / 640,
            left: SizeConfig.screenWidth * 10 / 360,
            right: SizeConfig.screenWidth * 10 / 360,
          ),
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
          hintText: hintText,
        ),
        style: TextStyle(
          fontSize: SizeConfig.screenWidth * 14 / 360,
          fontWeight: FontWeight.w400,
          color: kTextColor,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
