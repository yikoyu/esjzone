/*
 * @Date: 2023-08-24 13:40:07
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-01 20:14:29
 * @FilePath: \esjzone\lib\app\modules\searching\controllers\searching_controller.dart
 */
import 'package:flutter/material.dart';
import 'package:esjzone/app/modules/search_novels/views/search_novels_view.dart';
import 'package:esjzone/app/utils/app_storage.dart';
import 'package:get/get.dart';

class SearchingController extends GetxController {
  final storage = AppStorage<List<String>>(AppStorageKeys.searchHistoryTagList);
  final FocusNode focusNode = FocusNode();

  var historyTagList = <String>[].obs;

  @override
  void onInit() {
    final cacheList = storage.readList();

    if (cacheList != null) {
      historyTagList
        ..clear()
        ..addAll(cacheList.map((tag) => tag.toString()).toList());
    }

    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    super.onClose();
  }

  void onDeleteHistory() {
    historyTagList.clear();
    storage.remove();
  }

  /// 搜索事件
  Future<void> onSearch(String value) async {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return;
    }

    goResult(value);
  }

  /// 前往搜索结果页
  Future<void> goResult(String value) async {
    if (!historyTagList.contains(value)) {
      historyTagList.insert(0, value);
      storage.write(historyTagList);
    }

    await Get.to(() => SearchNovelsView(uniqueTag: value),
        arguments: {'search': value}, transition: Transition.fadeIn);

    debugPrint('返回');
    focusNode.requestFocus();
  }
}
