/*
 * @Date: 2023-08-10 15:38:41
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-23 13:31:58
 * @FilePath: \esjzone\lib\app\utils\request\request_manager.dart
 */
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';

import 'interceptor/error_interceptor.dart';
import 'interceptor/request_interceptor.dart';

class RequestManager {
  static late final Dio dio;
  late CookieManager? cookie;
  final CancelToken _cancelToken = CancelToken();

  static final RequestManager _instance = RequestManager._internal();

  // 单例模式使用Http类，
  factory RequestManager() => _instance;

  RequestManager._internal() {
    BaseOptions options = BaseOptions();

    dio = Dio(options);

    // 添加request拦截器
    dio.interceptors.add(RequestInterceptor());
    // 添加error拦截器
    dio.interceptors.add(ErrorInterceptor());
    // 添加cache拦截器
    // dio.interceptors.add(NetCacheInterceptor());
    // 添加retry拦截器
    // dio.interceptors.add(
    //   RetryOnConnectionChangeInterceptor(
    //     requestRetrier: DioConnectivityRequestRetrier(
    //       dio: dio,
    //       connectivity: Connectivity(),
    //     ),
    //   ),
    // );
  }

  /// 初始化公共属性
  void init(String baseUrl,
      {Duration connectTimeout = const Duration(seconds: 30),
      Duration receiveTimeout = const Duration(seconds: 30),
      Map<String, dynamic> headers = const {},
      List<Interceptor>? interceptors,
      CookieManager? cookieManager}) {
    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: headers,
    );

    if (cookieManager != null) {
      cookie = cookieManager;
      dio.interceptors.add(cookieManager);

      debugPrintCookie(baseUrl);
    }

    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
  }

  void debugPrintCookie(String uri) {
    cookie!.cookieJar
        .loadForRequest(Uri.parse(uri))
        .then((value) => debugPrint('loadForRequest >> $value'));
  }

  /// 关闭 dio
  void cancelRequests({required CancelToken token}) {
    _cancelToken.cancel("cancelled");
  }

  //删除全部cookie
  void deleteAllCookie() {
    cookie?.cookieJar.deleteAll();
  }

  Future get(String path,
      {Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();
    // requestOptions = requestOptions.copyWith(
    //   extra: {
    //     "refresh": refresh,
    //     "noCache": noCache,
    //     "cacheKey": cacheKey,
    //     "cacheDisk": cacheDisk,
    //   },
    // );
    // Map<String, dynamic>? _authorization = getAuthorizationHeader();
    // if (_authorization != null) {
    //   requestOptions = requestOptions.copyWith(headers: _authorization);
    // }

    Response res = await dio.get(path,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);

    return res.data;
  }

  Future post(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Map<String, dynamic>? headers,
      CancelToken? cancelToken,
      bool form = false}) async {
    Options requestOptions = Options(headers: headers);

    Response res = await dio.post(path,
        data: form && data is Map<String, dynamic>
            ? FormData.fromMap(data)
            : data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);

    return res.data;
  }

  Future put(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();

    Response res = await dio.put(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);

    return res.data;
  }

  Future patch(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();

    Response res = await dio.patch(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);

    return res.data;
  }

  Future delete(String path,
      {Object? data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken}) async {
    Options requestOptions = options ?? Options();

    Response res = await dio.delete(path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken);

    return res.data;
  }
}
