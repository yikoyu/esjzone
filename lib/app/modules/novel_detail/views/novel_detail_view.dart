/*
 * @Date: 2023-08-26 10:37:13
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 16:42:16
 * @FilePath: \esjzone\lib\app\modules\novel_detail\views\novel_detail_view.dart
 */
import 'dart:ui';

import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/modules/novel_detail/widgets/rating_detail_panel.dart';
import 'package:esjzone/app/widgets/cached_image.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:esjzone/app/widgets/novel/novel_chapters_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:get/get.dart';

import '../controllers/novel_detail_controller.dart';
import '../widgets/novel_detail_actions.dart';
import '../widgets/novel_detail_top.dart';

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
          onEmptyTap: controller.getNovelDetailData,
          onErrorTap: controller.getNovelDetailData,
          onNetworkBlockedTap: controller.getNovelDetailData,
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
                ..._buildSlivers()
              ])
            ],
          )),
    );
  }

  List<Widget> _buildSlivers() {
    return [
      SliverPadding(
          padding: const EdgeInsets.all(6),
          sliver: SliverToBoxAdapter(
            child: Obx(() => _buildDetail(controller.detail.value)),
          )),
      const SliverToBoxAdapter(child: Divider()),
      Obx(() => NovelChaptersList(
            activeChapterId: controller.detail.value.activeChapterId,
            chapterList: controller.chapterList,
            onTap: ({novelId, chapterId}) =>
                controller.toNovelRead(novelId, chapterId),
          ))
    ];
  }

  Widget _buildDetail(NovelDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NovelDetailTop(detail: detail),
        // 标签
        const SizedBox(height: 12),
        _buildTagWrap(controller.tags),
        const SizedBox(height: 12),
        // 操作按钮
        // _buildBtnWrap(),
        NovelDetailActions(
          activeChapterId: controller.detail.value.activeChapterId,
          isFavorite: controller.detail.value.isFavorite,
          rawNovelLink: controller.detail.value.rawNovelLink,
          onTapRead: controller.onHandleStartRead,
          onTapFavorite: controller.onHandleFavorite,
        ),
        const Divider(),
        // 小说简介
        Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: HtmlWidget(detail.description ?? ''),
          ),
        ),
        RatingDetailPanel(
          rating:
              double.tryParse(controller.rateDetail.value.totalRate ?? '0') ??
                  0,
          rateList: controller.rateList,
          onTap: () {},
        ),
      ],
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
        children: tagsList.toList());
  }
}
