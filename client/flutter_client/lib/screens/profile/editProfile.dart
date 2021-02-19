import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/dateOfBirth.dart';
import 'package:flutter_client/reusables/widgets/editProfileDobPicker.dart';
import 'package:flutter_client/reusables/widgets/editProfileTextField.dart';

class EditProfile extends StatelessWidget {
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
                          child: Icon(
                            Icons.account_circle,
                            color: Colors.black54,
                            size: SizeConfig.screenWidth * 120 / 360,
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
              labelText: 'Username',
            ),
            SizedBox(height: SizeConfig.screenHeight * 20 / 640),
            EditProfileTextField(
              labelText: 'First Name',
            ),
            EditProfileTextField(
              labelText: 'Last Name',
            ),
            EditProfileTextField(
              labelText: 'Institution',
            ),
            EditProfileTextField(
              labelText: 'Bio',
            ),
            SizedBox(height: SizeConfig.screenHeight * 10 / 640),
            Text(
              'Your DOB',
              style: TextStyle(
                fontSize: SizeConfig.screenWidth * 16 / 360,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor1,
              ),
            ),
            EdDobPicker()
          ],
        ),
      ),
    );
  }
}
