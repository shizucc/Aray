import 'package:aray/app/data/model/model_activity.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_activity_cover.dart';
import 'package:aray/app/modules/activity/controller/crud_controller_activity_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ActivityCRUDController {
  static Future<void> addNew(
      CollectionReference<Activity> activitiesRef, Activity activity) async {
    await activitiesRef.add(activity);
  }

  static Future<void> updateName(
      DocumentReference<Activity> reference, String name) async {
    await reference.update({'name': name});
  }

  static Future<void> updateDescription(
      DocumentReference<Activity> reference, String description) async {
    await reference.update({'description': description});
  }

  static Future<void> updateTimeStamp(DocumentReference<Activity> reference,
      DateTimeRange dateTimeRange) async {
    await reference.update({
      'timestamp': true,
      'start_time': dateTimeRange.start,
      'end_time': dateTimeRange.end
    });
  }

  static Future<void> delete(
      DocumentReference<Activity> reference, Reference storageReference) async {
    try {
      // Delete Cover First
      final coverRef = storageReference.child('/cover');
      final listActivityCover = await coverRef.listAll();
      print(listActivityCover.items);
      for (var coverRef in listActivityCover.items) {
        ActivityCoverCRUDController.deleteOnlyCover(coverRef);
      }

      // Delete File
      final filesRef = storageReference.child('/files');
      final listActivityFiles = await filesRef.listAll();
      for (var fileRef in listActivityFiles.items) {
        ActivityFileCRUDController.deleteOnlyFile(fileRef);
      }

      await reference.delete();
    } catch (e) {}
  }
}
