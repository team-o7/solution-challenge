import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';
import 'package:flutter_client/reusables/widgets/topicTile.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

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
              SizedBox(
                height: SizeConfig.screenHeight * 1 / 20,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SearchFilterOption(
                      label: 'Topics',
                      index: 1,
                      onPressed: () {
                        Provider.of<UiNotifier>(context, listen: false)
                            .setSearchFilterOptionIndex(1);
                      },
                    ),
                    SearchFilterOption(
                      label: 'Peoples',
                      index: 2,
                      onPressed: () {
                        Provider.of<UiNotifier>(context, listen: false)
                            .setSearchFilterOptionIndex(2);
                      },
                    ),
                  ],
                ),
              ),
              TopicTile(
                isPublic: true,
              ),
              UserListTile(),
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

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/userProfile');
          },
          leading: CircleAvatar(
            backgroundColor: kPrimaryColor0,
            child: Text(
              'S',
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text('Shubham Mandan'),
          subtitle: Text('@mandanshimpi'),
          trailing: MaterialButton(
            onPressed: () {},
            child: Text('Add Friend'),
          ),
        ),
      ),
    );
  }
}

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
