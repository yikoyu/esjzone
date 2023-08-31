/*
 * @Date: 2023-08-27 13:35:09
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-27 13:39:13
 * @FilePath: \esjzone\lib\app\data\novel_chapter_list_model.dart
 */
class NovelChapterList {
  String? type;
  String? title;
  String? titleHtml;
  String? link;
  String? novelId;
  String? chapterId;
  List<NovelChapterList>? chapters;

  NovelChapterList(
      {this.type,
      this.title,
      this.titleHtml,
      this.link,
      this.novelId,
      this.chapterId});

  NovelChapterList.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    titleHtml = json['title_html'];
    link = json['link'];
    novelId = json['novel_id'];
    chapterId = json['chapter_id'];
    if (json['chapters'] != null) {
      chapters = <NovelChapterList>[];
      json['chapters'].forEach((v) {
        chapters?.add(NovelChapterList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['title'] = title;
    data['title_html'] = titleHtml;
    data['link'] = link;
    data['novel_id'] = novelId;
    data['chapter_id'] = chapterId;
    if (chapters != null) {
      data['chapters'] = chapters?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
