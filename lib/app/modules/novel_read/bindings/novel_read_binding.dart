import 'package:get/get.dart';

import '../controllers/novel_read_controller.dart';

class NovelReadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NovelReadController>(
      () => NovelReadController(),
    );
  }
}
