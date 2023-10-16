import 'package:aray/app/modules/projects/controller/controller_project.dart';
import 'package:get/get.dart';

class ProjectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectController>(() => ProjectController());
  }
}
