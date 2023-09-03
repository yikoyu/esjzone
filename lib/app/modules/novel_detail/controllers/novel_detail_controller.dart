/*
 * @Date: 2023-08-26 10:37:13
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 16:39:29
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NovelDetailController extends GetxController {
  LoadingViewController loadingViewController = LoadingViewController();
  late final String novelId;

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
    novelId = Get.arguments['novelId'];
    getNovelDetailData();
  }

  @override
  void onClose() {
    loadingViewController.dispose();
    super.onClose();
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

  Future<void> getNovelDetailData() async {
    final EsjzoneParseData esjzone =
        EsjzoneParseData(EsjzoneHttp.getNovelDetialPage(novelId));

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

  Future<void> onHandleStartRead() async {
    if (detail.value.activeChapterId != null &&
        detail.value.activeChapterId!.isNotEmpty) {
      toNovelRead(novelId, detail.value.activeChapterId);
      return;
    }

    // 查找章节或折叠列表
    NovelChapterList? firstChapterOrDetail =
        chapterList.firstWhereOrNull((element) {
      bool isDetails = element.type == 'details' &&
          element.chapters != null &&
          element.chapters!.isNotEmpty;
      bool isChapter = element.type == 'chapter' &&
          element.chapterId != null &&
          element.chapterId!.isNotEmpty;

      return isChapter || isDetails;
    });

    // 查找折叠列表第一个章节
    if (firstChapterOrDetail != null &&
        firstChapterOrDetail.type == 'details' &&
        firstChapterOrDetail.chapters != null &&
        firstChapterOrDetail.chapters!.isNotEmpty) {
      NovelChapterList? detailChapter =
          _chapterListFirstWhere(firstChapterOrDetail.chapters!);
      if (detailChapter != null &&
          detailChapter.chapterId != null &&
          detailChapter.chapterId!.isNotEmpty) {
        toNovelRead(novelId, detailChapter.chapterId);
        return;
      }
    }

    // 查找第一个章节
    if (firstChapterOrDetail != null &&
        firstChapterOrDetail.type == 'chapter' &&
        firstChapterOrDetail.chapterId != null &&
        firstChapterOrDetail.chapterId!.isNotEmpty) {
      toNovelRead(novelId, firstChapterOrDetail.chapterId);
      return;
    }
  }

  NovelChapterList? _chapterListFirstWhere(List<NovelChapterList> data) {
    NovelChapterList? firstChapter = data.firstWhereOrNull((element) {
      bool isChapter = element.type == 'chapter' &&
          element.chapterId != null &&
          element.chapterId!.isNotEmpty;

      return isChapter;
    });

    return firstChapter;
  }

  Future<void> onHandleFavorite() async {
    EasyLoading.show(status: '加载中...');

    try {
      String? favorite = await EsjzoneHttp.memFavorite(novelId);
      EasyLoading.dismiss();

      if (favorite != null && favorite.isNotEmpty) {
        detail.update((val) {
          val?.isFavorite = !(val.isFavorite ?? false);
          val?.favorite = favorite;
        });
      }

      Get.snackbar(
          '提示', (detail.value.isFavorite ?? false) ? '收藏成功' : '取消收藏成功');
    } on DioException catch (e) {
      EasyLoading.dismiss();
      Get.closeAllSnackbars();
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        Get.snackbar('收藏失败', '网络连接超时，请检查你的网络环境',
            backgroundColor: Colors.red.shade200);
      } else {
        Get.snackbar('收藏失败', '收藏失败，请稍后再试',
            backgroundColor: Colors.red.shade200);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
