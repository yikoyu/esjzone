/*
 * @Date: 2023-08-22 14:47:36
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-29 21:07:14
 * @FilePath: \esjzone\lib\app\modules\search_novels\views\search_novels_view.dart
 */
import 'package:flutter/material.dart';
import 'package:esjzone/app/widgets/app_bar_search.dart';
import 'package:esjzone/app/widgets/easy_refresh_container.dart';
import 'package:esjzone/app/widgets/filter_bar.dart';
import 'package:esjzone/app/widgets/novel_list_card.dart';
import 'package:get/get.dart';

import '../controllers/search_novels_controller.dart';

class SearchNovelsView extends GetView<SearchNovelsController> {
  const SearchNovelsView({Key? key, this.uniqueTag}) : super(key: key);

  final String? uniqueTag;

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    Get.put(SearchNovelsController(), tag: uniqueTag);

    return Scaffold(
      appBar: AppBarSearch(
        toolbarHeight: 36,
        enabled: false,
        initialValue: controller.search,
        bottom: FilterBar(onChanged: controller.onFilterChange),
        onTap: () => Get.back(),
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
