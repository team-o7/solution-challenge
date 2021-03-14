import 'package:flutter/material.dart';

import '../../reusables/widgets/friendsListTile.dart';
import '../../services/databaseHandler.dart';

class Friends extends StatelessWidget {
  static DatabaseHandler databaseHandler = new DatabaseHandler();
  List<String> friendsList;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: databaseHandler.userFriends(friendsList),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final users = snapshot.data?.docs;
          List<FriendsListTile> friendsList = [];
          for (var user in users) {
            String firstName = user.data()['firstName'];
            String lastName = user.data()['lastName'];
            String dp = user.data()['dp'];
            String userName = user.data()['userName'];
            final userListTile = new FriendsListTile(
              firstName: firstName,
              lastName: lastName,
              dp: dp,
              userName: userName,
              onTap: () {
                Navigator.pushNamed(context, '/userProfile',
                    arguments: user.data());
              },
            );
            friendsList.add(userListTile);
          }
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: friendsList.length,
              itemBuilder: (_, index) => friendsList[index],
            ),
          );
        } else
          return Container();
      },
    );
  }
}
