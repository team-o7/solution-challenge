import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';
import 'package:flutter_client/reusables/widgets/searchFilterOption.dart';
import 'package:flutter_client/reusables/widgets/topicTile.dart';
import 'package:flutter_client/reusables/widgets/userListTile.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  static TextEditingController _controller;

  final GlobalKey<InnerDrawerState> innerDrawerKey;
  const Search({Key key, this.innerDrawerKey}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 5 / 360)),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 1 / 20,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SearchFilterOption(
                  label: 'Topics',
                  index: 0,
                  onPressed: () {
                    Provider.of<UiNotifier>(context, listen: false)
                        .setSearchFilterOptionIndex(0);
                  },
                ),
                SearchFilterOption(
                  label: 'Peoples',
                  index: 1,
                  onPressed: () {
                    Provider.of<UiNotifier>(context, listen: false)
                        .setSearchFilterOptionIndex(1);
                  },
                ),
              ],
            ),
          ),
          Provider.of<UiNotifier>(context, listen: true)
                      .searchFilterOptionIndex ==
                  1
              ? Users()
              : Topics()
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
    );
  }
}

class Users extends StatelessWidget {
  static DatabaseHandler databaseHandler = new DatabaseHandler();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseHandler.searchedUsers(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data?.docs;
          List<UserListTile> usersList = [];
          for (var user in users) {
            String firstName = user.data()['firstName'];
            String lastName = user.data()['lastName'];
            String dp = user.data()['dp'];
            String userName = user.data()['userName'];
            final userListTile = new UserListTile(
              firstName: firstName,
              lastName: lastName,
              dp: dp,
              userName: userName,
              onTap: () {
                Navigator.pushNamed(context, '/userProfile',
                    arguments: user.data());
              },
            );
            usersList.add(userListTile);
          }
          return Column(
            children: usersList,
          );
        } else
          return Container();
      },
    );
  }
}

class Topics extends StatelessWidget {
  static DatabaseHandler databaseHandler = new DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseHandler.searchedTopics(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          var topics = snapshot.data.docs;
          List<TopicTile> topicWidgets = [];
          for (var topic in topics) {
            var data = topic.data();
            String creator = data['creator'];
            String description = data['description'];
            String title = data['title'];
            String dp = data['dp'];
            String peoples = data['peoples'].length.toString();
            bool private = data['private'];
            int rating = data['avgRating'];
            TopicTile tile = new TopicTile(
              creator: creator,
              dp: dp,
              description: description,
              title: title,
              peoplesSize: peoples,
              isPrivate: private,
              rating: rating,
              onNameTap: () async {
                Navigator.pushNamed(context, '/userProfile',
                    arguments: await databaseHandler.getUserDataByUid(creator));
              },
            );
            topicWidgets.add(tile);
          }
          return Column(
            children: topicWidgets,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
