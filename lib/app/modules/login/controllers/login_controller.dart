import 'package:esjzone/app/modules/home/controllers/home_controller.dart';
import 'package:esjzone/app/modules/index/controllers/index_controller.dart';
import 'package:esjzone/app/routes/app_pages.dart';
import 'package:esjzone/app/utils/esjzone/esjzone_http.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var email = ''.obs;
  var pwd = ''.obs;
  var loggingIn = false.obs;

  Future<void> getLoginAuthToken() async {
    if (loggingIn.value) return;

    if (formKey.currentState != null && formKey.currentState!.validate()) {
      debugPrint('email > ${email.value}');
      debugPrint('pwd > ${pwd.value}');

      try {
        loggingIn.value = true;
        bool isLogin =
            await EsjzoneHttp.login(email: email.value, pwd: pwd.value);
        loggingIn.value = false;

        if (isLogin) {
          Get.until((route) => Get.currentRoute == Routes.INDEX);

          IndexController indexController = Get.find<IndexController>();
          HomeController homeController = Get.find<HomeController>();

          indexController.onJumpTo(0, jump: true);
          homeController.onLoad();
        }
      } catch (e) {
        loggingIn.value = false;
      }
    }
  }
}
