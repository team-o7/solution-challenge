import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';

class MyTopicTile extends StatelessWidget {
  const MyTopicTile({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: size.height * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                title: Text(
                  'Machine Learning',
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 30 / 360,
                      fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  'Learn and play with machine learning with me.'
                  'my ML Models can even train a dog',
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.share_outlined,
                    size: 34,
                  ),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  '34 peoples',
                ),
              ),
              Container(
                height: size.height * 0.04,
                color: kPrimaryColor0,
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
                        rating: 1,
                        itemSize: 18,
                        unratedColor: Colors.white,
                      ),
                      Icon(
                        Icons.lock,
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
