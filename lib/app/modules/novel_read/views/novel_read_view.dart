/*
 * @Date: 2023-08-31 17:24:47
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 17:32:11
 * @FilePath: \esjzone\lib\app\modules\novel_read\views\novel_read_view.dart
 */
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:esjzone/app/widgets/novel/novel_chapters_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';

import '../controllers/novel_read_controller.dart';

class NovelReadView extends GetView<NovelReadController> {
  const NovelReadView({Key? key, this.uniqueTag}) : super(key: key);

  final String? uniqueTag;

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    Get.put(NovelReadController(), tag: tag);

    return Scaffold(
      drawerEdgeDragWidth: 150,
      endDrawer: _buildEndDrawer(),
      body: LoadingView(
          controller: controller.loadingViewController,
          onEmptyTap: controller.onLoad,
          onErrorTap: controller.onLoad,
          onNetworkBlockedTap: controller.onLoad,
          child: _build(context)),
    );
  }

  Widget _buildEndDrawer() {
    return Builder(
        builder: ((BuildContext context) => Drawer(
              backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
              width: 306,
              child: SafeArea(
                  child: Column(
                children: [
                  Text(
                    controller.readDetail.value.novelName ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ).paddingAll(6),
                  Expanded(
                      child: NovelChaptersList(
                          sliver: false,
                          showDetail: true,
                          activeChapterId:
                              controller.detail.detail.value.activeChapterId,
                          onTap: ({novelId, chapterId}) {
                            Scaffold.of(context).closeEndDrawer();
                            controller.toChapter(
                                novelId: novelId, chapterId: chapterId);
                          },
                          chapterList: controller.detail.chapterList))
                ],
              )),
            )));
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
        ),
        SliverToBoxAdapter(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.edit_note).paddingOnly(right: 6),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'by ',
                                style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black)),
                            TextSpan(
                                text: controller.readDetail.value.authorName ??
                                    '',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ]))
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.update).paddingOnly(right: 6),
                          Text(controller.readDetail.value.updateTime ?? '')
                        ],
                      ).paddingOnly(top: 6),
                      Row(
                        children: [
                          const Icon(Icons.abc_outlined).paddingOnly(right: 6),
                          Text(controller.readDetail.value.words ?? '')
                        ],
                      ).paddingOnly(top: 6),
                      Text(
                        controller.readDetail.value.chapterName ?? '',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ).paddingOnly(top: 6)
                    ],
                  )),
            ),
            const Divider(),
            Obx(() => _buildBtnPanel()),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(6),
              child: Obx(() =>
                  HtmlWidget(controller.readDetail.value.contentHtml ?? '')),
            ),
            _buildLikeBtn(),
            const Divider(),
            Obx(() => _buildBtnPanel().paddingOnly(bottom: 48))
          ],
        ))
      ],
    );
  }

  Widget _buildLikeBtn() {
    return Container(
        padding: const EdgeInsets.all(6),
        child: Obx(() => TextButton.icon(
            onPressed: controller.onHandleLike,
            icon: (controller.readDetail.value.isLike ?? false)
                ? const Icon(Icons.thumb_up_alt)
                : const Icon(Icons.thumb_up_alt_outlined),
            label: Text(controller.readDetail.value.likes ?? '0'))));
  }

  Widget _buildBtnPanel() {
    return Container(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
                visible: controller.readDetail.value.chapterPrevId != null,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: ElevatedButton.icon(
                    onPressed: () => controller.toChapter(
                        novelId: controller.readDetail.value.novelId,
                        chapterId: controller.readDetail.value.chapterPrevId),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('上一章'))),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.list),
            //   style: const ButtonStyle(elevation: MaterialStatePropertyAll(12)),
            // ),
            Visibility(
                visible: controller.readDetail.value.chapterNextId != null,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                        onPressed: () => controller.toChapter(
                            novelId: controller.readDetail.value.novelId,
                            chapterId:
                                controller.readDetail.value.chapterNextId),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('下一章')))),
          ],
        ));
  }
}
