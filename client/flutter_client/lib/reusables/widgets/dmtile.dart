import 'package:flutter/material.dart';

import '../constants.dart';

class DmTile extends StatelessWidget {
  const DmTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Text('Karanjeet'),
          trailing: Text('14m'),
          subtitle: Text('Last message'),
          leading: CircleAvatar(
            backgroundColor: kPrimaryColor1,
            child: Text('K'),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        )
      ],
    );
  }
}
