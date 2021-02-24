import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopicTile extends StatelessWidget {
  final bool isPublic;

  const TopicTile({Key key, @required this.isPublic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: SizeConfig.screenHeight * 1 / 4.5,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '34 peoples',
                    ),
                    RatingBarIndicator(
                      itemBuilder: (_, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      direction: Axis.horizontal,
                      rating: 1,
                      itemSize: 18,
                      unratedColor: Colors.grey,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('By Karanjeet'),
                trailing: SizedBox(
                  width: SizeConfig.screenWidth * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(isPublic ? Icons.public : Icons.lock_outline),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.1,
                      ),
                      MaterialButton(
                        color: Colors.grey[200],
                        child: Text(
                          isPublic ? 'Join' : 'Request',
                          style: TextStyle(
                              color: kPrimaryColor0,
                              fontWeight: FontWeight.w400),
                        ),
                        minWidth: 40,
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenWidth * 35 / 360)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
