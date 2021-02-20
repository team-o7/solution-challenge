import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/editProfileTextField.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EditProfile extends StatelessWidget {
  String dp, firstName, lastName, college, bio, userName;
  TextEditingController controller1 = new TextEditingController();
  TextEditingController controller3 = new TextEditingController();
  TextEditingController controller2 = new TextEditingController();
  TextEditingController controller4 = new TextEditingController();
  TextEditingController controller5 = new TextEditingController();

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
                Stack(
                  children: [
                    InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        print('Change your photo');
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: CachedNetworkImage(
                            imageUrl: dp,
                            placeholder: (context, url) => Icon(
                              Icons.account_circle,
                              size: SizeConfig.screenWidth * 120 / 360,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: SizeConfig.screenHeight * 10 / 640,
                      right: SizeConfig.screenWidth * 18 / 360,
                      child: Icon(
                        Icons.camera_alt,
                        color: kPrimaryColor1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            EditProfileTextField(
              //todo: cursor is at start, should be at end
              //todo: textField breaks on adding emoji, fix bugs in textfield
              labelText: 'Username',
              controller: controller1..text = userName,
              onChanged: (val) async {
                userName = val.trim();
                userNameIsOkay =
                    await Provider.of<UiNotifier>(context, listen: false)
                        .getUserNameNotExist(val);
                print(userNameIsOkay);
              },
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 20 / 640,
              //todo: fix alignment to start
              child: Text(
                Provider.of<UiNotifier>(context, listen: true).isUserNameOkay
                    ? ''
                    : 'Username already exists',
                style: TextStyle(color: Colors.red),
              ),
            ),
            EditProfileTextField(
              controller: controller2..text = firstName,
              labelText: 'First Name',
              onChanged: (val) {
                firstName = val.trim();
              },
            ),
            EditProfileTextField(
              controller: controller3..text = lastName,
              labelText: 'Last Name',
              onChanged: (val) {
                lastName = val.trim();
              },
            ),
            EditProfileTextField(
              controller: controller4..text = college,
              labelText: 'College',
              onChanged: (val) {
                college = val.trim();
              },
            ),
            EditProfileTextField(
              controller: controller5..text = bio,
              labelText: 'Bio',
              onChanged: (val) {
                bio = val.trim();
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 10 / 640),
            Row(
              //todo: replace these buttons with better buttons
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  color: Colors.black26,
                  onPressed: () {},
                  child: Text('Cancel'),
                ),
                MaterialButton(
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
                        'bio': bio
                      });
                      Navigator.pop(context);
                    }
                  },
                  color: kPrimaryColor0,
                  child: Text(
                    'Apply',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
