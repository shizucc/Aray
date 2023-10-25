import 'package:get/get.dart';

class WorkspaceAnimationController extends GetxController {
  // Expansion Workspaces Panel List
  final _isOpen = <bool>[].obs;

  // Init _isOpen for each Panel
  void initIsOpen(int length) {
    for (int i = 0; i < length; i++) {
      _isOpen.add(true);
    }
  }

  bool isOpen(int index) {
    return _isOpen[index];
  }

  // Switch
  void switchPanel(int i, bool isOpen) {
    _isOpen[i] = isOpen;
  }
}
