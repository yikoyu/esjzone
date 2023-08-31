/*
 * @Date: 2023-08-26 14:49:57
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-26 14:51:57
 * @FilePath: \esjzone\lib\app\data\comment_list_model.dart
 */
class CommentList {
  String? poster;
  String? posterLink;
  String? posterUid;
  String? floor;
  String? createTime;
  String? replyFrom;
  String? replyTo;
  String? replyToHtml;

  CommentList(
      {this.poster,
      this.posterLink,
      this.posterUid,
      this.floor,
      this.createTime,
      this.replyFrom,
      this.replyTo,
      this.replyToHtml});

  CommentList.fromJson(Map<String, dynamic> json) {
    poster = json['poster'];
    posterLink = json['poster_link'];
    posterUid = json['poster_uid'];
    floor = json['floor'];
    createTime = json['create_time'];
    replyFrom = json['reply_from'];
    replyTo = json['reply_to'];
    replyToHtml = json['reply_to_html'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['poster'] = poster;
    data['poster_link'] = posterLink;
    data['poster_uid'] = posterUid;
    data['floor'] = floor;
    data['create_time'] = createTime;
    data['reply_from'] = replyFrom;
    data['reply_to'] = replyTo;
    data['reply_to_html'] = replyToHtml;
    return data;
  }
}
