import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class MyIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;

  MyIcon({@required this.color, @required this.iconData});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.screenWidth * 30 / 360,
      width: SizeConfig.screenWidth * 30 / 360,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
