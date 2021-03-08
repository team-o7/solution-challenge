import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageHandler {
  FirebaseStorage storage = FirebaseStorage.instance;
  final storageReference = FirebaseStorage.instance.ref();

  Future<String> uploadDisplayImageToFireStorage(
      File file, String fileName) async {
    final reference = storageReference.child(fileName);
    final uploadTask = reference.putFile(file);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> downloadFile(String fileName, String dir, String url) async {
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      fileName: fileName,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    print('*************');
    print(dir);
    print('*************');
  }

  void chatFileUpload(
    File attachedFile,
    BuildContext context,
    DocumentReference reference,
    FirebaseAuth firebaseAuth,
  ) async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      attachedFile = File(result.files.single.path);

      if (attachedFile.lengthSync() > 10485760) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('ooPs!!!'),
            content: Text('You can not send file greater than 10 mb'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  attachedFile = null;
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // dismisses only the dialog and returns nothing
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        String fileNameInMessage = attachedFile.path.split('/').last;

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Send'),
            content: Text('You want to send the selected file?'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () async {
                  String fileNameInStorage =
                      "chatStorage/" + DateTime.now().toString();
                  print('****************');
                  print(attachedFile.path);
                  print('****************');

                  if (fileNameInStorage != null) {
                    StorageHandler()
                        .uploadDisplayImageToFireStorage(
                            attachedFile, fileNameInStorage)
                        .then(
                      (value) {
                        if (fileNameInMessage != null &&
                            fileNameInMessage != '') {
                          reference.collection('messages').add({
                            'msg': fileNameInMessage,
                            'isFile': true,
                            'sender': firebaseAuth.currentUser.uid,
                            'fileLink': value,
                            'timeStamp': DateTime.now()
                          });
                        }
                        attachedFile = null;
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    );
                  }
                },
                child: Text('yes'),
              ),
              MaterialButton(
                onPressed: () {
                  attachedFile = null;
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // dismisses only the dialog and returns nothing
                },
                child: Text('No'),
              ),
            ],
          ),
        );
      }
    } else {
      // User canceled the picker
    }
  }
}
