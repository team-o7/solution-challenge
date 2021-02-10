import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final Icon suffixIcon;
  final double borderRadius;
  final TextEditingController controller;

  const RoundedTextField(
      {Key key,
      @required this.hintText,
      this.suffixIcon,
      this.borderRadius = 32,
      this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: kPrimaryColor0,
      controller: controller,
      decoration: InputDecoration(
          hoverColor: kPrimaryColor0,
          hintText: hintText,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor0, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor0, width: 4.0),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          suffixIcon: suffixIcon),
    );
  }
}

//TODO: topic search result tile. with title, description, option to join and other info
//TODO: peoples tile with an option to add friend.
