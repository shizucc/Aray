import 'package:aray/app/modules/activity/controller/controller_activity.dart';
import 'package:get/get.dart';

class ActivityBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityController>(() => ActivityController());
  }
}
