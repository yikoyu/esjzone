/*
 * @Date: 2023-08-25 10:40:24
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 12:11:27
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

  /// 授权登录
  static Future<void> login(
      {required String email, required String pwd}) async {
    HttpUtils.deleteAllCookie();
    // 获取授权
    dynamic loginData =
        await HttpUtils.post(EsjzoneUrl.POST_MY_LOGIN, form: true, data: {
      'plxf': 'getAuthToken',
    });

    String authorization = EsjzoneSelector.getAuthToken(loginData);

    if (authorization.isEmpty) {
      Get
        ..closeAllSnackbars()
        ..snackbar('登录异常', '授权异常，请重试', backgroundColor: Colors.red.shade200);

      return;
    }

    // 登录
    dynamic data =
        await HttpUtils.post(EsjzoneUrl.POST_MEM_LOGIN, form: true, data: {
      'email': email,
      'pwd': pwd,
      'remember_me': 'on',
    }, headers: {
      'authorization': authorization
    });
    dynamic jsonData = jsonDecode(data.toString());

    if (jsonData['status'] != 200) {
      final String msg = utf8.decode(utf8.encode(jsonData['msg']));

      Get
        ..closeAllSnackbars()
        ..snackbar('登录异常', msg, backgroundColor: Colors.red.shade200);

      return;
    }

    Get
      ..closeAllSnackbars()
      ..snackbar('提示', '登录成功');
  }
}
