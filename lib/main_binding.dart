import 'package:get/get.dart';

import './app/controllers/login_user_controllers.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginUserController>(
      () => LoginUserController(),
    );
  }
}
