import 'package:get/get.dart';

import '../controllers/novel_detail_controller.dart';

class NovelDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NovelDetailController>(
      () => NovelDetailController(),
    );
  }
}
