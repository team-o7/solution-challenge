import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/authTextField.dart';
import 'package:flutter_client/reusables/widgets/dateOfBirth.dart';
import 'package:flutter_client/services/databaseHandler.dart';
import 'package:provider/provider.dart';

class Registration2 extends StatelessWidget {
  static String college;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 30 / 640,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 15 / 360),
                child: Text(
                  'Date of Birth',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 16 / 360,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor1,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 5 / 640,
              ),
              DobPicker(),
              SizedBox(
                height: SizeConfig.screenHeight * 15 / 640,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 15 / 360),
                child: Text(
                  'Add your Institution',
                  style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 16 / 360,
                    fontWeight: FontWeight.w400,
                    color: kPrimaryColor1,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 5 / 640,
              ),
              Container(
                  height: SizeConfig.screenHeight * 40 / 640,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 15 / 360),
                  child: AuthTextField(
                    hintText: 'College / University / Work Place',
                    onChanged: (val) {
                      val.trim();
                      college = val;
                    },
                  )),
              SizedBox(
                height: SizeConfig.screenHeight * 120 / 640,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 15 / 360),
                  child: MaterialButton(
                    onPressed: () async {
                      var dob =
                          Provider.of<UiNotifier>(context, listen: false).dob;
                      if (dob != null && college != null) {
                        try {
                          DatabaseHandler()
                              .addUserToDatabase(dob, college)
                              .then((value) => Navigator.pushNamed(
                                  context, '/drawerHolder'));
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(e)));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('There is an error')));
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
                        'Next',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
