import 'package:aray/app/data/model/model_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistCRUDController {
  static Future<void> updateStatus(
      CollectionReference<Checklist> reference, String id, bool value) async {
    await reference.doc(id).update({'status': value});
  }

  static Future<void> updateName(
      CollectionReference<Checklist> reference, String id, String name) async {
    await reference.doc(id).update({'name': name});
  }

  static Future<void> addNew(CollectionReference<Checklist> reference) async {
    Map<String, dynamic> jsonChecklist = {
      'name': 'New Checklist',
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'status': false,
      'order': 1,
    };
    final Checklist checklist = Checklist.fromJson(jsonChecklist);
    await reference.add(checklist);
  }

  static Future<void> delete(
      CollectionReference<Checklist> reference, String id) async {
    await reference.doc(id).delete();
  }
}
