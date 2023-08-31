/*
 * @Date: 2023-08-26 10:37:13
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-30 22:32:02
 * @FilePath: \esjzone\lib\app\modules\novel_detail\controllers\novel_detail_controller.dart
 */
import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/data/novel_detail_star_model.dart';
import 'package:esjzone/app/modules/search_novels/views/search_novels_view.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:flutter/foundation.dart';
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
