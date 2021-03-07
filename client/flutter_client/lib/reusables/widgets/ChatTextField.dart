import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';

import '../constants.dart';
import '../sizeConfig.dart';

// ignore: must_be_immutable
class ChatTextField extends StatelessWidget {
  final DocumentReference reference;
  final String currentUser;
  final Function onPressedAttach;
  TextEditingController controller = new TextEditingController();
  String msg;

  ChatTextField(
      {Key key, this.reference, this.currentUser, this.onPressedAttach})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.085,
      // color: kPrimaryColorVeryLight,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: MaterialButton(
              color: kPrimaryColor0,
              child: Icon(
                Icons.attach_file_outlined,
                color: Colors.white,
              ),
              minWidth: SizeConfig.screenWidth * 10 / 360,
              onPressed: onPressedAttach,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 5 / 360)),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
            child: RoundedTextField(
              hintText: 'write your message',
              controller: controller,
              borderRadius: SizeConfig.screenWidth * 5 / 360,
              onChanged: (val) {
                val.trim();
                msg = val;
              },
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: MaterialButton(
              color: kPrimaryColor0,
              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
              minWidth: SizeConfig.screenWidth * 10 / 360,
              onPressed: () {
                if (msg != null && msg != '') {
                  reference.collection('messages').add({
                    'msg': msg,
                    'isFile': false,
                    'sender': currentUser,
                    'timeStamp': DateTime.now()
                  });
                  controller.clear();
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 5 / 360)),
            ),
          ),
        ],
      ),
    );
  }
}
