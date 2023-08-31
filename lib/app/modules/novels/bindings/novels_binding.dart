import 'package:get/get.dart';

import '../controllers/novels_controller.dart';

class NovelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NovelsController>(
      () => NovelsController(),
    );
  }
}
