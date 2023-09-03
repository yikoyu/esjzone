/*
 * @Date: 2023-08-15 14:38:07
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 16:51:08
 * @FilePath: \esjzone\lib\app\data\novel_list_model.dart
 */
class NovelList {
  String? id;
  String? title;
  String? link;
  String? img;
  String? author;
  String? lastEp;
  String? lastEpLink;
  String? lastChapterId;
  String? stars;
  String? words;
  String? views;
  String? favorite;
  String? feathers;
  String? messages;
  bool? xRated;

  NovelList(
      {this.id,
      this.title,
      this.link,
      this.img,
      this.author,
      this.lastEp,
      this.lastEpLink,
      this.lastChapterId,
      this.stars,
      this.words,
      this.views,
      this.favorite,
      this.feathers,
      this.messages,
      this.xRated});

  NovelList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    img = json['img'];
    author = json['author'];
    lastEp = json['last_ep'];
    lastEpLink = json['last_ep_link'];
    lastChapterId = json['last_chapter_id'];
    stars = json['stars'];
    words = json['words'];
    views = json['views'];
    favorite = json['favorite'];
    feathers = json['feathers'];
    messages = json['messages'];
    xRated = json['x_rated'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['link'] = link;
    data['img'] = img;
    data['author'] = author;
    data['last_ep'] = lastEp;
    data['last_ep_link'] = lastEpLink;
    data['last_chapter_id'] = lastChapterId;
    data['stars'] = stars;
    data['words'] = words;
    data['views'] = views;
    data['favorite'] = favorite;
    data['feathers'] = feathers;
    data['messages'] = messages;
    data['x_rated'] = xRated;
    return data;
  }
}
