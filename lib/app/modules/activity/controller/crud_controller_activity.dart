import 'package:aray/app/data/model/model_activity.dart';
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
      await reference.delete();
      print(storageReference);
      final listActivityFiles = await storageReference.listAll();
      await Future.wait(listActivityFiles.items.map((item) => item.delete()));
      await storageReference.delete();
    } catch (e) {}
  }
}
