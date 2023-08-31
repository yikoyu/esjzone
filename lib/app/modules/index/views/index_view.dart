/*
 * @Date: 2023-08-15 14:47:16
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-23 12:02:54
 * @FilePath: \esjzone\lib\app\modules\index\views\index_view.dart
 */
/*
 * @Date: 2023-08-15 14:47:16
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-16 11:22:00
 * @FilePath: \esjzone\lib\app\modules\index\views\index_view.dart
 */
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/index_controller.dart';

class IndexView extends GetView<IndexController> {
  const IndexView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: controller.pageController,
        onPageChanged: (int index) => controller.onJumpTo(index),
        itemCount: controller.pages.length,
        itemBuilder: (context, index) {
          return Container(
            child: controller.pages[index],
          );
        },
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (int index) => controller.onJumpTo(index, jump: true),
            items: [
              _bottomItem('home'.tr, Icons.home_outlined, Icons.home),
              _bottomItem('novels'.tr, Icons.book_outlined, Icons.book),
              _bottomItem('profile'.tr, Icons.person_outline, Icons.person),
            ],
          )),
    );
  }

  BottomNavigationBarItem _bottomItem(
      String title, IconData icon, IconData activeIcon) {
    return BottomNavigationBarItem(
        label: title,
        icon: _bottomItemIcon(icon),
        activeIcon: _bottomItemIcon(activeIcon));
  }

  Widget _bottomItemIcon(IconData icon) {
    return Icon(icon);
  }
}
