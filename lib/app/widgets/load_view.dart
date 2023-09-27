/*
 * @Date: 2023-09-01 22:19:20
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-02 19:57:40
 * @FilePath: \esjzone\lib\app\widgets\load_view.dart
 */
import 'package:esjzone/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingView extends StatefulWidget {
  final Widget child;
  final LoadingViewController? controller;
  final LoadingViewStatus initLoadingStatus;
  final bool showErrorBack;
  final String networkBlockedDesc;
  final String emptyDesc;
  final String errorDesc;
  final Function()? onEmptyTap;
  final Function()? onNetworkBlockedTap;
  final Function()? onErrorTap;

  const LoadingView(
      {super.key,
      required this.child,
      this.controller,
      this.showErrorBack = true,
      this.initLoadingStatus = LoadingViewStatus.idle,
      this.networkBlockedDesc = '网络连接超时，请检查你的网络环境',
      this.emptyDesc = '暂无相关数据',
      this.errorDesc = '加载失败，请稍后再试',
      this.onEmptyTap,
      this.onNetworkBlockedTap,
      this.onErrorTap});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  LoadingViewStatus loadingStatus = LoadingViewStatus.idle;

  @override
  void initState() {
    super.initState();

    loadingStatus = widget.initLoadingStatus;

    if (widget.controller != null &&
        widget.controller!.loadingStatus != LoadingViewStatus.idle) {
      loadingStatus = widget.controller!.loadingStatus;
    }

    if (widget.controller != null) {
      widget.controller!.addListener(onListener);
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(onListener);
    }

    super.dispose();
  }

  void onListener() {
    setState(() {
      debugPrint('loadingStatus > ${widget.controller!.loadingStatus}');
      loadingStatus = widget.controller!.loadingStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (loadingStatus) {
      case LoadingViewStatus.idle:
        return widget.child;
      case LoadingViewStatus.loading:
        return _buildLoadingView(context);
      case LoadingViewStatus.loading_suc:
        return widget.child;
      case LoadingViewStatus.loading_suc_but_empty:
        return _buildLoadingSucButEmptyView();
      case LoadingViewStatus.network_blocked:
        return _buildNetworkBlockedView(context);
      case LoadingViewStatus.error:
        return _buildErrorView();
      case LoadingViewStatus.not_login:
        return _buildNotLoginView();
    }
  }

  /// 加载中 view
  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: SpinKitFadingCube(
        size: 24,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  /// 加载成功但数据为空 View
  Widget _buildLoadingSucButEmptyView() {
    return _buildGeneralTapView(
      desc: widget.emptyDesc,
      onPressed: widget.onEmptyTap,
      child: Image.asset(
        'assets/images/load-data-empty.png',
        width: 150,
      ),
    );
  }

  /// 网络加载错误页面
  Widget _buildNetworkBlockedView(BuildContext context) {
    return _buildGeneralTapView(
      desc: widget.networkBlockedDesc,
      onPressed: widget.onNetworkBlockedTap,
      child: Icon(
        Icons.wifi_off,
        size: 150,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  /// 加载错误页面
  Widget _buildErrorView() {
    return _buildGeneralTapView(
      desc: widget.errorDesc,
      onPressed: widget.onErrorTap,
      child: Image.asset(
        'assets/images/load-data-error.png',
        width: 150,
      ),
    );
  }

  // 需要登录
  Widget _buildNotLoginView() {
    return _buildGeneralTapView(
      desc: '你还未登录，请登录',
      buttonText: '登 录',
      onPressed: () => Get.toNamed(Routes.LOGIN),
      child: Image.asset(
        'assets/images/load-data-error.png',
        width: 150,
      ),
    );
  }

  // 通用错误页面面板
  Widget _buildGeneralTapView(
      {required Widget child,
      required String desc,
      String buttonText = '点击重试',
      void Function()? onPressed}) {
    final Widget errorWidget = Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            Text(desc).paddingOnly(top: 12),
            onPressed != null
                ? ElevatedButton(
                        onPressed: onPressed,
                        style: const ButtonStyle(
                            visualDensity: VisualDensity.compact),
                        child: Text(buttonText))
                    .paddingOnly(top: 12)
                : const SizedBox()
          ]),
    );

    if (widget.showErrorBack) {
      return Scaffold(
        appBar: AppBar(),
        body: errorWidget,
      );
    }

    return errorWidget;
  }
}

class LoadingViewController extends ChangeNotifier {
  LoadingViewStatus loadingStatus = LoadingViewStatus.idle;

  void loading() {
    loadingStatus = LoadingViewStatus.loading;
    notifyListeners();
  }

  void success() {
    loadingStatus = LoadingViewStatus.loading_suc;
    notifyListeners();
  }

  void error() {
    loadingStatus = LoadingViewStatus.error;
    notifyListeners();
  }

  void empty() {
    loadingStatus = LoadingViewStatus.loading_suc_but_empty;
    notifyListeners();
  }

  void networkBlocked() {
    loadingStatus = LoadingViewStatus.network_blocked;
    notifyListeners();
  }

  void notLogin() {
    loadingStatus = LoadingViewStatus.not_login;
    notifyListeners();
  }

  /// 更新LoadingStatus
  void updateStatus(LoadingViewStatus status) {
    loadingStatus = status;
    notifyListeners();
  }
}

/// 状态枚举
enum LoadingViewStatus {
  idle, // 初始化
  loading, // 加载中
  loading_suc, // 加载成功
  loading_suc_but_empty, // 加载成功但是数据为空
  network_blocked, // 网络加载错误
  error, // 加载错误
  not_login, // 未登录
}
