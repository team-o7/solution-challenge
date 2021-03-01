import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/screens/DMscreen/chat.dart';

import '../sizeConfig.dart';

class DmTile extends StatelessWidget {
  final String name, userName, dp;
  final DocumentReference reference;

  const DmTile({Key key, this.name, this.userName, this.dp, this.reference})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            contentPadding: EdgeInsets.only(left: 12, right: 12, top: 1),
            title: Text(name),
            subtitle: Text('@$userName'),
            leading: CachedNetworkImage(
              imageUrl: dp == null ? '' : dp,
              fadeInDuration: Duration(microseconds: 0),
              fadeOutDuration: Duration(microseconds: 0),
              imageBuilder: (context, imageProvider) => Container(
                width: SizeConfig.screenWidth * 45 / 360,
                height: SizeConfig.screenWidth * 45 / 360,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 4 / 360),
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
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 5 / 360),
                  color: Color(0xffE5E5E5),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Chat(
                            name: name,
                            reference: reference,
                          )));
            }),
        Divider(
          height: 1,
          thickness: 1,
        )
      ],
    );
  }
}
