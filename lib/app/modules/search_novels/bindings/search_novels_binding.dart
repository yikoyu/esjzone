import 'package:get/get.dart';

import '../controllers/search_novels_controller.dart';

class SearchNovelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchNovelsController>(
      () => SearchNovelsController(),
    );
  }
}
