import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';

class EditProfileTextField extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final int maxLength;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const EditProfileTextField({
    Key key,
    this.labelText,
    this.onChanged,
    this.maxLength,
    this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth * 15 / 360,
          vertical: SizeConfig.screenHeight * 5 / 640),
      child: TextField(
        cursorColor: kPrimaryColorLight,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        controller: controller,
        enabled: true,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor1, width: 1.5),
          ),
          labelStyle: TextStyle(
            fontSize: SizeConfig.screenWidth * 14 / 360,
            fontWeight: FontWeight.w400,
          ),
          labelText: labelText,
        ),
        style: TextStyle(
          fontSize: SizeConfig.screenWidth * 14 / 360,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
