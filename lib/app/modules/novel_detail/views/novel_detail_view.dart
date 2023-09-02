/*
 * @Date: 2023-08-26 10:37:13
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-02 20:03:55
 * @FilePath: \esjzone\lib\app\modules\novel_detail\views\novel_detail_view.dart
 */
import 'dart:ui';

import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/data/novel_detail_star_model.dart';
import 'package:esjzone/app/modules/novel_detail/widgets/rating_detail_panel.dart';
import 'package:esjzone/app/widgets/cached_image.dart';
import 'package:esjzone/app/widgets/link_text.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:esjzone/app/widgets/novel/novel_chapters_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';

import '../controllers/novel_detail_controller.dart';

class NovelDetailView extends GetView<NovelDetailController> {
  const NovelDetailView({Key? key, this.uniqueTag}) : super(key: key);

  final String? uniqueTag;

  @override
  String? get tag => uniqueTag;

  @override
  Widget build(BuildContext context) {
    Get.put(NovelDetailController(), tag: tag);

    return Scaffold(
      body: LoadingView(
          controller: controller.loadingViewController,
          onEmptyTap: controller.onLoad,
          onErrorTap: controller.onLoad,
          onNetworkBlockedTap: controller.onLoad,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 背景图
              ClipRRect(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Obx(() => CachedImage(controller.detail.value.img,
                      showLoading: false)),
                ),
              ),
              // 内容
              CustomScrollView(slivers: [
                const SliverAppBar(
                    pinned: true, forceMaterialTransparency: true),
                Obx(() => SliverPadding(
                    padding: const EdgeInsets.all(6),
                    sliver: SliverToBoxAdapter(
                      child: _buildDetail(controller.detail.value),
                    ))),
                const SliverToBoxAdapter(child: Divider()),
                Obx(() => NovelChaptersList(
                      activeChapterId: controller.detail.value.activeChapterId,
                      chapterList: controller.chapterList,
                      onTap: ({novelId, chapterId}) =>
                          controller.toNovelRead(novelId, chapterId),
                    ))
              ])
            ],
          )),
    );
  }

  Widget _buildDetail(NovelDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailTop(detail),
        // 标签
        _buildTagWrap(controller.tags),
        // 操作按钮
        _buildBtnWrap(),
        const Divider(),
        // 小说简介
        Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: HtmlWidget(detail.description ?? ''),
          ),
        ),
        Obx(() => _buildRatingDetailPanel(controller.rateDetail.value))
      ],
    );
  }

  Widget _buildRatingDetailPanel(NovelDetailStar rateDetail) {
    return RatingDetailPanel(
      rating: double.tryParse(rateDetail.totalRate ?? '0') ?? 0,
      rateList: controller.rateList,
      onTap: () {},
    );
  }

  /// 顶部详情（标题、封面、作者、各种数据等）
  Widget _buildDetailTop(NovelDetail detail) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(children: [
        // 标题
        Text(
          '${detail.title}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ).paddingOnly(bottom: 6),
        // 封面 && 小说信息
        SizedBox(
                width: 200,
                child: AspectRatio(
                    aspectRatio: 0.6875, child: CachedImage(detail.img)))
            .paddingOnly(bottom: 6),
        // 作者 && 更新
        Wrap(
          children: [
            LinkText(
              detail.author,
              onTap: () => controller.toSearch(detail.author),
            ),
            const Text(' 著'),
            Text(' | ${detail.updateTime} 更新'),
          ],
        ).paddingOnly(bottom: 6),
        // 数据
        Wrap(
          children: [
            Text('${detail.favorite} 收藏'),
            Text(' / ${detail.views} 观看'),
            Text(' / ${detail.words} 字'),
            Text(' | ${detail.category}'),
          ],
        ),
      ]),
    );
  }

  /// 操作按钮
  Widget _buildBtnWrap() {
    List<ElevatedButton> btnList = [
      ElevatedButton.icon(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onPressed: () {},
          icon: const Icon(Icons.menu_book_outlined),
          label: const Text('阅读')),
    ];

    if (controller.detail.value.isFavorite != null &&
        controller.detail.value.isFavorite == true) {
      btnList.add(ElevatedButton.icon(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onPressed: () {},
          icon: const Icon(Icons.favorite),
          label: const Text('已收藏')));
    } else {
      btnList.add(ElevatedButton.icon(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onPressed: () {},
          icon: const Icon(Icons.favorite_outline),
          label: const Text('收藏')));
    }

    if (controller.detail.value.rawNovelLink != null) {
      btnList.add(ElevatedButton.icon(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onPressed: () =>
              controller.toNovelRaw(controller.detail.value.rawNovelLink!),
          icon: const Icon(Icons.raw_on),
          label: const Text('生肉')));
    }

    return Wrap(
      spacing: 6,
      children: btnList,
    );
  }

  /// 标签面板
  Widget _buildTagWrap(List<String> tags) {
    final tagsList = controller.tags.map((label) => ActionChip(
          label: Text(label, style: const TextStyle(fontSize: 12)),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () => controller.toSearch(label),
        ));

    return Wrap(
            spacing: 4,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            children: tagsList.toList())
        .paddingSymmetric(vertical: 12);
  }
}
