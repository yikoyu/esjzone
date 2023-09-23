import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../widgets/setting_list_tile.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(children: _buildList()),
    );
  }

  List<Widget> _buildList() {
    return [
      SettingListTile(
        title: '分类偏好',
        trailingTextWidget:
            Obx(() => Text(controller.likeCategory.value.label.tr)),
        onTap: controller.toNovelCategory,
      ),
      SettingListTile(
          title: '清除缓存',
          trailingTextWidget: Obx(() => Text(controller.tempSize.value)),
          onTap: controller.clearTemp),
      SettingListTile(title: '关于应用', onTap: toAboutApp),
      SettingListTile(
          title: '开源地址',
          trailingText: 'yikoyu/esjzone',
          onTap: controller.toGithub),
      const SettingListTile(
        title: '节点选择',
        trailingText: 'esjzone.com',
      ),
      SettingListTile(
          title: '检查更新',
          border: false,
          trailingTextWidget: Obx(() => Text(controller.version.value))),
      Container(height: 8),
      Obx(() => SettingListTile(
          title: controller.login.isLogin.value ? '切换账号' : '登录账号',
          titleTextAlign: TextAlign.center,
          titleTextStyle:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          border: false,
          showTrailing: false,
          onTap: controller.tologin)),
    ];
  }

  toAboutApp() {
    Get.dialog(AboutDialog(
      applicationIcon: const FlutterLogo(),
      applicationVersion: controller.version.value,
      applicationName: controller.appName.value,
      applicationLegalese:
          'copyright © 2023-latest ${controller.appName.value}',
    ));
  }
}
