/*
 * @Date: 2023-08-18 16:30:37
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-23 12:33:47
 * @FilePath: \esjzone\lib\app\utils\enum.dart
 */
enum SortLabel {
  updated('latest_updates', '1'),
  merchant('newly_listed', '2'),
  score('top_rated', '3'),
  viewed('most_viewed', '4'),
  articles('most_articles', '5'),
  discussed('most_discussed', '6'),
  favorites('most_favorites', '7'),
  words('most_words', '8');

  const SortLabel(this.label, this.value);
  final String label;
  final String value;
}

enum CategoryLabel {
  all('all_novels', '0'),
  japan('japanese_novels', '1'),
  original('original_novels', '2'),
  korea('korean_novels', '3');

  const CategoryLabel(this.label, this.value);
  final String label;
  final String value;
}
