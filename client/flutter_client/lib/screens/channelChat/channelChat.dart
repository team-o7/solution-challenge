import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/ChatTextField.dart';
import 'package:flutter_client/reusables/widgets/customCachedNetworkImage.dart';
import 'package:flutter_client/screens/home/body.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_client/services/storageHandler.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final String sender, msg, downloadUrl;
  final bool isFile;
  final Timestamp time;

  const ChannelMessageBox(
      {Key key,
      this.sender,
      this.isFile,
      this.msg,
      this.downloadUrl,
      this.time})
      : super(key: key);

  @override
  _ChannelMessageBoxState createState() => _ChannelMessageBoxState();
}

class _ChannelMessageBoxState extends State<ChannelMessageBox> {
  DatabaseHandler _databaseHandler = new DatabaseHandler();

  Color strToHex(String c) {
    try {
      return Color(StringToHex.toColor(c));
    } catch (e) {
      return Color(0xff000000);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _databaseHandler.getUserDataByUid(widget.sender),
      builder: (context, snapshot) => !snapshot.hasData
          ? Container()
          : ListTile(
              onLongPress: () {
                Clipboard.setData(
                  new ClipboardData(text: widget.msg),
                ).then((_) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("copied to clipboard"),
                    ),
                  );
                });
              },
              leading: CircleAvatar(
                backgroundColor: kPrimaryColor0,
                child: snapshot.hasData
                    ? CustomCachedNetworkImage(dp: snapshot.data['dp'])
                    : Text(
                        '',
                        style: TextStyle(fontSize: 12),
                      ),
                radius: 12,
              ),
              title: RichText(
                  text: TextSpan(
                      text: snapshot.hasData
                          ? snapshot.data['firstName'] +
                              ' ' +
                              snapshot.data['lastName'] +
                              '  '
                          : '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: strToHex(
                          snapshot.data['color'],
                        ),
                      ),
                      children: [
                    TextSpan(
                        text: DateFormat.jm()
                            .format(widget.time.toDate())
                            .toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: Colors.black45,
                        ))
                  ])),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 3),
                child: Linkify(
                  onOpen: (link) async {
                    if (await canLaunch(link.url)) {
                      await launch(
                        link.url,
                        enableJavaScript: true,
                      );
                    } else {
                      throw 'Could not launch $link';
                    }
                  },
                  text: widget.msg,
                  style: TextStyle(color: Colors.black87, fontSize: 15),
                  linkStyle: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              trailing: widget.isFile
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_circle_down_outlined,
                        color: Colors.black87,
                        size: 32,
                      ),
                      onPressed: () async {
                        var path =
                            await ExtStorage.getExternalStoragePublicDirectory(
                                ExtStorage.DIRECTORY_DOWNLOADS);

                        if (await FileSystemEntity.isFile(
                            path + '/' + widget.msg)) {
                          await OpenFile.open(path + '/' + widget.msg);
                        } else {
                          final status = await Permission.storage.request();
                          if (status.isGranted) {
                            final dir = await ExtStorage
                                .getExternalStoragePublicDirectory(
                                    ExtStorage.DIRECTORY_DOWNLOADS);
                            StorageHandler().downloadFile(
                                widget.msg, dir, widget.downloadUrl);
                          } else {
                            print('!!!!!!!!!!!!!!!!!!!!!!!!!');
                            print("Permission deined");
                            print('!!!!!!!!!!!!!!!!!!!!!!!!!');
                          }
                        }
                      },
                    )
                  : SizedBox(
                      width: 0,
                    ),
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
            String downloadUrl = data['fileLink'];
            Timestamp time = data['timeStamp'];
            ChannelMessageBox tile = new ChannelMessageBox(
              msg: msg,
              sender: sender,
              isFile: isFile,
              downloadUrl: downloadUrl,
              time: time,
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
