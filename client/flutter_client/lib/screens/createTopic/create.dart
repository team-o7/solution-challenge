import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/mainAppBar.dart';
import 'package:flutter_client/reusables/widgets/myTopicTile.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class CreateTopic extends StatefulWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const CreateTopic({Key key, @required this.innerDrawerKey}) : super(key: key);

  @override
  _CreateTopicState createState() => _CreateTopicState();
}

class _CreateTopicState extends State<CreateTopic> {
  static bool _isPrivate = false;
  String _title, _description, _dp = 'null';
  //todo: create link for dp

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: MainAppBar(
            innerDrawerKey: widget.innerDrawerKey,
            title: 'Your topics',
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create_outlined),
        tooltip: 'Create new topic',
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: false,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) => Container(
                  // height: SizeConfig.screenHeight,
                  //todo: fix keyboard covering issue, height should remain low
                  width: SizeConfig.screenWidth,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight * 40 / 640,
                        ),
                        Container(
                          height: SizeConfig.screenHeight * 75 / 640,
                          width: SizeConfig.screenHeight * 75 / 640,
                          decoration: BoxDecoration(
                            color: Color(0x80350D36),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.screenWidth * 10 / 360),
                          ),
                        ),
                        CreateTopicTextField(
                          hintText: 'Title',
                          maxLines: 1,
                          topMargin: SizeConfig.screenHeight * 25 / 640,
                          onChanged: (val) {
                            val.trim();
                            _title = val;
                          },
                        ),
                        CreateTopicTextField(
                          hintText: 'Description',
                          maxLines: 4,
                          topMargin: 0,
                          onChanged: (val) {
                            val.trim();
                            _description = val;
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            'Private',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: kTextColor,
                              letterSpacing: 1.5,
                            ),
                          ),
                          value: _isPrivate,
                          onChanged: (val) {
                            setState(() {
                              _isPrivate = val;
                            });
                          },
                          secondary: const Icon(Icons.lock_rounded),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: SizeConfig.screenWidth * 15 / 360,
                            right: SizeConfig.screenWidth * 15 / 360,
                            bottom: SizeConfig.screenHeight * 25 / 640,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              if (_title != null &&
                                  _title != '' &&
                                  _description != null &&
                                  _description != '') {
                                DatabaseHandler()
                                    .createTopic(
                                        _description, _title, _isPrivate, _dp)
                                    .then((value) {
                                  _description = null;
                                  _title = null;
                                  _isPrivate = false;
                                  _dp = null;
                                  Navigator.pop(context);
                                  //todo: bottomSheet should close after onTap
                                  // test this after commenting databseHandler call
                                  // don't create unneseary topics
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('There is an error')));
                              }
                            },
                            height: SizeConfig.screenHeight * 40 / 640,
                            color: kPrimaryColor1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.screenWidth * 5 / 360),
                            ),
                            child: Center(
                              child: Text(
                                'Create Topic',
                                style: TextStyle(
                                  fontSize: SizeConfig.screenWidth * 16 / 360,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      body: ListView(
        children: [
          MyTopicTile(size: size),
          MyTopicTile(size: size),
        ],
      ),
    );
  }
}

class CreateTopicTextField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final double topMargin;
  final Function(String) onChanged;

  CreateTopicTextField(
      {@required this.hintText,
      @required this.maxLines,
      this.topMargin,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: topMargin,
        left: SizeConfig.screenWidth * 15 / 360,
        right: SizeConfig.screenWidth * 15 / 360,
        bottom: SizeConfig.screenHeight * 10 / 640,
      ),
      child: TextField(
        maxLines: maxLines,
        onChanged: onChanged,
        enabled: true, // to trigger disabledBorder
        cursorColor: kPrimaryColor0,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            top: SizeConfig.screenHeight * 10 / 640,
            left: SizeConfig.screenWidth * 10 / 360,
            right: SizeConfig.screenWidth * 10 / 360,
          ),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: kPrimaryColor1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: kPrimaryColor1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: kPrimaryColor1),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.screenWidth * 5 / 360)),
              borderSide: BorderSide(
                width: 1,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeConfig.screenWidth * 5 / 360)),
              borderSide: BorderSide(width: 1, color: Colors.black)),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(SizeConfig.screenWidth * 5 / 360)),
            borderSide: BorderSide(width: 1, color: Colors.yellowAccent),
          ),
          hintText: hintText,
        ),
        style: TextStyle(
          fontSize: SizeConfig.screenWidth * 14 / 360,
          fontWeight: FontWeight.w400,
          color: kTextColor,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
