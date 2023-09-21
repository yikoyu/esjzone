/*
 * @Date: 2023-08-15 15:11:36
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-09 23:14:29
 * @FilePath: \esjzone\lib\app\modules\novels\controllers\novels_controller.dart
 */
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:esjzone/app/controllers/login_user_controllers.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:flutter/material.dart';
import 'package:esjzone/app/data/novel_list_model.dart';
import 'package:esjzone/app/utils/enum.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:get/get.dart';

class NovelsController extends GetxController {
  EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  LoadingViewController loadingViewController = LoadingViewController();
  LoginUserController loginUser = Get.put(LoginUserController());

  SortLabel sortValue = SortLabel.updated;
  CategoryLabel categoryValue = CategoryLabel.all;
  var novelList = <NovelList>[].obs;
  var hotTagList = <String>[].obs; // searching 页面用
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

  Future<void> onLoad() async {
    loadingViewController.loading();

    try {
      await getNovelListData(refresh: true);
      if (novelList.isEmpty) {
        loadingViewController.empty();
        return;
      }

      loadingViewController.success();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        loadingViewController.networkBlocked();
      } else {
        loadingViewController.error();
      }
    } catch (e) {
      loadingViewController.error();
    }
  }

  Future<void> getNovelListData({bool refresh = false}) async {
    if (refresh) {
      page = 1;
    }

    final EsjzoneParseData esjzone = EsjzoneParseData(
        EsjzoneHttp.getNovelListPage(
            page: page, category: categoryValue, sort: sortValue));

    List<NovelList> value = await esjzone.novelList();
    hotTagList.value = await esjzone.hotTagList();
    int? total = await esjzone.getPagination();
    loginUser.getLoginUser(esjzone);

    debugPrint('热门标签 > $hotTagList');

    // 列表为空，最后一页
    debugPrint('pagination > $total > $page');
    if (total != null && (page > total)) {
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
