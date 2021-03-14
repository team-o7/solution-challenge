import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class UserListTile extends StatelessWidget {
  final String firstName, lastName, userName, dp;
  final Function onTap, onAddFriend;

  const UserListTile(
      {Key key,
      this.firstName,
      this.lastName,
      this.userName,
      this.dp,
      this.onTap,
      this.onAddFriend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CachedNetworkImage(
          imageUrl: dp,
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
        title: Text('$firstName $lastName'),
        subtitle: Text('@$userName'),
      ),
    );
  }
}
