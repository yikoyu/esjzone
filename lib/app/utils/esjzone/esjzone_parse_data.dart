/*
 * @Date: 2023-08-25 11:14:30
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 11:34:24
 * @FilePath: \esjzone\lib\app\utils\esjzone\esjzone_parse_data.dart
 */
import 'package:esjzone/app/data/novel_list_model.dart';

import 'esjzone_selector.dart';

class EsjzoneParseData {
  final Future<String> htmlData;

  EsjzoneParseData(this.htmlData);

  /// 获取小说列表
  Future<List<NovelList>> novelList() async {
    String data = await htmlData;
    return EsjzoneSelector.novelList(data);
  }

  /// 获取热门标签列表
  Future<List<String>> hotTagList() async {
    String data = await htmlData;
    return EsjzoneSelector.hotTagList(data);
  }
}
