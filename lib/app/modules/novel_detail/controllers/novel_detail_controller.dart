/*
 * @Date: 2023-08-26 10:37:13
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-02 21:07:22
 * @FilePath: \esjzone\lib\app\modules\novel_detail\controllers\novel_detail_controller.dart
 */
import 'package:dio/dio.dart';
import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/data/novel_detail_star_model.dart';
import 'package:esjzone/app/modules/novel_read/views/novel_read_view.dart';
import 'package:esjzone/app/modules/search_novels/views/search_novels_view.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NovelDetailController extends GetxController {
  LoadingViewController loadingViewController = LoadingViewController();
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

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }

  @override
  void onClose() {
    loadingViewController.dispose();
    super.onClose();
  }

  void onLoad() {
    var args = Get.arguments;
    getNovelDetailData(args['novelId']);
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

    updateDetail(chapterId);
    final String tag = '$novelId-$chapterId';
    await Get.to(() => NovelReadView(uniqueTag: tag),
        arguments: {'novelId': novelId, 'chapterId': chapterId},
        transition: Transition.rightToLeft);
  }

  void updateDetail(String chapterId) {
    detail.update((val) => val?.activeChapterId = chapterId);
  }

  Future<void> getNovelDetailData(String id) async {
    final EsjzoneParseData esjzone =
        EsjzoneParseData(EsjzoneHttp.getNovelDetialPage(id));

    loadingViewController.loading();

    try {
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

      loadingViewController.success();

      debugPrint('标签 > $tags');
      debugPrint('评论 > $comment');
      debugPrint('评分 > $rateDetail');
      debugPrint('详情 > $detail');
      debugPrint('章节 > $chapterList');
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
}
