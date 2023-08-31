/*
 * @Date: 2023-08-24 10:32:36
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 12:07:15
 * @FilePath: \esjzone\lib\app\modules\search_novels\controllers\search_novels_controller.dart
 */
/*
 * @Date: 2023-08-22 14:47:36
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-24 13:33:15
 * @FilePath: \esjzone\lib\app\modules\search_novels\controllers\search_novels_controller.dart
 */
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:esjzone/app/data/novel_list_model.dart';
import 'package:esjzone/app/utils/enum.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:get/get.dart';

class SearchNovelsController extends GetxController {
  EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);

  final String? search = Get.arguments["search"];
  SortLabel sortValue = SortLabel.updated;
  CategoryLabel categoryValue = CategoryLabel.all;
  var novelList = <NovelList>[].obs;
  int page = 1;

  @override
  void onClose() {
    easyRefreshController.dispose();
    super.onClose();
  }

  onFilterChange(SortLabel? sortLabel, CategoryLabel? categoryLabel) {
    if (sortLabel != null) {
      sortValue = sortLabel;
    }

    if (categoryLabel != null) {
      categoryValue = categoryLabel;
    }

    easyRefreshController.callRefresh();
    debugPrint('筛选 >> ${sortLabel?.value} >> ${categoryLabel?.value}');
  }

  Future<void> getNovelListData({bool refresh = false}) async {
    if (refresh) {
      page = 1;
    }

    final EsjzoneParseData esjzone = EsjzoneParseData(
        EsjzoneHttp.getNovelListPage(
            search: search,
            page: page,
            category: categoryValue,
            sort: sortValue));

    List<NovelList> value = await esjzone.novelList();

    // 列表为空，最后一页
    if (value.isEmpty) {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
      return;
    }

    // 刷新
    if (refresh) {
      novelList
        ..clear()
        ..addAll(value);

      ++page;

      easyRefreshController.finishRefresh();
      easyRefreshController.resetFooter();
      return;
    }

    novelList.addAll(value);
    ++page;
    easyRefreshController.finishLoad(IndicatorResult.success);

    debugPrint('getNovelList code > $novelList');
  }
}
