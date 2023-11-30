import 'package:aray/app/modules/projects/controller/controller_project_detail.dart';
import 'package:get/get.dart';

class ProjectDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectDetailController>(() => ProjectDetailController());
  }
}
