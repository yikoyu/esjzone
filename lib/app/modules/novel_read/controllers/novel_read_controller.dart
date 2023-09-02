/*
 * @Date: 2023-08-31 17:24:47
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-02 19:45:01
 * @FilePath: \esjzone\lib\app\modules\novel_read\controllers\novel_read_controller.dart
 */
import 'package:dio/dio.dart';
import 'package:esjzone/app/data/novel_read_model.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NovelReadController extends GetxController {
  var readDetail = NovelRead().obs;
  ScrollController scrollController = ScrollController();
  LoadingViewController loadingViewController = LoadingViewController();

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }

  @override
  void onClose() {
    scrollController.dispose();
    loadingViewController.dispose();
    super.onClose();
  }

  void onLoad() {
    var args = Get.arguments;
    getReadDetail(args['novelId'], args['chapterId']);
  }

  Future<void> getReadDetail(String novelId, String chapterId) async {
    final EsjzoneParseData esjzone =
        EsjzoneParseData(EsjzoneHttp.getNovelReadPage(novelId, chapterId));

    loadingViewController.loading();

    try {
      NovelRead detail = await esjzone.novelChapterReadDetail();

      readDetail.value = detail;
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

  Future<void> toChapter({String? novelId, String? chapterId}) async {
    var colorScheme = Theme.of(Get.context!).colorScheme;

    bool canToNovelRead = novelId != null &&
        novelId.isNotEmpty &&
        chapterId != null &&
        chapterId.isNotEmpty;

    if (!canToNovelRead) {
      Get
        ..closeAllSnackbars()
        ..snackbar('提示', '章节不存在',
            backgroundColor: colorScheme.error, colorText: Colors.white);
      return;
    }

    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
    await getReadDetail(novelId, chapterId);
  }
}
