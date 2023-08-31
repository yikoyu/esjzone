/*
 * @Date: 2023-08-10 15:56:49
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-10 15:58:35
 * @FilePath: \esjzone\lib\app\utils\request\interceptor\request_interceptor.dart
 */
import 'package:dio/dio.dart';

/// 错误处理拦截器
class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    RequestOptions resOptions = options.copyWith(
      headers: {
        "Content-Type": "application/json",
        // 'Authorization': 'Bearer $accessToken',
      },
    );
    return super.onRequest(resOptions, handler);
  }
}
