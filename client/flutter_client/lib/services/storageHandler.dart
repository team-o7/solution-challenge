import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'databaseHandler.dart';

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
}
