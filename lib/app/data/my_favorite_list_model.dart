class MyFavoriteList {
  String? novelName;
  String? novelId;
  String? lastChapterId;
  String? lastChapterName;
  String? lastWatch;
  String? updateTime;

  MyFavoriteList(
      {this.novelName,
      this.novelId,
      this.lastChapterId,
      this.lastChapterName,
      this.lastWatch,
      this.updateTime});

  MyFavoriteList.fromJson(Map<String, dynamic> json) {
    novelName = json['novel_name'];
    novelId = json['novel_id'];
    lastChapterId = json['last_chapter_id'];
    lastChapterName = json['last_chapter_name'];
    lastWatch = json['last_watch'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['novel_name'] = novelName;
    data['novel_id'] = novelId;
    data['last_chapter_id'] = lastChapterId;
    data['last_chapter_name'] = lastChapterName;
    data['last_watch'] = lastWatch;
    data['update_time'] = updateTime;
    return data;
  }
}
