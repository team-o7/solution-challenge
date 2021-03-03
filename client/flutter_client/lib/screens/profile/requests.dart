import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:provider/provider.dart';

class Requests extends StatelessWidget {
  final List requests;

  const Requests({Key key, this.requests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Friend Request'),
          backgroundColor: kPrimaryColor0,
        ),
        body:
            Provider.of<UiNotifier>(context, listen: true).reqTiles.length == 0
                ? Center(
                    child: Text('You don\'t have any friend requests'),
                  )
                : ListView.builder(
                    itemCount: Provider.of<UiNotifier>(context, listen: true)
                        .reqTiles
                        .length,
                    itemBuilder: (context, index) {
                      return Provider.of<UiNotifier>(context, listen: true)
                          .reqTiles[index];
                    },
                  ));
  }
}

class RequestsTile extends StatelessWidget {
  final String uid;
  final int index;

  static FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  const RequestsTile({Key key, this.uid, this.index}) : super(key: key);

  Future<Widget> alert(BuildContext context, String name) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Respond to $name'),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenWidth * 10 / 360)),
            actions: [
              MaterialButton(
                  onPressed: () {
                    Map<String, dynamic> params = {'otherUid': uid};
                    var callable = _functions.httpsCallable(
                        'onFriendRequestDecline',
                        options: HttpsCallableOptions(
                            timeout: Duration(seconds: 60)));
                    //todo: circularProgressIndicator
                    callable.call(params).then((value) async {
                      await Provider.of<UiNotifier>(context, listen: false)
                          .setUserData();
                      Navigator.pop(context);
                      Provider.of<UiNotifier>(context, listen: false)
                          .removeReqTile(index);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value.data)));
                    });
                  },
                  child: Text('Decline')),
              MaterialButton(
                  onPressed: () {
                    Map<String, dynamic> params = {'otherUid': uid};
                    var callable = _functions.httpsCallable(
                        'onFriendRequestAccept',
                        options: HttpsCallableOptions(
                            timeout: Duration(seconds: 60)));
                    //todo: circularProgressIndicator
                    callable.call(params).then((value) async {
                      await Provider.of<UiNotifier>(context, listen: false)
                          .setUserData();
                      Provider.of<UiNotifier>(context, listen: false)
                          .removeReqTile(index);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value.data)));
                    });
                  },
                  child: Text('Accept')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHandler().getUserDataByUid(uid),
      builder: (context, snapshot) => Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: snapshot.hasData ? snapshot.data['dp'] : '',
              fadeInDuration: Duration(microseconds: 0),
              fadeOutDuration: Duration(microseconds: 0),
              imageBuilder: (context, imageProvider) => Container(
                width: SizeConfig.screenWidth * 45 / 360,
                height: SizeConfig.screenWidth * 45 / 360,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 4 / 360),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width: SizeConfig.screenWidth * 45 / 360,
                height: SizeConfig.screenWidth * 45 / 360,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 5 / 360),
                  color: Color(0xffE5E5E5),
                ),
              ),
            ),
            title: snapshot.hasData
                ? Text(snapshot.data['firstName'] +
                    ' ' +
                    snapshot.data['lastName'])
                : Text(''),
            subtitle:
                snapshot.hasData ? Text(snapshot.data['userName']) : Text(''),
            trailing: OutlineButton(
              child: Text('Respond'),
              disabledBorderColor: kPrimaryColor0,
              highlightedBorderColor: kPrimaryColor0,
              onPressed: () {
                alert(context,
                    snapshot.hasData ? snapshot.data['firstName'] : '');
              },
            ),
          ),
        ),
      ),
    );
  }
}
