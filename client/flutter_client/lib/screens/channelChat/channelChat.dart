import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/ChatTextField.dart';
import 'package:flutter_client/screens/home/body.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:provider/provider.dart';

class ChannelChat extends StatefulWidget {
  final String title;
  final DocumentReference reference;
  final Channel channel;

  ChannelChat({Key key, this.title, this.reference, this.channel})
      : super(key: key);

  @override
  _ChannelChatState createState() => _ChannelChatState();
}

class _ChannelChatState extends State<ChannelChat> {
  bool hasWriteAccess = true;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getAccess() {
    if (widget.channel == Channel.privateChannels) {
      widget.reference
          .collection('peoples')
          .where('uid', isEqualTo: firebaseAuth.currentUser.uid)
          .get()
          .then((value) {
        var data = value.docs[0].data();
        hasWriteAccess = data['access'] == 'readwrite' ? true : false;
        setState(() {});
      });
    }

    if (widget.channel == Channel.adminChannels) {
      firestore
          .collection('topics')
          .doc(Provider.of<UiNotifier>(context, listen: false).leftNavIndex)
          .collection('peoples')
          .where('uid', isEqualTo: firebaseAuth.currentUser.uid)
          .get()
          .then((value) {
        var data = value.docs[0].data();
        hasWriteAccess = data['access'] != 'general' ? true : false;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    getAccess();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor0,
          title: Text('# ${widget.title}'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                    child: Column(
                  children: [
                    ChannelChatStream(
                      reference: widget.reference,
                    ),
                  ],
                )),
              ),
              //todo: fix this
              hasWriteAccess
                  ? ChatTextField(
                      reference: widget.reference,
                      currentUser: firebaseAuth.currentUser.uid,
                    )
                  : Container(
                      color: Colors.black26,
                      height: 32,
                      child: Center(
                          child: Text(
                        'You Don\'t have access to send msg',
                        style: TextStyle(fontSize: 18),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class ChannelMessageBox extends StatefulWidget {
  final String sender, msg;
  final bool isFile;

  const ChannelMessageBox({Key key, this.sender, this.isFile, this.msg})
      : super(key: key);

  @override
  _ChannelMessageBoxState createState() => _ChannelMessageBoxState();
}

class _ChannelMessageBoxState extends State<ChannelMessageBox> {
  DatabaseHandler _databaseHandler = new DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseHandler.getUserDataByUid(widget.sender),
      builder: (context, snapshot) => ListTile(
        leading: CircleAvatar(
          backgroundColor: kPrimaryColor0,
          child: Text(
            snapshot.hasData ? snapshot.data['firstName'][0] : '',
            style: TextStyle(fontSize: 12),
          ),
          radius: 12,
        ),
        title: Text(
          snapshot.hasData ? snapshot.data['firstName'] : '',
          style: TextStyle(fontSize: 12),
        ),
        subtitle: Text(widget.msg, style: TextStyle(fontSize: 15)),
        dense: true,
        minLeadingWidth: 13,
        horizontalTitleGap: 8,
      ),
    );
  }
}

class ChannelChatStream extends StatelessWidget {
  final DocumentReference reference;

  const ChannelChatStream({Key key, this.reference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: reference
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.hasData) {
          var docs = snapshot.data.docs;
          List<ChannelMessageBox> tiles = [];
          for (var doc in docs) {
            var data = doc.data();
            String msg = data['msg'];
            String sender = data['sender'];
            bool isFile = data['isFile'];
            ChannelMessageBox tile = new ChannelMessageBox(
              msg: msg,
              sender: sender,
              isFile: isFile,
            );
            tiles.add(tile);
          }
          return Expanded(
              child: ListView.builder(
            reverse: true,
            itemCount: tiles.length,
            itemBuilder: (context, index) {
              return tiles[index];
            },
          ));
        }
      },
    );
  }
}
