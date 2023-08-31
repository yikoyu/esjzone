/*
 * @Date: 2023-08-15 14:38:07
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-18 20:58:40
 * @FilePath: \esjzone\lib\app\data\novel_list_model.dart
 */
class NovelList {
  String? title;
  String? link;
  String? img;
  String? author;
  String? lastEp;
  String? lastEpLink;
  String? stars;
  String? words;
  String? views;
  String? favorite;
  String? feathers;
  String? messages;
  bool? xRated;

  NovelList(
      {this.title,
      this.link,
      this.img,
      this.author,
      this.lastEp,
      this.lastEpLink,
      this.stars,
      this.words,
      this.views,
      this.favorite,
      this.feathers,
      this.messages,
      this.xRated});

  NovelList.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    link = json['link'];
    img = json['img'];
    author = json['author'];
    lastEp = json['last_ep'];
    lastEpLink = json['last_ep_link'];
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
    data['title'] = title;
    data['link'] = link;
    data['img'] = img;
    data['author'] = author;
    data['last_ep'] = lastEp;
    data['last_ep_link'] = lastEpLink;
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
