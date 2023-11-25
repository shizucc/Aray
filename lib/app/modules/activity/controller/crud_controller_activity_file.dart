import 'dart:io';
import 'package:aray/app/data/model/model_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityFileCRUDController {
  // Firebase Firestore CRUD Handling
  static Future<void> addNew(CollectionReference<FileModel> activityFileRef,
      String fileName, String url) async {
    FileModel file =
        FileModel(name: fileName, url: url, createdAt: DateTime.now());
    await activityFileRef.add(file);
  }

  static Future<void> delete(
      CollectionReference<FileModel> activityFileRef, String id) async {
    await activityFileRef.doc(id).delete();
  }

  // Cloud File Storage Handling
  static Future<void> uploadFiles(
    List<File> files,
    CollectionReference<FileModel> activityFileRef,
    Reference storageReference,
  ) async {
    for (var file in files) {
      try {
        final String fileName = file.path.split('/').last;
        final Reference activityFileStorageRef =
            storageReference.child(fileName);
        await activityFileStorageRef.putFile(file);

        // Get url for each file
        final String activityFileUrl =
            await activityFileStorageRef.getDownloadURL();

        // Add New Filetile to FireStore
        await addNew(activityFileRef, fileName, activityFileUrl);
      } catch (e) {}
    }
  }

  static Future<void> deleteFile(String id, Reference activityFileStorageRef,
      CollectionReference<FileModel> activityFileRef) async {
    try {
      await activityFileStorageRef.delete();
    } catch (e) {}
    await delete(activityFileRef, id);
  }

  static Future<void> download(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> deleteOnlyFile(Reference activityFileStorageRef) async {
    try {
      await activityFileStorageRef.delete();
    } catch (e) {}
  }
}
