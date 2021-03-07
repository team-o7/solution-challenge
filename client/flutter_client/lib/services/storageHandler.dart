import 'dart:io';

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
}
