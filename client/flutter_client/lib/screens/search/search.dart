import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/progressIndicators.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/searchFilterOption.dart';
import 'package:flutter_client/reusables/widgets/topicTile.dart';
import 'package:flutter_client/reusables/widgets/userListTile.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  const Search({Key key, this.innerDrawerKey}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchKey;
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ModalProgressHUD(
        inAsyncCall: Provider.of<ProgressIndicatorStatus>(context, listen: true)
            .joinTopic,
        child: Scaffold(
          body: CustomScrollView(slivers: [
            SliverAppBar(
              // title: Text('search'),
              backgroundColor: kPrimaryColor0,
              title: Text('Search'),
              snap: false,
              floating: true,
              expandedHeight: 160.0,
              actions: [
                IconButton(
                    icon: Icon(Icons.message_rounded),
                    onPressed: () {
                      widget.innerDrawerKey.currentState
                          .open(direction: InnerDrawerDirection.end);
                    })
              ],
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  widget.innerDrawerKey.currentState
                      .open(direction: InnerDrawerDirection.start);
                },
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(110),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth * 10 / 360,
                          vertical: SizeConfig.screenHeight * 10 / 640),
                      child: Material(
                        child: TextField(
                          cursorColor: kPrimaryColor0,
                          controller: _controller,
                          onChanged: (val) {
                            searchKey = val.trim().toLowerCase();
                            setState(() {});
                          },
                          onEditingComplete: () {
                            searchKey = null;
                            _controller.clear();
                          },
                          decoration: InputDecoration(
                            hoverColor: kPrimaryColor0,
                            hintText: 'Search',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.screenWidth * 5 / 360)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor0, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.screenWidth * 5 / 360)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kPrimaryColor0, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SizeConfig.screenWidth * 5 / 360)),
                            ),
                            suffixIcon: Icon(
                              Icons.search,
                              color: kPrimaryColor1,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenWidth * 5 / 360)),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 1 / 20,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.screenWidth * 10 / 360,
                        ),
                        child: Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenWidth * 5 / 360)),
                          child: Row(
                            children: [
                              SearchFilterOption(
                                label: 'Topics',
                                index: 0,
                                onPressed: () {
                                  Provider.of<UiNotifier>(context,
                                          listen: false)
                                      .setSearchFilterOptionIndex(0);
                                },
                              ),
                              SearchFilterOption(
                                label: 'Peoples',
                                index: 1,
                                onPressed: () {
                                  Provider.of<UiNotifier>(context,
                                          listen: false)
                                      .setSearchFilterOptionIndex(1);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 1 / 60,
                    )
                  ],
                ),
              ),
            ),
            Provider.of<UiNotifier>(context, listen: true)
                        .searchFilterOptionIndex ==
                    1
                ? Users(searchKey: searchKey)
                : Topics(
                    searchKey: searchKey,
                  ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchKey = null;
    _controller.dispose();
    super.dispose();
  }
}

class Users extends StatelessWidget {
  static DatabaseHandler databaseHandler = new DatabaseHandler();

  final String searchKey;
  Users({this.searchKey = ' '});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseHandler.searchedUsers(searchKey),
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
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return usersList[index];
            }, childCount: usersList.length),
          );
        } else
          return SliverToBoxAdapter(child: Container());
      },
    );
  }
}

class Topics extends StatelessWidget {
  static DatabaseHandler databaseHandler = new DatabaseHandler();
  final String searchKey;

  const Topics({Key key, this.searchKey = ' '}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseHandler.searchedTopics(searchKey),
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
            double rating = data['avgRating'].toDouble();
            TopicTile tile = new TopicTile(
              creator: creator,
              dp: dp,
              description: description,
              title: title,
              peoplesSize: peoples,
              isPrivate: private,
              rating: rating,
              reference: topic.reference,
              onNameTap: () async {
                Navigator.pushNamed(context, '/userProfile',
                    arguments: await databaseHandler.getUserDataByUid(creator));
              },
            );
            topicWidgets.add(tile);
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return topicWidgets[index];
            }, childCount: topicWidgets.length),
          );
        } else {
          return SliverToBoxAdapter(child: Container());
        }
      },
    );
  }
}
