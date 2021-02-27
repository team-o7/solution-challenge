import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../sizeConfig.dart';

class SearchFilterOption extends StatelessWidget {
  final int index;
  final String label;
  final Function onPressed;

  const SearchFilterOption(
      {Key key,
      @required this.index,
      @required this.label,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 8 / 360),
      width: SizeConfig.screenWidth * 1 / 2.5,
      height: SizeConfig.screenHeight * 1 / 24,
      child: MaterialButton(
        elevation: 2,
        onPressed: onPressed,
        color: index ==
                Provider.of<UiNotifier>(context, listen: true)
                    .searchFilterOptionIndex
            ? kPrimaryColorVeryLight
            : Colors.grey[200],
        child: Text(label),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(SizeConfig.screenWidth * 25 / 360)),
      ),
    );
  }
}
