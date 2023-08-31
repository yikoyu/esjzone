/*
 * @Date: 2023-08-24 16:18:30
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-24 16:33:46
 * @FilePath: \esjzone\lib\app\widgets\easy_refresh_container.dart
 */
import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class EasyRefreshContainer extends StatelessWidget {
  final EasyRefreshController? controller;
  final bool refreshOnStart;
  final FutureOr Function()? onRefresh;
  final FutureOr Function()? onLoad;
  final Widget? child;

  EasyRefreshContainer(
      {super.key,
      this.controller,
      this.refreshOnStart = true,
      this.onRefresh,
      this.onLoad,
      this.child});

  final Header header = ClassicHeader(
      dragText: 'pull_to_refresh'.tr,
      armedText: 'release_ready'.tr,
      readyText: 'refreshing'.tr,
      processingText: 'refreshing'.tr,
      processedText: 'succeeded'.tr,
      noMoreText: 'no_more'.tr,
      failedText: 'failed'.tr,
      messageText: 'last_updated_at_time'.tr);

  final Footer footer = ClassicFooter(
      infiniteOffset: 70,
      dragText: 'Pull_to_load'.tr,
      armedText: 'release_ready'.tr,
      readyText: 'loading'.tr,
      processingText: 'loading'.tr,
      processedText: 'succeeded'.tr,
      noMoreText: 'no_more'.tr,
      failedText: 'failed'.tr,
      messageText: 'last_updated_at_time'.tr);

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return EasyRefresh(
      controller: controller,
      refreshOnStart: refreshOnStart,
      refreshOnStartHeader: _refreshOnStartHeader(primary),
      header: header,
      footer: footer,
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: child,
    );
  }

  Header _refreshOnStartHeader(Color? color) {
    return BuilderHeader(
      triggerOffset: 70,
      clamping: true,
      position: IndicatorPosition.above,
      processedDuration: Duration.zero,
      builder: (ctx, state) {
        if (state.mode == IndicatorMode.inactive ||
            state.mode == IndicatorMode.done) {
          return const SizedBox();
        }

        return Container(
          padding: const EdgeInsets.only(bottom: 100),
          width: double.infinity,
          height: state.viewportDimension,
          alignment: Alignment.center,
          child: SpinKitFadingCube(
            size: 24,
            color: color,
          ),
        );
      },
    );
  }
}
