/*
 * @Date: 2023-09-04 20:06:42
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-04 20:37:55
 * @FilePath: \esjzone\lib\app\modules\home\widgets\novel_favorite_list_card.dart
 */
import 'package:esjzone/app/data/my_favorite_list_model.dart';
import 'package:esjzone/app/modules/novel_detail/views/novel_detail_view.dart';
import 'package:esjzone/app/modules/novel_read/views/novel_read_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NovelFavoriteListCard extends StatelessWidget {
  final MyFavoriteList item;

  const NovelFavoriteListCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _toNovelDetail(item.novelId), child: _buildCard(context));
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(6, 0, 6, 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          item.novelName ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        _buildChapter(context).paddingOnly(top: 6),
        Text('最新观看：${item.lastWatch ?? '--'}').paddingOnly(top: 2),
        Text('最新更新：${item.updateTime ?? '--'}').paddingOnly(top: 2)
      ]).paddingAll(6),
    );
  }

  Widget _buildChapter(context) {
    bool hasChapterId =
        item.lastChapterId != null && item.lastChapterId!.isNotEmpty;

    if (hasChapterId) {
      return RichText(
        text: TextSpan(children: [
          const WidgetSpan(child: Text('最新章节：')),
          TextSpan(
              text: item.lastChapterName,
              recognizer: TapGestureRecognizer()
                ..onTap =
                    () => _toNovelChapter(item.novelId, item.lastChapterId),
              style: TextStyle(color: Theme.of(context).colorScheme.primary))
        ]),
      );
    }

    return Text('最新章节：${item.lastChapterName ?? '--'}');
  }

  void _toNovelDetail(String? novelId) {
    if (novelId != null && novelId.isNotEmpty) {
      Get.to(() => NovelDetailView(uniqueTag: novelId),
          arguments: {'novelId': novelId}, transition: Transition.rightToLeft);
      return;
    }

    Get
      ..closeAllSnackbars()
      ..snackbar('提示', '小说链接解析错误',
          backgroundColor: Colors.red.shade200, colorText: Colors.white);
  }

  void _toNovelChapter(String? novelId, String? chapterId) {
    if (novelId != null &&
        novelId.isNotEmpty &&
        chapterId != null &&
        chapterId.isNotEmpty) {
      final String tag = '$novelId-$chapterId';
      Get.to(() => NovelReadView(uniqueTag: tag),
          arguments: {'novelId': novelId, 'chapterId': chapterId},
          transition: Transition.rightToLeft);
    }
  }
}
