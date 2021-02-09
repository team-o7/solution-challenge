import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/1to1messageBox.dart';
import 'package:flutter_client/reusables/widgets/ChatTextField.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor0,
        title: Text('Karanjeet'),
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
                  OneToOneMessageBox(
                    message:
                        'bhai mera kat gya. uske bacche mujhe mama bula rha '
                        'lomdi sali 😒😒',
                    isMe: false,
                  ),
                  OneToOneMessageBox(
                    message: 'to mai kya kru bsdk 😂😂😂😂',
                    isMe: true,
                  )
                ],
              )),
            ),
            ChatTextField()
          ],
        ),
      ),
    );
  }
}
