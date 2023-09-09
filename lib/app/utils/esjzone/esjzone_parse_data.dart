/*
 * @Date: 2023-08-25 11:14:30
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-09 23:05:56
 * @FilePath: \esjzone\lib\app\utils\esjzone\esjzone_parse_data.dart
 */
import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:esjzone/app/data/my_favorite_list_model.dart';
import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/data/novel_detail_star_model.dart';
import 'package:esjzone/app/data/novel_list_model.dart';
import 'package:esjzone/app/data/novel_read_model.dart';

import 'esjzone_selector.dart';

class EsjzoneParseData {
  final Future<String> htmlData;

  EsjzoneParseData(this.htmlData);

  /// 获取页数和总页数
  Future<int?> getPagination() async {
    String data = await htmlData;
    return EsjzoneSelector.getPagination(data);
  }

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

  /// 获取评论列表
  Future<List<CommentList>> commentList() async {
    String data = await htmlData;
    return EsjzoneSelector.commentList(data);
  }

  /// 获取小说详情
  Future<NovelDetail> novelDetail() async {
    String data = await htmlData;
    return EsjzoneSelector.novelDetail(data);
  }

  /// 获取小说评分
  Future<NovelDetailStar> novelDetailStar() async {
    String data = await htmlData;
    return EsjzoneSelector.novelDetailStar(data);
  }

  /// 获取小说章节
  Future<List<NovelChapterList>> novelChapterList() async {
    String data = await htmlData;
    return EsjzoneSelector.novelChapterList(data);
  }

  /// 获取小说章节内容
  Future<NovelRead> novelChapterReadDetail() async {
    String data = await htmlData;
    return EsjzoneSelector.novelRead(data);
  }

  /// 获取我的收藏
  Future<List<MyFavoriteList>> myFavoriteList() async {
    String data = await htmlData;
    return EsjzoneSelector.myFavoriteList(data);
  }
}
