import 'package:aray/app/data/model/model_project.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ProjectGlobalController extends GetxController {
  static Future<String> getProjectCoverImageUrl(
      Project project, String projectId) async {
    final image = project.personalize['image'] as String;
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef
        .child('user/public/projects/project_$projectId/cover/$image');
    final imageUrl = await imageRef.getDownloadURL();
    return imageUrl;
  }

  void greeting() {}
}
