/*
 * @Date: 2023-08-10 16:42:39
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-21 12:19:32
 * @FilePath: \esjzone\lib\app\utils\request\request.dart
 */
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'request_manager.dart';

class HttpUtils {
  static Future<CookieManager> _prepareJar() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('${directory.path}/.cookies/'),
    );
    return CookieManager(jar);
  }

  static Future<void> init(String baseUrl,
      {Duration connectTimeout = const Duration(seconds: 30),
      Duration receiveTimeout = const Duration(seconds: 30),
      Map<String, dynamic> headers = const {}}) async {
    // 获取持久化 cookie
    CookieManager cookieManager = await _prepareJar();

    RequestManager().init(baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: headers,
        cookieManager: cookieManager);
  }

  static void cancelRequests({required CancelToken token}) {
    RequestManager().cancelRequests(token: token);
  }

  static void deleteAllCookie() {
    RequestManager().deleteAllCookie();
  }

  static Future get(String path,
      {Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    return await RequestManager()
        .get(path, params: params, options: options, cancelToken: cancelToken);
  }

  static Future post(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Map<String, dynamic>? headers,
      CancelToken? cancelToken,
      bool form = false}) async {
    return await RequestManager().post(path,
        data: data,
        params: params,
        headers: headers,
        cancelToken: cancelToken,
        form: form);
  }

  static Future put(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    return await RequestManager().put(path,
        data: data, params: params, options: options, cancelToken: cancelToken);
  }

  static Future patch(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    return await RequestManager().patch(path,
        data: data, params: params, options: options, cancelToken: cancelToken);
  }

  static Future delete(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    return await RequestManager().delete(path,
        data: data, params: params, options: options, cancelToken: cancelToken);
  }
}
