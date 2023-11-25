import 'dart:io';

import 'package:aray/app/data/model/model_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ActivityCoverCRUDController {
  // Firebase Firestore CRUD Handling
  static Future<void> addNew(DocumentReference<Activity> activityRef,
      String fileName, String url) async {
    await activityRef.update({'cover_name': fileName, 'cover_url': url});
  }

  static Future<void> delete(DocumentReference<Activity> activityRef) async {
    await activityRef.update({'cover_name': '', 'cover_url': ''});
  }

  // Cloud File Storage Handling
  static Future<void> uploadCover(DocumentReference<Activity> activityRef,
      Reference activityCoverStorageRef, File file) async {
    print(activityRef.id);
    try {
      final String fileName = file.path.split('/').last;
      final Reference activityCoverUploadStorageRef =
          activityCoverStorageRef.child(fileName);
      await activityCoverUploadStorageRef.putFile(
          file,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
      final coverUrl = await activityCoverUploadStorageRef.getDownloadURL();

      await addNew(activityRef, fileName, coverUrl);
    } catch (e) {}
  }

  static Future<void> deleteCover(
    DocumentReference<Activity> activityRef,
    Reference activityCoverStorageRef,
  ) async {
    try {
      await deleteOnlyCover(activityCoverStorageRef);
      await delete(activityRef);
    } catch (e) {}
  }

  static Future<void> deleteOnlyCover(Reference activityCoverStorageRef) async {
    try {
      await activityCoverStorageRef.delete();
    } catch (e) {}
  }
}
