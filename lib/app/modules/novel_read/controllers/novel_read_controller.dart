/*
 * @Date: 2023-08-31 17:24:47
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 17:29:57
 * @FilePath: \esjzone\lib\app\modules\novel_read\controllers\novel_read_controller.dart
 */
import 'package:dio/dio.dart';
import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:esjzone/app/data/novel_read_model.dart';
import 'package:esjzone/app/modules/novel_detail/controllers/novel_detail_controller.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NovelReadController extends GetxController {
  final NovelDetailController detail = Get.put(
    NovelDetailController(initChapterId: Get.arguments['chapterId']),
    tag: Get.arguments['novelId'],
  );
  late final String novelId;
  late final String chapterId;

  var readDetail = NovelRead().obs;
  var comment = <CommentList>[].obs;
  ScrollController scrollController = ScrollController();
  LoadingViewController loadingViewController = LoadingViewController();

  final GlobalKey chaptersDrawerKey = GlobalKey();

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
      NovelRead readDetailData = await esjzone.novelChapterReadDetail();

      readDetail.value = readDetailData;
      comment
        ..clear()
        ..addAll(await esjzone.commentList());
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

    scrollController.jumpTo(0);
    await getReadDetail(novelId, chapterId);
    detail.updateActiveChapter(chapterId);
  }

  Future<void> onForumLikesLike() async {
    EasyLoading.show(status: '加载中...');

    try {
      String? likes = await EsjzoneHttp.forumLikes(
          readDetail.value.novelId!, readDetail.value.chapterId!);
      EasyLoading.dismiss();

      if (likes != null && likes.isNotEmpty) {
        readDetail.update((val) {
          val?.isLike = !(val.isLike ?? false);
          val?.likes = likes;
        });
      }

      Get.snackbar(
          '提示', (readDetail.value.isLike ?? false) ? '点赞成功' : '取消点赞成功');
    } on DioException catch (e) {
      EasyLoading.dismiss();
      Get.closeAllSnackbars();
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.unknown) {
        Get.snackbar('点赞失败', '网络连接超时，请检查你的网络环境',
            backgroundColor: Colors.red.shade200);
      } else {
        Get.snackbar('点赞失败', '点赞失败，请稍后再试',
            backgroundColor: Colors.red.shade200);
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  Future<bool> onHandleLike() async {
    try {
      await onForumLikesLike();
      return readDetail.value.isLike ?? false;
    } catch (e) {
      return readDetail.value.isLike ?? false;
    }
  }
}
