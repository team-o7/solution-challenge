import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/progressIndicators.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/customCachedNetworkImage.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class TopicRequestsStream extends StatefulWidget {
  final List<dynamic> reqs;

  static FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');

  const TopicRequestsStream({Key key, @required this.reqs}) : super(key: key);

  @override
  _TopicRequestsStreamState createState() => _TopicRequestsStreamState();
}

class _TopicRequestsStreamState extends State<TopicRequestsStream> {
  @override
  Widget build(BuildContext context) {
    return widget.reqs.length == 0
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor0,
              title: Text('Requests'),
            ),
            body: Center(
              child: Text('There are no requests'),
            ),
          )
        : ModalProgressHUD(
            inAsyncCall:
                Provider.of<ProgressIndicatorStatus>(context, listen: true)
                    .topicRequestRespond,
            child: StreamBuilder(
              stream: DatabaseHandler().topicJoinRequests(widget.reqs),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                final users = snapshot.data?.docs;
                List<TopicRequestsTile> usersList = [];
                for (var user in users) {
                  String firstName = user.data()['firstName'];
                  String lastName = user.data()['lastName'];
                  String dp = user.data()['dp'];
                  String userName = user.data()['userName'];
                  String uid = user.data()['uid'];
                  final userListTile = new TopicRequestsTile(
                    firstName: firstName,
                    lastName: lastName,
                    dp: dp,
                    userName: userName,
                    uid: uid,
                    onRespond: () {
                      Provider.of<ProgressIndicatorStatus>(context,
                              listen: false)
                          .toggleTopicRequestRespond();
                      var params = {
                        'id': Provider.of<UiNotifier>(context, listen: false)
                            .leftNavIndex,
                        'useruid': uid
                      };
                      TopicRequestsStream._functions
                          .httpsCallable('onRequestAccept')
                          .call(params)
                          .then((value) {
                        widget.reqs.remove(uid);
                        Provider.of<ProgressIndicatorStatus>(context,
                                listen: false)
                            .toggleTopicRequestRespond();

                        setState(() {});
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(value.data)));
                      });
                    },
                  );
                  usersList.add(userListTile);
                }
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: kPrimaryColor0,
                    title: Text('Requests'),
                  ),
                  body: ListView(
                    children: usersList,
                  ),
                );
              },
            ),
          );
  }
}

class TopicRequestsTile extends StatelessWidget {
  final String firstName, dp, lastName, userName, uid;
  final Function onRespond;

  const TopicRequestsTile(
      {Key key,
      this.firstName,
      this.dp,
      this.lastName,
      this.userName,
      this.onRespond,
      this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: ListTile(
          leading: CustomCachedNetworkImage(dp: dp),
          title: Text(firstName + ' ' + lastName),
          subtitle: Text(userName),
          trailing: OutlineButton(
            child: Text('Accept'),
            disabledBorderColor: kPrimaryColor0,
            highlightedBorderColor: kPrimaryColor0,
            onPressed: onRespond,
          ),
        ),
      ),
    );
  }
}
