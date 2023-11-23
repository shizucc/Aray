import 'package:aray/app/data/model/model_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
}
