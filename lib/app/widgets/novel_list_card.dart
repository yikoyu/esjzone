/*
 * @Date: 2023-08-18 21:34:50
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 16:55:15
 * @FilePath: \esjzone\lib\app\widgets\novel_list_card.dart
 */
import 'package:esjzone/app/modules/novel_detail/views/novel_detail_view.dart';
import 'package:esjzone/app/modules/novel_read/views/novel_read_view.dart';
import 'package:esjzone/app/modules/search_novels/views/search_novels_view.dart';
import 'package:flutter/material.dart';
import 'package:esjzone/app/data/novel_list_model.dart';
import 'package:esjzone/app/widgets/cached_image.dart';
import 'package:esjzone/app/widgets/icon_text.dart';
import 'package:esjzone/app/widgets/link_text.dart';
import 'package:esjzone/app/widgets/option_grid_view.dart';

import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class NovelListCard extends StatelessWidget {
  final NovelList item;

  const NovelListCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: InkWell(
          onTap: () => _toNovelDetail(item),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 0.6875, child: _buildImage(item))
                  .width(134),
              Expanded(child: _buildCardDetail(item))
            ],
          )),
    );
  }

  Widget _buildImage(NovelList item) {
    if (item.xRated != null && item.xRated == true) {
      return Stack(alignment: AlignmentDirectional.topEnd, children: [
        Positioned(
            left: 0, top: 0, right: 0, bottom: 0, child: CachedImage(item.img)),
        Container(
          color: Colors.red,
          width: 24,
          height: 24,
          child: const Center(
              child: Text('18+',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500))),
        )
      ]);
    }

    return CachedImage(item.img);
  }

  Widget _buildCardDetail(NovelList item) {
    final List<Widget> iconTextList = [
      IconText(Icons.star_outline, item.stars),
      IconText(Icons.abc_outlined, item.words),
      IconText(Icons.remove_red_eye_outlined, item.views),
      IconText(Icons.favorite_outline, item.favorite),
      IconText(Icons.article_outlined, item.feathers),
      IconText(Icons.chat_bubble_outline, item.messages)
    ];

    final Widget title = Text(
      '${item.title}\n',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ).fontSize(16).fontWeight(FontWeight.w500).padding(bottom: 4);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      title,
      LinkText(item.author, onTap: () => _toSearchAuthor(item.author))
          .padding(bottom: 4),
      LinkText(item.lastEp,
              onTap: () => _toNovelChapter(item.id, item.lastChapterId))
          .padding(bottom: 4),
      OptionGridView(
          itemCount: iconTextList.length,
          rowCount: 2,
          itemBuilder: (context, index) => iconTextList[index])
    ]).paddingAll(12);
  }

  Future<void> _toNovelDetail(NovelList item) async {
    if (item.id == null) {
      Get
        ..closeAllSnackbars()
        ..snackbar('提示', '小说链接解析错误',
            backgroundColor: Colors.red.shade200, colorText: Colors.white);
    }

    // item.id = '1688963190';
    // item.id = '1660575572';
    // item.id = '1600468706'; // 章节链接错误案例

    Get.to(() => NovelDetailView(uniqueTag: item.id),
        arguments: {'novelId': item.id}, transition: Transition.rightToLeft);
  }

  void _toSearchAuthor(String? author) {
    if (item.author != null && item.author!.isNotEmpty) {
      Get.to(() => SearchNovelsView(uniqueTag: item.author),
          arguments: {'search': item.author}, transition: Transition.fadeIn);
    }
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
