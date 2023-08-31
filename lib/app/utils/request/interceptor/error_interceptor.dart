import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  /// 是否有网
  Future<bool> _isConnected() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // 断网处理
    if (err.type == DioExceptionType.unknown) {
      bool isConnectNetWork = await _isConnected();
      if (!isConnectNetWork) {
        return super.onError(err.copyWith(message: '当前网络不可用，请检查您的网络'), handler);
      }
    }

    // error 统一处理
    AppException appException = AppException.create(err);
    // 错误提示
    debugPrint('ERROR[${err.requestOptions.path}]: ${appException.toString()}');

    return super.onError(err.copyWith(error: appException), handler);
  }
}

/// 自定义异常
class AppException implements Exception {
  final int _code;
  final String _message;

  AppException(this._code, this._message);

  @override
  String toString() {
    return "$_code$_message";
  }

  factory AppException.create(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return BadRequestException(-1, "请求取消");

      case DioExceptionType.connectionTimeout:
        return BadRequestException(-1, "连接超时");

      case DioExceptionType.sendTimeout:
        return BadRequestException(-1, "请求超时");

      case DioExceptionType.receiveTimeout:
        return BadRequestException(-1, "响应超时");

      case DioExceptionType.badResponse:
        {
          try {
            if (error.response == null) {
              return AppException(-1, "未知错误1");
            }

            int? errCode = error.response!.statusCode;

            if (errCode == null) {
              return AppException(-1, "未知错误2");
            }
            switch (errCode) {
              case 400:
                return BadRequestException(errCode, "请求语法错误");

              case 401:
                return UnauthorisedException(errCode, "没有权限");

              case 403:
                return UnauthorisedException(errCode, "服务器拒绝执行");

              case 404:
                return UnauthorisedException(errCode, "无法连接服务器");

              case 405:
                return UnauthorisedException(errCode, "请求方法被禁止");

              case 500:
                return UnauthorisedException(errCode, "服务器内部错误");

              case 502:
                return UnauthorisedException(errCode, "无效的请求");

              case 503:
                return UnauthorisedException(errCode, "服务器挂了");

              case 505:
                return UnauthorisedException(errCode, "不支持HTTP协议请求");

              default:
                return AppException(
                    errCode, error.response?.statusMessage ?? '未知错误3');
            }
          } on Exception catch (_) {
            return AppException(-1, "未知错误4");
          }
        }
      default:
        return AppException(-1, error.message ?? '未知错误5');
    }
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException(int code, String message) : super(code, message);
}

/// 未认证异常
class UnauthorisedException extends AppException {
  UnauthorisedException(int code, String message) : super(code, message);
}

class MyDioSocketException extends SocketException {
  @override
  MyDioSocketException(
    String message, {
    osError,
    address,
    port,
  }) : super(
          message,
          osError: osError,
          address: address,
          port: port,
        );
}
