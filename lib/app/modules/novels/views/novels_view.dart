/*
 * @Date: 2023-08-15 15:11:36
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 12:22:11
 * @FilePath: \esjzone\lib\app\modules\novels\views\novels_view.dart
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esjzone/app/widgets/load_view.dart';
import 'package:flutter/material.dart';
import 'package:esjzone/app/modules/searching/views/searching_view.dart';
import 'package:esjzone/app/widgets/app_bar_search.dart';
import 'package:esjzone/app/widgets/easy_refresh_container.dart';
import 'package:esjzone/app/widgets/filter_bar.dart';
import 'package:esjzone/app/widgets/novel_list_card.dart';

import 'package:get/get.dart';

import '../controllers/novels_controller.dart';
import '../widget/profile_drawer.dart';

class NovelsView extends GetView<NovelsController> {
  const NovelsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NovelsController());

    return Scaffold(
      drawerEdgeDragWidth: 100,
      drawer: const ProfileDrawer(),
      appBar: AppBarSearch(
        toolbarHeight: 36,
        enabled: false,
        leading: Obx(() => _buildLeading(controller.loginUser.avatar.value)),
        bottom: FilterBar(
            initCategory: controller.categoryValue,
            onChanged: controller.onFilterChange),
        onTap: () =>
            Get.to(() => const SearchingView(), transition: Transition.fadeIn),
      ),
      body: LoadingView(
        showErrorBack: false,
        controller: controller.loadingViewController,
        onEmptyTap: controller.onLoad,
        onErrorTap: controller.onLoad,
        onNetworkBlockedTap: controller.onLoad,
        child: EasyRefreshContainer(
          controller: controller.easyRefreshController,
          onRefresh: () => controller.getNovelListData(refresh: true),
          onLoad: () => controller.getNovelListData(),
          child: Obx(() => ListView.builder(
                itemCount: controller.novelList.length,
                itemBuilder: (BuildContext item, int i) {
                  return NovelListCard(controller.novelList[i]);
                },
              )),
        ),
      ),
    );
  }

  Widget _buildLeading(String avatar) {
    const AssetImage defaultBackgroundImage =
        AssetImage('assets/images/avatar-default.png');

    CircleAvatar avatarWidget = avatar.isNotEmpty
        ? CircleAvatar(backgroundImage: CachedNetworkImageProvider(avatar))
        : const CircleAvatar(backgroundImage: defaultBackgroundImage);

    return Center(
        child: Builder(
            builder: (context) => GestureDetector(
                  onTap: () {
                    // 切换Drawer的打开和关闭状态
                    Scaffold.of(context).openDrawer();
                  },
                  child: avatarWidget,
                )));
  }
}
