import 'package:aray/app/modules/activity/controller/controller_activity_detail.dart';
import 'package:get/get.dart';

class ActivityDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActivityDetailController>(() => ActivityDetailController());
  }
}
