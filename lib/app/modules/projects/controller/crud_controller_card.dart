import 'package:aray/app/data/model/model_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardCRUDController {
  static Future<void> addNew(
      CollectionReference<CardModel> cardRef, CardModel card) async {
    await cardRef.add(card);
  }

  static Future<void> update(
      DocumentReference<CardModel> reference, String cardName) async {
    await reference.update({'name': cardName});
    await refreshUpdatedAt(reference);
  }

  static Future<void> refreshUpdatedAt(
      DocumentReference<CardModel> reference) async {
    await reference.update({'updated_at': Timestamp.fromDate(DateTime.now())});
  }
}
