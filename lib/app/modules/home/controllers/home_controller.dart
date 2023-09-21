/*
 * @Date: 2023-08-15 14:46:32
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-09 23:11:00
 * @FilePath: \esjzone\lib\app\modules\home\controllers\home_controller.dart
 */
import 'package:dio/dio.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:esjzone/app/controllers/login_user_controllers.dart';
import 'package:esjzone/app/data/my_favorite_list_model.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  EasyRefreshController easyRefreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  LoadingViewController loadingViewController = LoadingViewController();
  LoginUserController loginUser = Get.put(LoginUserController());

  var myNovelFavoriteList = <MyFavoriteList>[].obs;
  int page = 1;

  @override
  void onInit() {
    onLoad();
    super.onInit();
  }

  @override
  void onClose() {
    easyRefreshController.dispose();
    loadingViewController.dispose();
    super.onClose();
  }

  Future<void> onLoad() async {
    loadingViewController.loading();

    try {
      await getMyFavoriteList(refresh: true);
      if (myNovelFavoriteList.isEmpty) {
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

  Future<void> getMyFavoriteList({bool refresh = false}) async {
    if (refresh) {
      page = 1;
    }

    final EsjzoneParseData esjzone = EsjzoneParseData(
        EsjzoneHttp.getMyFavoritePage(page: page, isUpdate: true));

    List<MyFavoriteList> value = await esjzone.myFavoriteList();
    int? total = await esjzone.getPagination();
    loginUser.getLoginUser(esjzone);

    // 列表为空，最后一页
    debugPrint('pagination > $refresh > $total > $page');
    if (total != null && (page > total)) {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
      return;
    }

    // 刷新
    if (refresh) {
      myNovelFavoriteList
        ..clear()
        ..addAll(value);

      ++page;

      easyRefreshController.finishRefresh();
      easyRefreshController.resetFooter();
      return;
    }

    myNovelFavoriteList.addAll(value);
    ++page;
    easyRefreshController.finishLoad(IndicatorResult.success);

    debugPrint('myNovelFavoriteList > $myNovelFavoriteList');
  }
}
