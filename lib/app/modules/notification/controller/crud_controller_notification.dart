import 'package:aray/app/data/model/model_invitation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationCRUDController {
  static Future<void> addNew(
      CollectionReference<Invitation> ref, Invitation invitation) async {
    await ref.add(invitation);
  }

  static Future<void> delete(DocumentReference<Invitation> ref) async {
    await ref.delete();
  }

  static Future<void> changeStatus(
      DocumentReference<Invitation> ref, String status) async {
    await ref.update({'status': status});
  }

  static Future<void> reject(DocumentReference<Invitation> ref) async {
    await changeStatus(ref, 'decline');
  }

  static Future<void> accept(DocumentReference<Invitation> ref) async {
    await changeStatus(ref, 'accept');
  }
}
