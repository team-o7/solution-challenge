import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/widgets/ChatTextField.dart';

class ChannelChat extends StatelessWidget {
  final String title;

  const ChannelChat({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor0,
        title: Text('#$title'),
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
                children: [ChannelMessageBox()],
              )),
            ),
            ChatTextField()
          ],
        ),
      ),
    );
  }
}

class ChannelMessageBox extends StatelessWidget {
  const ChannelMessageBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('P'),
        radius: 12,
      ),
      title: Text(
        'Prakash Kumar',
        style: TextStyle(fontSize: 12),
      ),
      subtitle: Text('lorem ipsum dollar lawra lassun',
          style: TextStyle(fontSize: 15)),
      dense: true,
      minLeadingWidth: 13,
      horizontalTitleGap: 8,
    );
  }
}
