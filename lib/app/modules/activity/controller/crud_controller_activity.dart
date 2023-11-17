import 'package:aray/app/data/model/model_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityCRUDController {
  static Future<void> updateName(
      DocumentReference<Activity> reference, String name) async {
    await reference.update({'name': name});
  }

  static Future<void> updateDescription(
      DocumentReference<Activity> reference, String description) async {
    await reference.update({'description': description});
  }
}
