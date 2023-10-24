import 'package:get/get.dart';

class WorkspaceAnimationController extends GetxController {
  // Expansion Workspaces Panel List
  final _isOpen = <bool>[].obs;

  // Init _isOpen for each Panel
  bool isOpen() {
    final int length = _isOpen.length;
    return _isOpen[length];
  }

  // Switch
  void switchPanel(int i, bool isOpen) {
    _isOpen[i] = !isOpen;
  }
}
