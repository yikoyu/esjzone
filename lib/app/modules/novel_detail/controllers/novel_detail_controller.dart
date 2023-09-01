/*
 * @Date: 2023-08-26 10:37:13
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-01 12:21:01
 * @FilePath: \esjzone\lib\app\modules\novel_detail\controllers\novel_detail_controller.dart
 */
import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/data/novel_detail_star_model.dart';
import 'package:esjzone/app/modules/novel_read/controllers/novel_read_controller.dart';
import 'package:esjzone/app/modules/novel_read/views/novel_read_view.dart';
import 'package:esjzone/app/modules/search_novels/views/search_novels_view.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NovelDetailController extends GetxController {
  var comment = <CommentList>[].obs;
  var tags = <String>[].obs;
  var chapterList = <NovelChapterList>[].obs;
  var rateDetail = NovelDetailStar().obs;
  var detail = NovelDetail().obs;

  List<int> get rateList {
    int five = int.tryParse(rateDetail.value.fiveRate ?? '0') ?? 0;
    int four = int.tryParse(rateDetail.value.fourRate ?? '0') ?? 0;
    int three = int.tryParse(rateDetail.value.threeRate ?? '0') ?? 0;
    int two = int.tryParse(rateDetail.value.twoRate ?? '0') ?? 0;
    int one = int.tryParse(rateDetail.value.oneRate ?? '0') ?? 0;

    return [five, four, three, two, one];
  }

  void toSearch(String? label) {
    if (label == null) return;

    Get.to(() => SearchNovelsView(uniqueTag: label),
        arguments: {'search': label}, transition: Transition.fadeIn);
  }

  void toNovelRaw(String url) {
    launchUrl(Uri.parse(url));
  }

  Future<void> toNovelRead(String? novelId, String? chapterId) async {
    bool canToNovelRead = novelId != null &&
        novelId.isNotEmpty &&
        chapterId != null &&
        chapterId.isNotEmpty;

    if (!canToNovelRead) {
      Get
        ..closeAllSnackbars()
        ..snackbar('提示', '小说阅读页链接解析错误',
            backgroundColor: Colors.red.shade200, colorText: Colors.white);
      return;
    }

    final EsjzoneParseData esjzone =
        EsjzoneParseData(EsjzoneHttp.getNovelReadPage(novelId, chapterId));

    EasyLoading.show(status: '加载中...', maskType: EasyLoadingMaskType.black);

    final String tag = '$novelId-$chapterId';

    try {
      var readDetail = await esjzone.novelChapterReadDetail();
      await EasyLoading.dismiss();

      NovelReadController novelReadController =
          Get.put(NovelReadController(), tag: tag);

      novelReadController.setReadDetail(readDetail);
      detail.update((val) => val?.activeChapterId = chapterId);

      debugPrint('进入阅读页 > $chapterId');
      await Get.to(() => NovelReadView(uniqueTag: tag),
          transition: Transition.rightToLeft);

      Get.delete<NovelReadController>(tag: tag);
    } catch (e) {
      EasyLoading.dismiss();
      Get.delete<NovelReadController>(tag: tag);
    }

    return;
  }

  Future<void> getNovelDetailData(String id) async {
    final EsjzoneParseData esjzone =
        EsjzoneParseData(EsjzoneHttp.getNovelDetialPage(id));

    comment
      ..clear()
      ..addAll(await esjzone.commentList());

    tags
      ..clear()
      ..addAll(await esjzone.hotTagList());

    chapterList
      ..clear()
      ..addAll(await esjzone.novelChapterList());

    rateDetail.value = await esjzone.novelDetailStar();
    detail.value = await esjzone.novelDetail();

    debugPrint('标签 > $tags');
    debugPrint('评论 > $comment');
    debugPrint('评分 > $rateDetail');
    debugPrint('详情 > $detail');
    debugPrint('章节 > $chapterList');
  }
}
