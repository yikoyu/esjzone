/*
 * @Date: 2023-08-15 15:10:16
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-31 14:46:14
 * @FilePath: \esjzone\lib\app\modules\profile\views\profile_view.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:esjzone/app/utils/app_theme_data.dart';

import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildLoginForm(),
          ElevatedButton(
                  onPressed: () => controller.getLoginAuthToken(),
                  child: const Text('登录'))
              .padding(right: 12),
          ElevatedButton(
              onPressed: () => controller.deleteAllCookie(),
              child: const Text('删除全部Cookie')),
          ElevatedButton(
              onPressed: () => AppThemeData.changeTheme(),
              child: const Text('切换主题')),
          ElevatedButton(
              onPressed: () => Get.updateLocale(const Locale('zh', 'CN')),
              child: const Text('切换中文')),
          ElevatedButton(
              onPressed: () => Get.updateLocale(const Locale('en', 'US')),
              child: const Text('切换英语')),
          ElevatedButton(
              onPressed: () => debugPaintSizeEnabled = true,
              child: const Text('开启UI调试'))
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: controller.formKey,
        child: Column(children: [
          TextFormField(
              initialValue: controller.email.value,
              onChanged: (value) => controller.email.value = value,
              decoration: const InputDecoration(
                  labelText: '邮箱',
                  hintText: '请输入邮箱',
                  prefixIcon: Icon(Icons.email_outlined),
                  isDense: true),
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return '邮箱不能为空';
                }
                return null;
              })),
          TextFormField(
              initialValue: controller.pwd.value,
              onChanged: (value) => controller.pwd.value = value,
              decoration: const InputDecoration(
                  labelText: '密码',
                  hintText: '密码',
                  prefixIcon: Icon(Icons.lock_outline),
                  isDense: true),
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return '邮箱不能为空';
                }
                return null;
              }))
        ]),
      ),
    );
  }
}
