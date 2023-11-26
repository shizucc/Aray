import 'package:aray/app/data/model/model_project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectCRUDController {
  static Future<void> addNew(
      CollectionReference<Project> projectRef, Project project) async {
    await projectRef.add(project);
  }

  static Future<void> delete(DocumentReference<Project> reference) async {
    await reference.delete();
  }
}
