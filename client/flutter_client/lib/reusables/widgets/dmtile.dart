import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/screens/DMscreen/chat.dart';

import '../sizeConfig.dart';

class DmTile extends StatelessWidget {
  final String name, userName, dp;
  final DocumentReference reference;
  final String lastMsg;
  static int unSeenMsg = 0;

  const DmTile({
    Key key,
    this.name,
    this.lastMsg = '',
    this.userName,
    this.dp,
    this.reference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: reference
                .collection('messages')
                .orderBy('timeStamp', descending: true)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              // if (snapshot.hasData) {
              //   reference
              //       .collection('users')
              //       .where('uid',
              //           isEqualTo: FirebaseAuth.instance.currentUser.uid)
              //       .snapshots()
              //       .listen((value) {
              //     var lastActive = value.docs[0].data()['lastActive'];
              //     reference
              //         .collection('messages')
              //         .where('timeStamp', isGreaterThan: lastActive)
              //         .snapshots()
              //         .listen((event) {
              //       unSeenMsg = event.docs.length;
              //     });
              //   });
              // }
              return ListTile(
                  contentPadding: EdgeInsets.only(left: 12, right: 12, top: 1),
                  title: Text(name),
                  subtitle: Text(
                    snapshot.hasData ? snapshot.data.docs[0].data()['msg'] : '',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                            unSeenMsg == 0 ? FontWeight.w400 : FontWeight.w700),
                  ),
                  trailing: unSeenMsg == 0
                      ? null
                      : CircleAvatar(
                          maxRadius: 12,
                          backgroundColor: kPrimaryColor0,
                          child: Text(
                            unSeenMsg.toString(),
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                  leading: CachedNetworkImage(
                    imageUrl: dp == null ? '' : dp,
                    fadeInDuration: Duration(microseconds: 0),
                    fadeOutDuration: Duration(microseconds: 0),
                    imageBuilder: (context, imageProvider) => Container(
                      width: SizeConfig.screenWidth * 45 / 360,
                      height: SizeConfig.screenWidth * 45 / 360,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            SizeConfig.screenWidth * 4 / 360),
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
                        borderRadius: BorderRadius.circular(
                            SizeConfig.screenWidth * 5 / 360),
                        color: Color(0xffE5E5E5),
                      ),
                    ),
                  ),
                  onTap: () {
                    unSeenMsg = 0;
                    reference
                        .collection('users')
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .get()
                        .then((value) {
                      value.docs[0].reference
                          .update({'lastActive': DateTime.now()});
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Chat(
                                  name: name,
                                  reference: reference,
                                )));
                  });
            }),
        Divider(
          height: 1,
          thickness: 1,
        )
      ],
    );
  }
}
