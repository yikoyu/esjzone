/*
 * @Date: 2023-08-15 15:10:16
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-31 14:50:32
 * @FilePath: \esjzone\lib\app\modules\profile\controllers\profile_controller.dart
 */
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:esjzone/app/utils/request/request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var email = ''.obs;
  var pwd = ''.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void getLoginAuthToken() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      debugPrint('email > ${email.value}');
      debugPrint('pwd > ${pwd.value}');

      EsjzoneHttp.login(email: email.value, pwd: pwd.value);
    }
  }

  Future<void> deleteAllCookie() async {
    HttpUtils.deleteAllCookie();

    Get
      ..closeAllSnackbars()
      ..snackbar('提示', '删除cookie成功');
  }
}
