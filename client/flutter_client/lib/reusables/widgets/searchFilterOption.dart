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
    return Expanded(
      child: Container(
        height: SizeConfig.screenHeight * 1 / 24,
        child: MaterialButton(
          elevation: 0,
          onPressed: onPressed,
          color: index ==
                  Provider.of<UiNotifier>(context, listen: true)
                      .searchFilterOptionIndex
              ? Colors.blueAccent
              : Colors.white,
          child: Text(
            label,
            style: TextStyle(
              color: index ==
                      Provider.of<UiNotifier>(context, listen: true)
                          .searchFilterOptionIndex
                  ? Colors.white
                  : Colors.blueGrey,
            ),
          ),
        ),
      ),
    );
  }
}
