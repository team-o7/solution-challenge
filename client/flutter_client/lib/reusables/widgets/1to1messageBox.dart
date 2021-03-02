import 'package:flutter/material.dart';

import '../constants.dart';

class OneToOneMessageBox extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isFile;
  static const senderPadding =
      EdgeInsets.only(left: 60, top: 10, right: 10, bottom: 10);
  static const receiverPadding =
      EdgeInsets.only(left: 10, top: 10, right: 60, bottom: 10);

  const OneToOneMessageBox(
      {Key key, @required this.message, @required this.isMe, this.isFile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe ? senderPadding : receiverPadding,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 2,
            borderRadius: BorderRadius.only(
                topLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                topRight: !isMe ? Radius.circular(12) : Radius.circular(0),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            color: isMe ? Colors.grey[200] : kPrimaryColorVeryLight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
