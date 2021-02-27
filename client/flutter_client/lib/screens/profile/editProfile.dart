import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/editProfileTextField.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:flutter_client/services/storageHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  String dp, firstName, lastName, college, bio, userName;

  EditProfile(
      {Key key,
      this.dp,
      this.firstName,
      this.lastName,
      this.college,
      this.bio,
      this.userName})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingValue firstNameTEV = TextEditingValue();
  File imageFile;
  String imageName;
  bool userNameIsOkay = true;
  bool isLoading = false;

  Widget myIndicator() {
    if (isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: kPrimaryColor1,
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.green,
            ),
            onPressed: () async {
              String imageName = "profileImage/" +
                  DatabaseHandler().firebaseAuth.currentUser.uid;

              if (imageFile != null && isLoading == false) {
                setState(() {
                  isLoading = true;
                });
                StorageHandler()
                    .uploadDisplayImageToFireStorage(imageFile, imageName)
                    .then((value) {
                  widget.dp = value;

                  setState(() {
                    isLoading = false;
                  });

                  if (userNameIsOkay &&
                      widget.userName != '' &&
                      widget.firstName != '' &&
                      widget.lastName != '' &&
                      widget.college != '') {
                    DatabaseHandler().updateUserDatabase(data: {
                      'userName': widget.userName,
                      'firstName': widget.firstName,
                      'lastName': widget.lastName,
                      'college': widget.college,
                      'dp': widget.dp,
                      'bio': widget.bio
                    }).then((value) =>
                        Provider.of<UiNotifier>(context, listen: false)
                            .setUserData()
                            .then((value) => Navigator.pop(context, true)));
                  }
                });
              } else {
                if (userNameIsOkay &&
                    widget.userName != '' &&
                    widget.firstName != '' &&
                    widget.lastName != '' &&
                    widget.college != '') {
                  DatabaseHandler().updateUserDatabase(data: {
                    'userName': widget.userName,
                    'firstName': widget.firstName,
                    'lastName': widget.lastName,
                    'college': widget.college,
                    'dp': widget.dp,
                    'bio': widget.bio
                  }).then((value) =>
                      Provider.of<UiNotifier>(context, listen: false)
                          .setUserData()
                          .then((value) => Navigator.pop(context, true)));
                } else {
                  Navigator.pop(context);
                  //todo: show error msg
                }
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfig.screenHeight * 20 / 640),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          customBorder: CircleBorder(),
                          onTap: () async {
                            final pickedFile = await ImagePicker()
                                .getImage(source: ImageSource.gallery);

                            if (pickedFile != null) {
                              imageFile = File(pickedFile.path);
                            } else {
                              print('No image selected.');
                              return;
                            }
                          },
                          child: imageFile == null
                              ? Container(
                                  child: CachedNetworkImage(
                                    imageUrl: widget.dp,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: SizeConfig.screenWidth * 100 / 360,
                                      height:
                                          SizeConfig.screenWidth * 100 / 360,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => Icon(
                                      Icons.account_circle,
                                      size: SizeConfig.screenWidth * 120 / 360,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: SizeConfig.screenWidth * 100 / 360,
                                  height: SizeConfig.screenWidth * 100 / 360,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 5 / 640),
                        Text(
                          'Change Profile Photo',
                          style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 16 / 360,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                EditProfileTextField(
                  labelText: 'Username',
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: widget.userName,
                      selection: TextSelection.collapsed(
                          offset: widget.userName.length),
                    ),
                  ),
                  onChanged: (val) async {
                    widget.userName = val.trim();
                    userNameIsOkay =
                        await Provider.of<UiNotifier>(context, listen: false)
                            .getUserNameNotExist(val);
                    print(userNameIsOkay);
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 15 / 360),
                  width: SizeConfig.screenWidth,
                  child: Text(
                    Provider.of<UiNotifier>(context, listen: true)
                            .isUserNameOkay
                        ? ''
                        : 'Username already exists',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                EditProfileTextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: widget.firstName,
                      selection: TextSelection.collapsed(
                          offset: widget.firstName.length),
                    ),
                  ),
                  labelText: 'First Name',
                  onChanged: (val) {
                    widget.firstName = val.trim();
                  },
                ),
                EditProfileTextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: widget.lastName,
                      selection: TextSelection.collapsed(
                          offset: widget.lastName.length),
                    ),
                  ),
                  labelText: 'Last Name',
                  onChanged: (val) {
                    widget.lastName = val.trim();
                  },
                ),
                EditProfileTextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: widget.college,
                      selection: TextSelection.collapsed(
                          offset: widget.college.length),
                    ),
                  ),
                  labelText: 'College',
                  onChanged: (val) {
                    widget.college = val.trim();
                  },
                ),
                EditProfileTextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: widget.bio,
                      selection:
                          TextSelection.collapsed(offset: widget.bio.length),
                    ),
                  ),
                  labelText: 'Bio',
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onChanged: (val) {
                    widget.bio = val.trim();
                  },
                ),
              ],
            ),
            Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: Center(
                child: myIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
