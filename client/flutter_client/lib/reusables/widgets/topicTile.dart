import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TopicTile extends StatefulWidget {
  final bool isPrivate;
  final String title, description, creator, peoplesSize, dp;
  final int rating;

  const TopicTile(
      {Key key,
      this.isPrivate,
      this.dp,
      this.title,
      this.description,
      this.creator,
      this.rating,
      this.peoplesSize})
      : super(key: key);

  @override
  _TopicTileState createState() => _TopicTileState();
}

class _TopicTileState extends State<TopicTile> {
  static Map<String, dynamic> creatorData;

  void getCreator() async {
    creatorData = await DatabaseHandler().getUserDataByUid(widget.creator);
    setState(() {});
  }

  @override
  void initState() {
    getCreator();
    super.initState();
  }

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
                  widget.title,
                  style: TextStyle(
                      fontSize: SizeConfig.screenWidth * 30 / 360,
                      fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  widget.description,
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
                      '${widget.peoplesSize} peoples',
                    ),
                    RatingBarIndicator(
                      itemBuilder: (_, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      direction: Axis.horizontal,
                      rating: widget.rating.toDouble(),
                      itemSize: 18,
                      unratedColor: Colors.grey,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/userProfile',
                        arguments: creatorData);
                  },
                  child: Text(creatorData != null
                      ? '${creatorData['firstName']} ${creatorData['lastName']}'
                      : ''),
                ),
                trailing: SizedBox(
                  width: SizeConfig.screenWidth * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(!widget.isPrivate
                          ? Icons.public
                          : Icons.lock_outline),
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.1,
                      ),
                      MaterialButton(
                        color: Colors.grey[200],
                        child: Text(
                          !widget.isPrivate ? 'Join' : 'Request',
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
