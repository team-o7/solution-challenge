import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/progressIndicators.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/customCachedNetworkImage.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddPeoplesInPrivateChannel extends StatelessWidget {
  final DocumentReference reference;
  final String title;
  final List<dynamic> peoples;

  AddPeoplesInPrivateChannel(
      {Key key, this.reference, this.title, this.peoples})
      : super(key: key);

  DatabaseHandler _databaseHandler = new DatabaseHandler();

  FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor0,
        title: Text('Add peoples in $title'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ProgressIndicatorStatus>(context, listen: true)
            .channelAddPeople,
        child: StreamBuilder(
          stream:
              _databaseHandler.toAddPeoplesInPrivateChannel(context, peoples),
          // ignore: missing_return
          builder: (context, snapshot1) {
            if (!snapshot1.hasData) {
              return Container();
            }
            var docs = snapshot1.data.docs;
            if (docs.length == 0) {
              return Center(
                child: Text('There is no one to add'),
              );
            } else {
              List<FutureBuilder> tiles = [];
              for (var doc in docs) {
                String uid = doc.data()['uid'];
                FutureBuilder tile = new FutureBuilder(
                  future: _databaseHandler.getUserDataByUid(uid),
                  // ignore: missing_return
                  builder: (context, snapshot2) {
                    if (!snapshot2.hasData) {
                      return Container();
                    }
                    return UselessTile(
                      firstName: snapshot2.data['firstName'],
                      lastName: snapshot2.data['lastName'],
                      userName: snapshot2.data['userName'],
                      dp: snapshot2.data['dp'],
                      onPressed: () {
                        Provider.of<ProgressIndicatorStatus>(context,
                                listen: false)
                            .toggleChannelAddPeople();
                        var params = {
                          'topic':
                              Provider.of<UiNotifier>(context, listen: false)
                                  .leftNavIndex,
                          'channel': reference.id,
                          'access': 'readwrite',
                          'person': uid
                        };
                        var callable1 = _functions.httpsCallable(
                            'addInPrivaateChannel',
                            //don't correct spelling
                            options: HttpsCallableOptions(
                                timeout: Duration(seconds: 60)));
                        callable1.call(params).then((value) {
                          Provider.of<ProgressIndicatorStatus>(context,
                                  listen: false)
                              .toggleChannelAddPeople();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value.data)));
                        });
                      },
                    );
                  },
                );
                tiles.add(tile);
              }
              return Column(
                children: tiles,
              );
            }
          },
        ),
      ),
    );
  }
}

class UselessTile extends StatelessWidget {
  final String firstName, lastName, userName, dp;
  final Function onPressed;

  const UselessTile(
      {Key key,
      this.firstName,
      this.lastName,
      this.userName,
      this.dp,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomCachedNetworkImage(
        dp: dp,
      ),
      title: Text(firstName + ' ' + lastName),
      subtitle: Text(userName),
      trailing: TextButton(
        child: Text('Add'),
        onPressed: onPressed,
      ),
    );
  }
}
