import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';

class MyTopicTile extends StatelessWidget {
  final String title, description;
  final int noOfPeoples;
  final double rating;
  final bool isPrivate;

  const MyTopicTile(
      {Key key,
      this.title,
      this.description,
      this.noOfPeoples,
      this.rating,
      this.isPrivate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: SizeConfig.screenHeight * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 24 / 360,
                      fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  description,
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  '${noOfPeoples.toString()} peoples',
                ),
              ),
              Container(
                height: SizeConfig.screenHeight * 0.04,
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RatingBarIndicator(
                        itemBuilder: (_, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        direction: Axis.horizontal,
                        rating: rating,
                        itemSize: 18,
                        unratedColor: Colors.white,
                      ),
                      Icon(
                        isPrivate ? Icons.lock : Icons.public,
                        color: Colors.white,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
