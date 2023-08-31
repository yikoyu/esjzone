/*
 * @Date: 2023-08-15 15:11:36
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 12:22:11
 * @FilePath: \esjzone\lib\app\modules\novels\views\novels_view.dart
 */
import 'package:flutter/material.dart';
import 'package:esjzone/app/modules/searching/views/searching_view.dart';
import 'package:esjzone/app/widgets/app_bar_search.dart';
import 'package:esjzone/app/widgets/easy_refresh_container.dart';
import 'package:esjzone/app/widgets/filter_bar.dart';
import 'package:esjzone/app/widgets/novel_list_card.dart';

import 'package:get/get.dart';

import '../controllers/novels_controller.dart';

class NovelsView extends GetView<NovelsController> {
  const NovelsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NovelsController());

    return Scaffold(
      appBar: AppBarSearch(
        toolbarHeight: 36,
        enabled: false,
        leading: const Center(
          child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar-default.png')),
        ),
        bottom: FilterBar(onChanged: controller.onFilterChange),
        onTap: () =>
            Get.to(() => const SearchingView(), transition: Transition.fadeIn),
      ),
      body: EasyRefreshContainer(
        controller: controller.easyRefreshController,
        onRefresh: () => controller.getNovelListData(refresh: true),
        onLoad: () => controller.getNovelListData(),
        child: Obx(() => ListView.builder(
              itemCount: controller.novelList.length,
              itemBuilder: (BuildContext item, int i) {
                return NovelListCard(controller.novelList[i]);
              },
            )),
      ),
    );
  }
}
