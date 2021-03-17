import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/createTopicTextField.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_client/services/storageHandler.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

void createTopicBottomSheet(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: false,
    context: context,
    builder: (BuildContext context) {
      return CreateTopicModalSheet();
    },
  );
}

class CreateTopicModalSheet extends StatefulWidget {
  @override
  _CreateTopicModalSheetState createState() => _CreateTopicModalSheetState();
}

class _CreateTopicModalSheetState extends State<CreateTopicModalSheet> {
  static bool _isPrivate = false;
  String _title, _description, _dp;
  File imageFile;
  String imageName;
  bool isLoading = false;

  Widget myIndicator() {
    if (isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StatefulBuilder(
      builder: (context, setState) => Container(
        // height: SizeConfig.screenHeight,
        //todo: fix keyboard covering issue, height should remain low
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: AbsorbPointer(
            absorbing: isLoading,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 20 / 640,
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedFile = await ImagePicker()
                            .getImage(source: ImageSource.gallery);

                        if (pickedFile != null) {
                          imageFile = File(pickedFile.path);
                        } else {
                          return;
                        }
                      },
                      child: imageFile == null
                          ? Container(
                              child: CachedNetworkImage(
                                imageUrl: _dp == null ? " " : _dp,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: SizeConfig.screenWidth * 90 / 360,
                                  height: SizeConfig.screenWidth * 90 / 360,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.screenWidth * 5 / 360),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  child: Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 38,
                                  ),
                                  width: SizeConfig.screenWidth * 90 / 360,
                                  height: SizeConfig.screenWidth * 90 / 360,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.screenWidth * 5 / 360),
                                    color: Color(0xffE5E5E5),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: SizeConfig.screenWidth * 90 / 360,
                              height: SizeConfig.screenWidth * 90 / 360,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(imageFile),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.screenWidth * 5 / 360),
                              ),
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
                          imageName = "topicDP/" + DateTime.now().toString();

                          if (imageFile != null && isLoading == false) {
                            setState(() {
                              isLoading = true;
                            });
                            StorageHandler()
                                .uploadDisplayImageToFireStorage(
                                    imageFile, imageName)
                                .then((value) {
                              _dp = value;

                              setState(() {
                                isLoading = false;
                              });

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
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('There is an error')));
                              }
                            });
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
                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight * 100 / 640,
                  child: Center(child: myIndicator()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
