import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      EdgeInsets.only(left: 60, top: 10, right: 10, bottom: 10);
  static const receiverPadding =
      EdgeInsets.only(left: 10, top: 10, right: 60, bottom: 10);

  const OneToOneMessageBox(
      {Key key,
      @required this.message,
      @required this.isMe,
      this.isFile,
      this.downloadUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe ? senderPadding : receiverPadding,
      child: isFile
          ? Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                      topRight:
                          !isMe ? Radius.circular(12) : Radius.circular(0),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  color: isMe ? Colors.grey[200] : kPrimaryColorVeryLight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: isMe
                        ? Row(
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                  color: Colors.black87,
                                ),
                              ),
                              (downloadUrl != null && downloadUrl != '')
                                  ? Icon(Icons.check_circle)
                                  : CircularProgressIndicator(),
                            ],
                          )
                        : Row(
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
                                    //abc
                                  }
                                },
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_circle_down),
                                onPressed: () async {
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
                                },
                              )
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
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                      topLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                      topRight:
                          !isMe ? Radius.circular(12) : Radius.circular(0),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
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
                        style: TextStyle(color: Colors.black87),
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
