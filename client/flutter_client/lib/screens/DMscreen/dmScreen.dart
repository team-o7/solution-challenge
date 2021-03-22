import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/dmtile.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class DmScreen extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;
  static DatabaseHandler _databaseHandler = new DatabaseHandler();
  const DmScreen({Key key, this.innerDrawerKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor0,
          title: Text('DMs'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              innerDrawerKey.currentState
                  .close(direction: InnerDrawerDirection.end);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //12,12,16
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
                child: RoundedTextField(
                  hintText: 'search',
                  borderRadius: 5,
                  suffixIcon: Icon(
                    Icons.search_outlined,
                    color: kPrimaryColor0,
                  ),
                ),
              ),
              StreamBuilder(
                stream: _databaseHandler.myChats(),
                // ignore: missing_return
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  var docs = snapshot.data.docs;
                  if (docs.length == 0) {
                    return Column(children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.4,
                      ),
                      Text('Add friends to start chats with them'),
                    ]);
                  }
                  List<DmTile> dmTiles = [];
                  for (var doc in docs) {
                    var data = doc.data();
                    String otherGuy;
                    List users = data['users'];
                    if (users[0] ==
                        _databaseHandler.firebaseAuth.currentUser.uid)
                      otherGuy = users[1];
                    else
                      otherGuy = users[0];
                    var tileData = UiNotifier.allData[otherGuy];
                    DmTile newTile = new DmTile(
                      reference: doc.reference,
                      name: tileData['firstName'] + ' ' + tileData['lastName'],
                      userName: tileData['userName'],
                      dp: tileData['dp'],
                    );
                    dmTiles.add(newTile);
                  }
                  return Column(
                    children: dmTiles,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
