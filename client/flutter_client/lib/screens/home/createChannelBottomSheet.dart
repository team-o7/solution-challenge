import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client/notifiers/uiNotifier.dart';
import 'package:flutter_client/reusables/constants.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/reusables/widgets/createTopicTextField.dart';
import 'package:provider/provider.dart';

import 'body.dart';

void bottomSheetForChannelCreate(BuildContext context, Channel channel) {
  FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'us-central1');
  var callable1 = _functions.httpsCallable('createPublicChannel',
      options: HttpsCallableOptions(timeout: Duration(seconds: 60)));
  var callable2 = _functions.httpsCallable('createPrivateChannel',
      options: HttpsCallableOptions(timeout: Duration(seconds: 60)));

  String title;

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            // padding: EdgeInsets.only(
            //     bottom: MediaQuery.of(context).viewInsets.bottom),
            height: 200,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CreateTopicTextField(
                    hintText: 'Title',
                    maxLines: 1,
                    topMargin: SizeConfig.screenHeight * 25 / 640,
                    onChanged: (val) {
                      title = val.trim();
                    },
                  ),
                  Container(
                      height: SizeConfig.screenHeight * 1 / 18,
                      margin: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 15 / 360,
                        right: SizeConfig.screenWidth * 15 / 360,
                        bottom: SizeConfig.screenHeight * 10 / 640,
                      ),
                      child: MaterialButton(
                          textColor: Colors.white,
                          color: kPrimaryColor0,
                          child: Text('Create'),
                          onPressed: () async {
                            if (title != null && title != '') {
                              var params = {
                                'id': Provider.of<UiNotifier>(context,
                                        listen: false)
                                    .leftNavIndex,
                                'title': title
                              };
                              if (channel == Channel.publicChannels) {
                                await callable1.call(params).then((value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value.data)));
                                });
                              } else {
                                await callable2.call(params).then((value) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value.data)));
                                });
                              }
                            }
                          })),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth * 15 / 360,
                        top: SizeConfig.screenHeight * 5 / 640),
                    child: channel == Channel.publicChannels
                        ? Text(
                            'Everyone in the topic will have access to public channels.',
                            style: TextStyle(color: Colors.black45),
                          )
                        : Text(
                            'You can add peoples in private channel after creating.',
                            style: TextStyle(color: Colors.black45),
                          ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
