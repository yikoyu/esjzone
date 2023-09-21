/*
 * @Date: 2023-08-25 21:13:44
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 21:39:35
 * @FilePath: \esjzone\lib\app\utils\app_storage.dart
 */
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppStorage<T> {
  final storage = GetStorage();
  final AppStorageKeys storageKeys;
  void Function()? _disposeListen;

  AppStorage(this.storageKeys);

  T? read() {
    return storage.read<T>(storageKeys.key);
  }

  List<dynamic>? readList() {
    return storage.read(storageKeys.key);
  }

  void write(T data) {
    storage.write(storageKeys.key, data);
  }

  void remove() {
    storage.remove(storageKeys.key);
  }

  void listenKey(ValueSetter callback) {
    _disposeListen = storage.listenKey(storageKeys.key, callback);
  }

  void disposeListen() {
    _disposeListen?.call();
  }
}

enum AppStorageKeys {
  /// 搜过的关键词
  searchHistoryTagList('search_history_tag_list'),
  settingLikeNovelCategory('setting_like_novel_category');

  const AppStorageKeys(this.key);
  final String key;
}
