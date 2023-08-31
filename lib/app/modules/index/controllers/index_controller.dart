/*
 * @Date: 2023-08-15 14:47:16
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-16 14:12:29
 * @FilePath: \esjzone\lib\app\modules\index\controllers\index_controller.dart
 */
import 'package:flutter/widgets.dart';
import 'package:esjzone/app/modules/home/views/home_view.dart';
import 'package:esjzone/app/modules/novels/views/novels_view.dart';
import 'package:esjzone/app/modules/profile/views/profile_view.dart';
import 'package:get/get.dart';

class IndexController extends GetxController {
  List<Widget> pages = const [HomeView(), NovelsView(), ProfileView()];
  var currentIndex = 0.obs;

  final PageController pageController = PageController(initialPage: 0);

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }

  void onJumpTo(int index, {bool jump = false}) {
    if (jump) {
      pageController.jumpToPage(index);
    }

    currentIndex.value = index;
  }
}
