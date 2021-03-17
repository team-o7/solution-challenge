import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client/reusables/sizeConfig.dart';
import 'package:flutter_client/services/storageHandler.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class OneToOneMessageBox extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isFile;
  final String downloadUrl;
  final Timestamp time;
  static const senderPadding =
      EdgeInsets.only(left: 60, top: 0, right: 10, bottom: 2);
  static const receiverPadding =
      EdgeInsets.only(left: 10, top: 0, right: 60, bottom: 2);

  const OneToOneMessageBox(
      {Key key,
      @required this.message,
      @required this.isMe,
      this.isFile,
      this.time,
      this.downloadUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: isMe ? senderPadding : receiverPadding,
      child: isFile
          ? Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(6) : Radius.circular(0),
                      topRight: !isMe ? Radius.circular(6) : Radius.circular(0),
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                  color: isMe ? Colors.grey[200] : kPrimaryColorVeryLight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: isMe
                        ? Column(
                            children: [
                              Container(
                                width: 150,
                                height: 100,
                                child: Center(
                                  child: Icon(Icons.insert_drive_file_rounded),
                                ),
                              ),
                              Container(
                                width: SizeConfig.screenWidth * 150 / 360,
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
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
                                child: Container(
                                  width: 150,
                                  height: 100,
                                  child: Center(
                                    child:
                                        Icon(Icons.insert_drive_file_rounded),
                                  ),
                                ),
                              ),
                              Container(
                                width: SizeConfig.screenWidth * 150 / 360,
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '  ' +
                      DateFormat.Hm().format(time.toDate()).toString() +
                      '    ',
                  style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                )
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
                  color: isMe ? Colors.grey[200] : kPrimaryColorVeryLight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                          new ClipboardData(text: message),
                        ).then((_) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("copied to clipboard"),
                            ),
                          );
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Linkify(
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
                            style: TextStyle(color: Colors.black87),
                            linkStyle: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '  ' +
                      DateFormat.Hm().format(time.toDate()).toString() +
                      '    ',
                  style: TextStyle(
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                )
              ],
            ),
    );
  }
}
