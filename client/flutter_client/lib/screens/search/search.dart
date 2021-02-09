import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';
import 'package:flutter_client/reusables/widgets/topicTile.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class Search extends StatelessWidget {
  static TextEditingController _controller;

  final GlobalKey<InnerDrawerState> innerDrawerKey;
  const Search({Key key, this.innerDrawerKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: MainAppBar(
                innerDrawerKey: innerDrawerKey,
                title: 'Search',
              )),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 10 / 360,
                    vertical: SizeConfig.screenHeight * 10 / 640),
                child: Material(
                  child: RoundedTextField(
                    controller: _controller,
                    hintText: 'search',
                    suffixIcon: Icon(
                      Icons.search_outlined,
                      color: kPrimaryColor0,
                    ),
                    borderRadius: SizeConfig.screenWidth * 5 / 360,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          SizeConfig.screenWidth * 5 / 360)),
                ),
              ),
              TopicTile(
                isPublic: true,
              ),
              TopicTile(
                isPublic: false,
              ),
              TopicTile(
                isPublic: true,
              ),
              TopicTile(
                isPublic: false,
              ),
              TopicTile(
                isPublic: true,
              ),
              TopicTile(
                isPublic: false,
              ),
              TopicTile(
                isPublic: true,
              ),
              TopicTile(
                isPublic: false,
              ),
              TopicTile(
                isPublic: true,
              ),
              TopicTile(
                isPublic: false,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.search_outlined,
            ),
            onPressed: () {
              //TODO: should work as tapping on textField
            },
          ),
        ));
  }
}
