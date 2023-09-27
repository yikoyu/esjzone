import 'package:esjzone/app/controllers/login_user_controllers.dart';
import 'package:esjzone/app/modules/login/views/login_view.dart';
import 'package:esjzone/app/utils/app_storage.dart';
import 'package:esjzone/app/utils/app_temp_size.dart';
import 'package:esjzone/app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/setting_novel_category.dart';

class SettingsController extends GetxController {
  AppStorage<String> likeCategoryStorageController =
      AppStorage<String>(AppStorageKeys.settingLikeNovelCategory);
  LoginUserController login = Get.find<LoginUserController>();

  var tempSize = '0.00M'.obs;
  var version = "".obs;
  var appName = "".obs;
  var likeCategory = CategoryLabel.all.obs;

  @override
  Future<void> onInit() async {
    getSize();
    initPackageInfo();
    CategoryLabel? likeCategoryStorage =
        stringToCategoryLabel(likeCategoryStorageController.read());
    if (likeCategoryStorage != null) {
      likeCategory.value = likeCategoryStorage;
    }
    super.onInit();
  }

  /// 获取包信息
  Future<void> initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version.value = 'v${packageInfo.version}';
    appName.value = packageInfo.appName;
  }

  /// 获取缓存大小
  Future<void> getSize() async {
    tempSize.value = await AppTempSize.size();
  }

  /// 清空所有缓存
  void clearTemp() {
    Get.defaultDialog(
        title: '温馨提示',
        middleText: '是否所有清除缓存？',
        textCancel: '取消',
        textConfirm: '确认',
        onConfirm: () async {
          await AppTempSize.delete();
          getSize();
          Get.back();
        });
  }

  /// 设置分类偏好
  void setLikeNovelCategory(CategoryLabel categoryLabel) {
    likeCategory.value = categoryLabel;
    Get.back();
  }

  /// 打开分类偏好选择
  void toNovelCategory() {
    Get.bottomSheet(SettingNovelCategory(onTap: setLikeNovelCategory),
        backgroundColor: Get.isDarkMode ? Colors.black87 : Colors.white);
  }

  /// 打开 github
  void toGithub() async {
    launchUrl(Uri.parse('https://github.com/yikoyu/esjzone'),
        mode: LaunchMode.externalApplication);
  }

  void tologin() {
    Get.to(() => const LoginView());
  }
}
