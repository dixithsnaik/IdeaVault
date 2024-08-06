import 'package:get/get.dart';

import 'package:note_app/controllers/note_controller.dart';

class AllBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteController>(() => NoteController());
  }
}
