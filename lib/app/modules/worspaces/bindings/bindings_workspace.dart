import 'package:aray/app/modules/worspaces/controller/controller_workspace.dart';
import 'package:get/get.dart';

class WorkspaceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkspaceController>(() => WorkspaceController());
  }
}
