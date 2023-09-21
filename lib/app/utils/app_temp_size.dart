import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AppTempSize {
  /// 获取文件大小
  static Future<String> size() async {
    final tempDir = await getTemporaryDirectory();
    double tempSize = await _getTotalSizeOfFilesInDir(tempDir);
    return _renderSize(tempSize);
  }

  /// 删除缓存文件
  static Future<void> delete({FileSystemEntity? file}) async {
    final tempDir = file ?? await getTemporaryDirectory();

    if (tempDir is Directory && tempDir.existsSync()) {
      debugPrint('delete file path > ${tempDir.path}');
      final List<FileSystemEntity> children =
          tempDir.listSync(recursive: true, followLinks: true);
      for (final FileSystemEntity child in children) {
        await delete(file: child);
      }
    }
    try {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    } catch (err) {
      debugPrint('delDir error > $err');
    }
  }

  /// 递归方式 计算文件的大小
  static Future<double> _getTotalSizeOfFilesInDir(
      final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        for (final FileSystemEntity child in children) {
          total += await _getTotalSizeOfFilesInDir(child);
        }
        return total;
      }
      return 0;
    } catch (e) {
      debugPrint('_getTotalSizeOfFilesInDir error > $e');
      return 0;
    }
  }

  /// 格式化储存单位
  static String _renderSize(double value) {
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
