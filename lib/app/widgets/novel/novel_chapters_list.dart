/*
 * @Date: 2023-09-01 15:11:46
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-02 20:31:27
 * @FilePath: \esjzone\lib\app\widgets\novel\novel_chapters_list.dart
 */
import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import 'novel_details_chapters_panel.dart';

class NovelChaptersList extends StatelessWidget {
  final ScrollController? scrollController;
  final bool showDetail;
  final bool sliver;
  final String? activeChapterId;
  final Key? activeChapterKey;
  final List<NovelChapterList> chapterList;
  final void Function({String? novelId, String? chapterId})? onTap;

  const NovelChaptersList(
      {super.key,
      this.scrollController,
      this.activeChapterId,
      this.activeChapterKey,
      this.sliver = true,
      required this.chapterList,
      this.onTap,
      this.showDetail = false});

  @override
  Widget build(BuildContext context) {
    if (sliver) {
      return SliverList.builder(
          itemCount: chapterList.length,
          itemBuilder: ((context, index) =>
              _buildItem(context, chapterList[index])));
    }

    return ListView.builder(
        controller: scrollController,
        itemCount: chapterList.length,
        itemBuilder: ((context, index) =>
            _buildItem(context, chapterList[index])));
  }

  /// 章节列表项
  Widget _buildItem(BuildContext context, NovelChapterList item) {
    if (item.type == 'text') return _buildItemTitle(item.titleHtml);
    if (item.type == 'chapter') return _buildItemChapter(context, item);
    if (item.type == 'details') return _buildItemDetails(context, item);

    return const SizedBox();
  }

  // 普通文本
  Widget _buildItemTitle(String? titleHtml) {
    return HtmlWidget(
      titleHtml ?? '',
      textStyle: const TextStyle(fontSize: 14),
    ).paddingAll(8);
  }

  // 章节
  Widget _buildItemChapter(BuildContext context, NovelChapterList item) {
    return Card(
        key: activeChapterId == item.chapterId ? activeChapterKey : null,
        color: activeChapterId == item.chapterId
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: InkWell(
            onTap: () =>
                onTap?.call(novelId: item.novelId, chapterId: item.chapterId),
            child: HtmlWidget(
              item.titleHtml ?? '',
              textStyle: const TextStyle(fontSize: 14),
            ).paddingAll(8)));
  }

  // 折叠列表
  Widget _buildItemDetails(BuildContext context, NovelChapterList item) {
    return NovelDetailsChaptersPanel(
      show: showDetail,
      titleBuilder: (context) {
        return HtmlWidget(
          '${item.titleHtml}',
          textStyle: const TextStyle(fontSize: 14),
        ).paddingAll(8);
      },
      contentBuilder: (context) {
        if (item.chapters != null) {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.chapters!.length,
              itemBuilder: ((context, index) {
                return _buildItem(context, item.chapters![index]);
              }));
        }

        return const SizedBox();
      },
    );
  }
}
