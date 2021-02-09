import 'package:flutter/material.dart';
import 'package:flutter_client/reusables/widgets/roundedTextField.dart';

import '../constants.dart';
import '../sizeConfig.dart';

class ChatTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.055,
      // color: kPrimaryColorVeryLight,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: MaterialButton(
              color: kPrimaryColor0,
              child: Icon(
                Icons.attach_file_outlined,
                color: Colors.white,
              ),
              minWidth: 20,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 35 / 360)),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
            child: RoundedTextField(
              hintText: 'write your message',
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: MaterialButton(
              color: kPrimaryColor0,
              child: Icon(
                Icons.send_outlined,
                color: Colors.white,
              ),
              minWidth: 20,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth * 35 / 360)),
            ),
          ),
        ],
      ),
    );
  }
}
