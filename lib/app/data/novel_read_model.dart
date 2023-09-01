/*
 * @Date: 2023-08-31 17:18:32
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-01 12:18:56
 * @FilePath: \esjzone\lib\app\data\novel_read_model.dart
 */
class NovelRead {
  String? novelId;
  String? novelName;
  String? likes;
  bool? isLike;
  String? chapterId;
  String? chapterName;
  String? chapterPrevId;
  String? chapterPrevName;
  String? chapterNextId;
  String? chapterNextName;
  String? contentHtml;
  String? authorId;
  String? authorName;
  String? updateTime;
  String? words;

  NovelRead(
      {this.novelId,
      this.novelName,
      this.likes,
      this.isLike,
      this.chapterId,
      this.chapterName,
      this.chapterPrevId,
      this.chapterPrevName,
      this.chapterNextId,
      this.chapterNextName,
      this.contentHtml,
      this.authorId,
      this.authorName,
      this.updateTime,
      this.words});

  NovelRead.fromJson(Map<String, dynamic> json) {
    novelId = json['novel_id'];
    novelName = json['novel_name'];
    likes = json['likes'];
    isLike = json['is_like'];
    chapterId = json['chapter_id'];
    chapterName = json['chapter_name'];
    chapterPrevId = json['chapter_prev_id'];
    chapterPrevName = json['chapter_prev_name'];
    chapterNextId = json['chapter_next_id'];
    chapterNextName = json['chapter_next_name'];
    contentHtml = json['content_html'];
    authorId = json['author_id'];
    authorName = json['author_name'];
    updateTime = json['update_time'];
    words = json['words'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['novel_id'] = novelId;
    data['novel_name'] = novelName;
    data['likes'] = likes;
    data['is_like'] = isLike;
    data['chapter_id'] = chapterId;
    data['chapter_name'] = chapterName;
    data['chapter_prev_id'] = chapterPrevId;
    data['chapter_prev_name'] = chapterPrevName;
    data['chapter_next_id'] = chapterNextId;
    data['chapter_next_name'] = chapterNextName;
    data['content_html'] = contentHtml;
    data['author_id'] = authorId;
    data['author_name'] = authorName;
    data['update_time'] = updateTime;
    data['words'] = words;
    return data;
  }
}
