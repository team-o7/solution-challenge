import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/customCachedNetworkImage.dart';
import 'package:flutter_client/screens/home/addPeoplesInPrivateChannel.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:provider/provider.dart';

class PeoplesInPrivateChannel extends StatelessWidget {
  final DocumentReference reference;
  final String title;

  const PeoplesInPrivateChannel({Key key, this.reference, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: kPrimaryColor0,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                var ss = await reference.get();
                List<dynamic> peoples = ss.data()['peoples'];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddPeoplesInPrivateChannel(
                              reference: reference,
                              title: title,
                              peoples: peoples,
                            )));
              }),
          SizedBox(
            width: 12,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: reference.collection('peoples').snapshots(),
              // ignore: missing_return
              builder: (context, snapshot1) {
                if (!snapshot1.hasData) {
                  return Container();
                }
                List<FutureBuilder> tiles = [];
                var docs = snapshot1.data.docs;
                for (var doc in docs) {
                  String uid = doc.data()['uid'];
                  String access = doc.data()['access'];
                  FutureBuilder tile = new FutureBuilder(
                    future: DatabaseHandler().getUserDataByUid(uid),
                    builder: (context, snapshot2) {
                      if (!snapshot2.hasData) {
                        return Container();
                      }
                      return ChannelSettingTile(
                        reference: reference,
                        title: title,
                        dp: snapshot2.data['dp'],
                        name: snapshot2.data['firstName'] +
                            ' ' +
                            snapshot2.data['lastName'],
                        uid: uid,
                        access: access,
                      );
                    },
                  );
                  tiles.add(tile);
                }
                return Column(
                  children: tiles,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Add more peoples'),
              onTap: () async {
                var ss = await reference.get();
                List<dynamic> peoples = ss.data()['peoples'];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddPeoplesInPrivateChannel(
                              reference: reference,
                              title: title,
                              peoples: peoples,
                            )));
              },
            )
          ],
        ),
      ),
    );
  }
}

class ChannelSettingTile extends StatelessWidget {
  final DocumentReference reference;
  final String title, dp, name, access, uid;

  const ChannelSettingTile(
      {Key key,
      this.reference,
      this.title,
      this.dp,
      this.name,
      this.access,
      this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CustomCachedNetworkImage(
        dp: dp,
      ),
      title: Text(name),
      subtitle: Text('access: $access'),
      onTap: () {
        bottomSheetForChannelSetting(
            context: context,
            ref: reference,
            title: title,
            person: uid,
            access: access);
      },
    );
  }
}

void bottomSheetForChannelSetting(
    {BuildContext context,
    DocumentReference ref,
    String person,
    String access,
    String title}) {
  FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');
  var callable1 = _functions.httpsCallable('updateAccessInPrivaateChannel',
      //don't correct spelling
      options: HttpsCallableOptions(timeout: Duration(seconds: 60)));

  var callable2 = _functions.httpsCallable('removeFromPrivaateChannel',
      options: HttpsCallableOptions(timeout: Duration(seconds: 60)));

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: Icon(Icons.wrap_text_outlined),
              title: Text('Toggle access'),
              onTap: () {
                var params = {
                  'topic': Provider.of<UiNotifier>(context, listen: false)
                      .leftNavIndex,
                  'channel': ref.id,
                  'access': access,
                  'person': person
                };
                callable1.call(params).then((value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.data)));
                });
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.remove_circle_outline),
              title: Text('Remove from $title'),
              onTap: () {
                var params = {
                  'topic': Provider.of<UiNotifier>(context, listen: false)
                      .leftNavIndex,
                  'channel': ref.id,
                  'person': person
                };
                callable2.call(params).then((value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(value.data)));
                });
              },
            ),
          ],
        );
      });
}
