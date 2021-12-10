import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_client/reusables/sizeConfig.dart';

final Color kPrimaryColor0 = Colors.deepPurpleAccent;
final Color kPrimaryColor1 = kPrimaryColor0;
const Color kPrimaryColorLight = Colors.deepPurple;
Color kPrimaryColorVeryLight = Colors.deepPurple[400];
const Color kTextColor = Color(0xff1D1C1D);

const kBottomNavLabelTextStyle = TextStyle(
  fontWeight: FontWeight.w400,
);

RoundedRectangleBorder kRoundedRectangleShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(SizeConfig.screenWidth * 5 / 360));

const List<String> titleColors = [
  "0xffef5350",
  "0xffec407a",
  "0xffab47bc",
  "0xff039be5",
  "0xff43a047",
  "0xffc0ca33",
  "0xffff8f00",
];
