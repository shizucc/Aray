import 'dart:io';

import 'package:aray/app/data/model/model_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ActivityCoverCRUDController {
  static Future<void> upload(DocumentReference<Activity> activityRef,
      Reference activityCoverStorageRef, File file) async {
    try {
      final String fileName = file.path.split('/').last;
      final Reference activityCoverUploadStorageRef =
          activityCoverStorageRef.child(fileName);
      await activityCoverUploadStorageRef.putFile(
          file,
          SettableMetadata(
            contentType: "image/jpeg",
          ));
    } catch (e) {}
  }
}
