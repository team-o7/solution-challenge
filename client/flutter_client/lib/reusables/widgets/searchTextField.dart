import 'package:flutter/material.dart';

import '../constants.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: kPrimaryColor0,
      decoration: InputDecoration(
        hoverColor: kPrimaryColor0,
        hintText: 'Search',
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor0, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor0, width: 4.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        suffixIcon: Icon(
          Icons.search_outlined,
          color: kPrimaryColor0,
        ),
      ),
    );
  }
}

//TODO: topic search result tile. with title, description, option to join and other info
//TODO: peoples tile with an option to add friend.
