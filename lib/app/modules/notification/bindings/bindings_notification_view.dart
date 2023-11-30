import 'package:aray/app/modules/notification/controller/controller_notification.dart';
import 'package:get/get.dart';

class NotificationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<NotificationAnimationController>(
        () => NotificationAnimationController());
  }
}
