import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/services/storageHandler.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class OneToOneMessageBox extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isFile;
  final String downloadUrl;
  static const senderPadding =
      EdgeInsets.only(left: 60, top: 5, right: 10, bottom: 5);
  static const receiverPadding =
      EdgeInsets.only(left: 10, top: 5, right: 60, bottom: 5);

  const OneToOneMessageBox(
      {Key key,
      @required this.message,
      @required this.isMe,
      this.isFile,
      this.downloadUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: isMe ? senderPadding : receiverPadding,
      child: isFile
          ? Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(6) : Radius.circular(0),
                      topRight: !isMe ? Radius.circular(6) : Radius.circular(0),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                  color: isMe ? Colors.grey[200] : Color(0xff3a6351),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: isMe
                        ? Column(
                            children: [
                              Container(
                                width: SizeConfig.screenWidth * 150 / 360,
                                height: SizeConfig.screenWidth * 100 / 360,
                                decoration: BoxDecoration(
                                    color: kPrimaryColorVeryLight,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Icon(
                                    Icons.file_copy,
                                    color: Colors.redAccent,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                width: SizeConfig.screenWidth * 150 / 360,
                                child: Text(message),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    var path = await ExtStorage
                                        .getExternalStoragePublicDirectory(
                                            ExtStorage.DIRECTORY_DOWNLOADS);

                                    if (await FileSystemEntity.isFile(
                                        path + '/' + message)) {
                                      await OpenFile.open(path + '/' + message);
                                    } else {
                                      final status =
                                          await Permission.storage.request();
                                      if (status.isGranted) {
                                        final dir = await ExtStorage
                                            .getExternalStoragePublicDirectory(
                                                ExtStorage.DIRECTORY_DOWNLOADS);
                                        StorageHandler().downloadFile(
                                            message, dir, downloadUrl);
                                      } else {
                                        print('!!!!!!!!!!!!!!!!!!!!!!!!!');
                                        print("Permission deined");
                                        print('!!!!!!!!!!!!!!!!!!!!!!!!!');
                                      }
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width:
                                            SizeConfig.screenWidth * 150 / 360,
                                        height:
                                            SizeConfig.screenWidth * 100 / 360,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColorVeryLight,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Center(
                                          child: Icon(
                                            Icons.file_copy,
                                            color: Colors.redAccent,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 2),
                                        width:
                                            SizeConfig.screenWidth * 150 / 360,
                                        child: Text(message),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(6) : Radius.circular(0),
                      topRight: !isMe ? Radius.circular(6) : Radius.circular(0),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                  color: isMe ? Colors.grey[200] : Color(0xff3a6351),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: GestureDetector(
                      onLongPress: () {
                        myBottomSheet(context, message);
                      },
                      child: Linkify(
                        onOpen: (link) async {
                          if (await canLaunch(link.url)) {
                            await launch(
                              link.url,
                              enableJavaScript: true,
                            );
                          } else {
                            throw 'Could not launch $link';
                          }
                        },
                        text: message,
                        style: TextStyle(
                            color: isMe ? Colors.black87 : Colors.grey[300]),
                        linkStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

void myBottomSheet(BuildContext context, String message) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.file_copy),
              title: Text('Copy Text'),
              onTap: () {
                Clipboard.setData(new ClipboardData(text: message)).then((_) {
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_rounded),
              title: Text('Delete Text'),
              onTap: () {
                //todo:
              },
            ),
          ],
        );
      });
}
