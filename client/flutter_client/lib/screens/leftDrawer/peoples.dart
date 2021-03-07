import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/customCachedNetworkImage.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:provider/provider.dart';

class PeoplesInChannelTile extends StatelessWidget {
  final String dp, firstName, lastName, userName, trailing;
  final Function onPressed, onLongPress;

  const PeoplesInChannelTile({
    Key key,
    this.dp,
    this.firstName,
    this.lastName,
    this.userName,
    this.onPressed,
    this.onLongPress,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: ListTile(
          leading: CustomCachedNetworkImage(
            dp: dp,
          ),
          title: Text(firstName + ' ' + lastName),
          subtitle: Text('@' + userName),
          onTap: onPressed,
          onLongPress: onLongPress,
          trailing: Text(trailing),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PeoplesInTopicStream extends StatelessWidget {
  DatabaseHandler _databaseHandler = new DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseHandler.firestore
          .collection('topics')
          .doc(Provider.of<UiNotifier>(context, listen: false).leftNavIndex)
          .collection('peoples')
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot1) {
        if (!snapshot1.hasData) {
          return Container();
        }
        var docs = snapshot1.data.docs;
        List<FutureBuilder> tiles = [];
        for (var doc in docs) {
          var data = doc.data();
          String uid = data['uid'];
          String access = data['access'];
          FutureBuilder tile = new FutureBuilder(
            future: _databaseHandler.getUserDataByUid(uid),
            // ignore: missing_return
            builder: (context, snapshot2) {
              if (!snapshot2.hasData) {
                return Container();
              }
              var newData = snapshot2.data;
              return PeoplesInChannelTile(
                dp: newData['dp'],
                firstName: newData['firstName'],
                lastName: newData['lastName'],
                userName: newData['userName'],
                trailing: access == 'general' ? '' : access,
                onPressed: () {
                  Navigator.pushNamed(context, '/userProfile',
                      arguments: newData);
                },
              );
            },
          );
          tiles.add(tile);
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor0,
            title: Text('peoples'),
          ),
          body: tiles.length == 0
              ? Center(
                  child: Text("There is no one"),
                )
              : ListView(
                  children: tiles,
                ),
        );
      },
    );
  }
}
