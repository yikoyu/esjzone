/*
 * @Date: 2023-08-31 17:24:47
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-01 13:51:50
 * @FilePath: \esjzone\lib\app\modules\novel_read\controllers\novel_read_controller.dart
 */
import 'package:esjzone/app/data/novel_read_model.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NovelReadController extends GetxController {
  var readDetail = NovelRead().obs;
  ScrollController scrollController = ScrollController();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void setReadDetail(NovelRead value) {
    readDetail.value = value;
  }

  Future<void> getReadDetail(String novelId, String chapterId) async {
    final EsjzoneParseData esjzone =
        EsjzoneParseData(EsjzoneHttp.getNovelReadPage(novelId, chapterId));

    EasyLoading.show(status: '加载中...', maskType: EasyLoadingMaskType.black);

    try {
      NovelRead readDetail = await esjzone.novelChapterReadDetail();
      await EasyLoading.dismiss();

      setReadDetail(readDetail);
    } catch (e) {
      EasyLoading.dismiss();
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

    await getReadDetail(novelId, chapterId);
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
  }
}
