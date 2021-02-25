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
class EditProfile extends StatelessWidget {
  String dp, firstName, lastName, college, bio, userName;
  TextEditingValue firstNameTEV = TextEditingValue();

  bool userNameIsOkay = true;
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
              if (userNameIsOkay &&
                  userName != '' &&
                  firstName != '' &&
                  lastName != '' &&
                  college != '') {
                await DatabaseHandler().updateUserDatabase(data: {
                  'userName': userName,
                  'firstName': firstName,
                  'lastName': lastName,
                  'college': college,
                  'dp': dp,
                  'bio': bio
                }).then((value) =>
                    Provider.of<UiNotifier>(context, listen: false)
                        .setUserData()
                        .then((value) => Navigator.pop(context, true)));
              }
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                        String imageName =
                            DatabaseHandler().firebaseAuth.currentUser.uid;

                        final pickedFile = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        File image;

                        if (pickedFile != null) {
                          image = File(pickedFile.path);
                          StorageHandler()
                              .uploadDisplayImageToFireStorage(image, imageName)
                              .then((value) {
                            dp = value;
                          });
                          //todo: show circularprogress while image is uploading
                          //if submitted before upload finish then
                          // dp doesn't update in database
                        } else {
                          return;
                        }
                      },
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: dp,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) => Icon(
                            Icons.account_circle,
                            size: SizeConfig.screenWidth * 120 / 360,
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
              //todo: textField breaks on adding emoji, fix bugs in textfield
              labelText: 'Username',
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: userName,
                  selection: TextSelection.collapsed(offset: userName.length),
                ),
              ),
              onChanged: (val) async {
                userName = val.trim();
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
                Provider.of<UiNotifier>(context, listen: true).isUserNameOkay
                    ? ''
                    : 'Username already exists',
                style: TextStyle(color: Colors.red),
              ),
            ),
            EditProfileTextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: firstName,
                  selection: TextSelection.collapsed(offset: firstName.length),
                ),
              ),
              labelText: 'First Name',
              onChanged: (val) {
                firstName = val.trim();
              },
            ),
            EditProfileTextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: lastName,
                  selection: TextSelection.collapsed(offset: lastName.length),
                ),
              ),
              labelText: 'Last Name',
              onChanged: (val) {
                lastName = val.trim();
              },
            ),
            EditProfileTextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: college,
                  selection: TextSelection.collapsed(offset: college.length),
                ),
              ),
              labelText: 'College',
              onChanged: (val) {
                college = val.trim();
              },
            ),
            EditProfileTextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: bio,
                  selection: TextSelection.collapsed(offset: bio.length),
                ),
              ),
              labelText: 'Bio',
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              onChanged: (val) {
                bio = val.trim();
              },
            ),
          ],
        ),
      ),
    );
  }
}
