/*
 * @Date: 2023-08-24 13:40:08
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 21:41:02
 * @FilePath: \esjzone\lib\app\modules\searching\views\searching_view.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:esjzone/app/widgets/app_bar_search.dart';

import 'package:get/get.dart';

import '../controllers/searching_controller.dart';

class SearchingView extends GetView<SearchingController> {
  const SearchingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SearchingController());

    debugPaintSizeEnabled = false;

    return Scaffold(
      appBar: AppBarSearch(
        toolbarHeight: 36,
        autofocus: true,
        focusNode: controller.focusNode,
        onSearch: controller.onSearch,
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistory(), // 历史搜索
            _buildHot() // 热门搜索
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.historyTagList.isNotEmpty
              ? [
                  _buildTagTitle(
                      title: '历史搜索',
                      action: _buildDeleteIcon(controller.onDeleteHistory)),
                  _buildTagWrap(controller.historyTagList, controller.goResult)
                      .paddingOnly(bottom: 48)
                ]
              : [],
        ));
  }

  Widget _buildHot() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: controller.hotTagList.isNotEmpty
              ? [
                  _buildTagTitle(title: '热门搜索'),
                  Obx(() =>
                      _buildTagWrap(controller.hotTagList, controller.goResult))
                ]
              : [],
        ));
  }

  Widget _buildTagTitle({required String title, Widget? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        action ?? const SizedBox()
      ],
    );
  }

  Widget _buildTagWrap(
      List<String> tags, void Function(String tag)? onPressed) {
    return Wrap(
      spacing: 6,
      children: tags
          .map((label) => ActionChip(
                label: Text(label),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  onPressed?.call(label);
                },
              ))
          .toList(),
    );
  }

  Widget _buildDeleteIcon(void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        Icons.delete_forever,
        color: Colors.red.shade800,
      ),
    );
  }
}
