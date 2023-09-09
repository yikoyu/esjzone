/*
 * @Date: 2023-08-15 14:46:32
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-04 20:56:13
 * @FilePath: \esjzone\lib\app\modules\home\views\home_view.dart
 */
import 'package:esjzone/app/modules/home/widgets/novel_favorite_list_card.dart';
import 'package:esjzone/app/widgets/easy_refresh_container.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的书架'),
        centerTitle: true,
      ),
      body: LoadingView(
          showErrorBack: false,
          controller: controller.loadingViewController,
          onEmptyTap: controller.onLoad,
          onErrorTap: controller.onLoad,
          onNetworkBlockedTap: controller.onLoad,
          child: EasyRefreshContainer(
            controller: controller.easyRefreshController,
            refreshOnStart: false,
            onRefresh: () => controller.getMyFavoriteList(refresh: true),
            onLoad: () => controller.getMyFavoriteList(),
            child: Obx(() => ListView.builder(
                  itemCount: controller.myNovelFavoriteList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return NovelFavoriteListCard(
                        controller.myNovelFavoriteList[i]);
                  },
                )),
          )),
    );
  }
}
