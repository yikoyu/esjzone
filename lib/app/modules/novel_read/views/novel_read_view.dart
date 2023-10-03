/*
 * @Date: 2023-08-31 17:24:47
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 17:32:11
 * @FilePath: \esjzone\lib\app\modules\novel_read\views\novel_read_view.dart
 */
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:esjzone/app/widgets/novel/novel_comment_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';

import '../controllers/novel_read_controller.dart';
import '../widgets/read_novel_button_panel.dart';
import '../widgets/read_novel_chapters_drawer.dart';
import '../widgets/read_novel_like_button.dart';
import '../widgets/read_novel_top.dart';

class NovelReadView extends GetView<NovelReadController> {
  const NovelReadView({Key? key, this.uniqueTag}) : super(key: key);

  final String? uniqueTag;

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    Get.put(NovelReadController(), tag: tag);

    return Scaffold(
      drawerEdgeDragWidth: 50,
      drawer: Obx(() => ReadNovelChaptersDrawer(
            key: controller.chaptersDrawerKey,
            title: controller.readDetail.value.novelName ?? '',
            activeChapterId: controller.detail.detail.value.activeChapterId,
            list: controller.detail.chapterList,
            onTapChapter: controller.toChapter,
          )),
      endDrawer: NovelCommentDrawer(comment: controller.comment),
      body: LoadingView(
          controller: controller.loadingViewController,
          onEmptyTap: controller.onLoad,
          onErrorTap: controller.onLoad,
          onNetworkBlockedTap: controller.onLoad,
          child: Scrollbar(child: _build(context))),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            dynamic currentState = controller.chaptersDrawerKey.currentState;
            currentState?.scrollToActiveChapter();
          });
        }
      },
    );
  }

  Widget _build(BuildContext context) {
    return CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        SliverAppBar(
          title: Obx(() => Text(
                controller.readDetail.value.chapterName ?? '',
                style: const TextStyle(fontSize: 12),
              )),
          floating: true,
          toolbarHeight: 40,
          centerTitle: true,
          leading: Row(
            children: [
              const BackButton(),
              Builder(
                  builder: ((context) => IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.list),
                      )))
            ],
          ),
          actions: [
            Builder(
                builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.messenger_outline)))
          ],
          leadingWidth: 96,
        ),
        SliverToBoxAdapter(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildReadColumn(),
        ))
      ],
    );
  }

  List<Widget> _buildReadColumn() {
    return [
      ReadNovelTop(readDetail: controller.readDetail),
      const Divider(),
      Obx(() => ReadNovelButtonPanel(
          novelId: controller.readDetail.value.novelId,
          chapterNextId: controller.readDetail.value.chapterNextId,
          chapterPrevId: controller.readDetail.value.chapterPrevId,
          onTapChapter: controller.toChapter)),
      const Divider(),
      _buildReadContent(),
      ReadNovelLikeButton(
          readDetail: controller.readDetail,
          onTap: (isLiked) => controller.onForumLikesLike()),
      const Divider(),
      Obx(() => ReadNovelButtonPanel(
          novelId: controller.readDetail.value.novelId,
          chapterNextId: controller.readDetail.value.chapterNextId,
          chapterPrevId: controller.readDetail.value.chapterPrevId,
          onTapChapter: controller.toChapter)),
      const SizedBox(height: 48)
    ];
  }

  Widget _buildReadContent() {
    return Container(
      padding: const EdgeInsets.all(6),
      child:
          Obx(() => HtmlWidget(controller.readDetail.value.contentHtml ?? '')),
    );
  }
}
