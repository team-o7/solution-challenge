import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/1to1messageBox.dart';
import 'package:flutter_client/reusables/widgets/ChatTextField.dart';
import 'package:flutter_client/services/storageHandler.dart';

// ignore: must_be_immutable
class Chat extends StatelessWidget {
  final DocumentReference reference;
  final String name;
  File attachedFile;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Chat({Key key, @required this.reference, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor0,
          title: Text(name),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreamBuilder(
                      stream: reference
                          .collection('messages')
                          .orderBy('timeStamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        } else {
                          var data = snapshot.data.docs;
                          List<OneToOneMessageBox> messages = [];
                          for (var doc in data) {
                            String msg = doc.data()['msg'];
                            String sender = doc.data()['sender'];
                            bool isFile = doc.data()['isFile'];
                            String fileLink = doc.data()['fileLink'];
                            OneToOneMessageBox box = new OneToOneMessageBox(
                              message: msg,
                              isMe: firebaseAuth.currentUser.uid == sender,
                              isFile: isFile,
                              downloadUrl: fileLink,
                            );
                            messages.add(box);
                          }
                          return Expanded(
                              child: ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return messages[index];
                            },
                          ));
                        }
                      },
                    ),
                  ],
                )),
              ),
              ChatTextField(
                reference: reference,
                currentUser: firebaseAuth.currentUser.uid,
              )
            ],
          ),
        ),
      ),
    );
  }
}
