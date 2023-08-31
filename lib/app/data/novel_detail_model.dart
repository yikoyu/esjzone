class NovelDetail {
  String? category;
  String? author;
  String? otherTitle;
  String? rawNovelLink;
  String? updateTime;
  String? img;
  String? title;
  String? views;
  String? favorite;
  String? words;
  bool? isFavorite;
  List<RelatedLinkList>? relatedLinkList;
  String? description;

  NovelDetail(
      {this.category,
      this.author,
      this.otherTitle,
      this.rawNovelLink,
      this.updateTime,
      this.img,
      this.title,
      this.views,
      this.favorite,
      this.words,
      this.isFavorite,
      this.relatedLinkList,
      this.description});

  NovelDetail.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    author = json['author'];
    otherTitle = json['other_title'];
    rawNovelLink = json['raw_novel_link'];
    updateTime = json['update_time'];
    img = json['img'];
    title = json['title'];
    views = json['views'];
    favorite = json['favorite'];
    words = json['words'];
    isFavorite = json['isFavorite'];
    if (json['relatedLinkList'] != null) {
      relatedLinkList = <RelatedLinkList>[];
      json['relatedLinkList'].forEach((v) {
        relatedLinkList?.add(RelatedLinkList.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['category'] = category;
    data['author'] = author;
    data['other_title'] = otherTitle;
    data['raw_novel_link'] = rawNovelLink;
    data['update_time'] = updateTime;
    data['img'] = img;
    data['title'] = title;
    data['views'] = views;
    data['favorite'] = favorite;
    data['words'] = words;
    data['isFavorite'] = isFavorite;
    if (relatedLinkList != null) {
      data['relatedLinkList'] =
          relatedLinkList?.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    return data;
  }
}

class RelatedLinkList {
  String? href;
  String? text;

  RelatedLinkList({this.href, this.text});

  RelatedLinkList.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['href'] = href;
    data['text'] = text;
    return data;
  }
}
