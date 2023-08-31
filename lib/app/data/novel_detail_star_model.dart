/*
 * @Date: 2023-08-26 20:59:13
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-30 17:48:33
 * @FilePath: \esjzone\lib\app\data\novel_detail_star_model.dart
 */
class NovelDetailStar {
  String? totalRate;
  String? oneRate;
  String? twoRate;
  String? threeRate;
  String? fourRate;
  String? fiveRate;

  NovelDetailStar(
      {this.totalRate,
      this.oneRate,
      this.twoRate,
      this.threeRate,
      this.fourRate,
      this.fiveRate});

  NovelDetailStar.fromJson(Map<String, dynamic> json) {
    totalRate = json['totalRate'];
    oneRate = json['oneRate'];
    twoRate = json['twoRate'];
    threeRate = json['threeRate'];
    fourRate = json['fourRate'];
    fiveRate = json['fiveRate'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['totalRate'] = totalRate;
    data['oneRate'] = oneRate;
    data['twoRate'] = twoRate;
    data['threeRate'] = threeRate;
    data['fourRate'] = fourRate;
    data['fiveRate'] = fiveRate;
    return data;
  }
}
