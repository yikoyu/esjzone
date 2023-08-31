import 'package:get/get.dart';

import '../controllers/searching_controller.dart';

class SearchingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchingController>(
      () => SearchingController(),
    );
  }
}
