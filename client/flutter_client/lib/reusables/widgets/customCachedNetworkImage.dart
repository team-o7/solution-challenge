import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../sizeConfig.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    Key key,
    @required this.dp,
  }) : super(key: key);

  final String dp;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: dp,
      fadeInDuration: Duration(microseconds: 0),
      fadeOutDuration: Duration(microseconds: 0),
      imageBuilder: (context, imageProvider) => Container(
        width: SizeConfig.screenWidth * 45 / 360,
        height: SizeConfig.screenWidth * 45 / 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.screenWidth * 4 / 360),
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
          borderRadius: BorderRadius.circular(SizeConfig.screenWidth * 5 / 360),
          color: Color(0xffE5E5E5),
        ),
      ),
    );
  }
}
