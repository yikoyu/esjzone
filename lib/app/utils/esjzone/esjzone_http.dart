/*
 * @Date: 2023-08-25 10:40:24
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 18:27:53
 * @FilePath: \esjzone\lib\app\utils\esjzone\esjzone_http.dart
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enum.dart';
import '../request/request.dart';
import 'esjzone_selector.dart';
import 'esjzone_url.dart';

class EsjzoneHttp {
  /// 获取小说列表页面
  static Future<String> getNovelListPage(
      {String? search,
      int page = 1,
      CategoryLabel category = CategoryLabel.all,
      SortLabel sort = SortLabel.updated}) async {
    late final String url;

    if (search != null && search.isNotEmpty) {
      url = EsjzoneUrl.GET_SEARCH_NOVEL_LIST(
          search: search,
          category: category.value,
          sort: sort.value,
          page: page);
    } else {
      url = EsjzoneUrl.GET_NOVEL_LIST(
          category: category.value, sort: sort.value, page: page);
    }

    debugPrint('获取列表 > $url');

    String data = await HttpUtils.get(url);

    return data;
  }

  /// 获取小说详情页
  static Future<String> getNovelDetialPage(String id) async {
    String data = await HttpUtils.get(EsjzoneUrl.GET_NOVEL_DETAIL(id: id));

    return data;
  }

  /// 获取小说阅读页
  static Future<String> getNovelReadPage(
      String novelId, String chapterId) async {
    String data = await HttpUtils.get(
        EsjzoneUrl.GET_NOVEL_READ(novelId: novelId, chapterId: chapterId));

    return data;
  }

  /// 我的收藏
  static Future<String> getMyFavoritePage(
      {required int page, bool isUpdate = false}) async {
    String data = await HttpUtils.get(
        EsjzoneUrl.GET_MY_FAVORITE(page: page, isUpdate: isUpdate));

    return data;
  }

  /// 获取授权
  static Future<String> _getActionAuth(url, {String errorTitle = '提示'}) async {
    dynamic loginData = await HttpUtils.post(url, form: true, data: {
      'plxf': 'getAuthToken',
    });

    String authCode = EsjzoneSelector.getAuthToken(loginData);

    if (authCode.isEmpty) {
      Get
        ..closeAllSnackbars()
        ..snackbar(errorTitle, '授权异常，请尝试重新登录',
            backgroundColor: Colors.red.shade200);

      return '';
    }

    return authCode;
  }

  /// 授权登录
  static Future<bool> login(
      {required String email, required String pwd}) async {
    HttpUtils.deleteAllCookie();
    // 获取授权
    String? authCode =
        await _getActionAuth(EsjzoneUrl.POST_MY_LOGIN, errorTitle: '登录失败');
    if (authCode.isEmpty) return false;

    // 登录
    dynamic data =
        await HttpUtils.post(EsjzoneUrl.POST_MEM_LOGIN, form: true, data: {
      'email': email,
      'pwd': pwd,
      'remember_me': 'on',
    }, headers: {
      'authorization': authCode
    });
    dynamic jsonData = jsonDecode(data.toString());

    if (jsonData['status'] != 200) {
      final String msg = utf8.decode(utf8.encode(jsonData['msg']));

      Get
        ..closeAllSnackbars()
        ..snackbar('登录异常', msg, backgroundColor: Colors.red.shade200);

      return false;
    }

    Get
      ..closeAllSnackbars()
      ..snackbar('提示', '登录成功');

    return true;
  }

  /// 小说收藏
  static Future<String?> memFavorite(String novelId) async {
    // 获取授权
    String? authCode = await _getActionAuth(
        EsjzoneUrl.GET_NOVEL_DETAIL(id: novelId),
        errorTitle: '收藏失败');
    if (authCode.isEmpty) return null;

    // 收藏
    dynamic data = await HttpUtils.post(EsjzoneUrl.POST_MEM_FAVORITE,
        headers: {'authorization': authCode});
    dynamic jsonData = jsonDecode(data.toString());

    if (jsonData['status'] != 200) {
      Get
        ..closeAllSnackbars()
        ..snackbar('收藏失败', '请稍后重试', backgroundColor: Colors.red.shade200);

      return null;
    }

    return '${jsonData['favorite']}';
  }

  // 小说点赞
  static Future<String?> forumLikes(String novelId, String chapterId) async {
    // 获取授权
    String? authCode = await _getActionAuth(
        EsjzoneUrl.GET_NOVEL_READ(novelId: novelId, chapterId: novelId),
        errorTitle: '点赞失败');
    if (authCode.isEmpty) return null;

    // 收藏
    dynamic data =
        await HttpUtils.post(EsjzoneUrl.POST_FORUM_LIKES, form: true, data: {
      'code': novelId,
      'id': chapterId,
    }, headers: {
      'authorization': authCode
    });
    dynamic jsonData = jsonDecode(data.toString());

    if (jsonData['status'] != 200) {
      Get
        ..closeAllSnackbars()
        ..snackbar('点赞失败', '请稍后重试', backgroundColor: Colors.red.shade200);

      return null;
    }

    return '${jsonData['likes']}';
  }
}
