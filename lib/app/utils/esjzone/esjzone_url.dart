/*
 * @Date: 2023-08-25 10:42:23
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-25 11:14:42
 * @FilePath: \esjzone\lib\app\utils\esjzone\esjzone_url.dart
 */
// ignore_for_file: non_constant_identifier_names

abstract class EsjzoneUrl {
  EsjzoneUrl._();

  /// 小说列表页
  static String GET_NOVEL_LIST({
    required String category,
    required String sort,
    required int page,
  }) =>
      '/list-$category$sort/$page.html';

  /// 小说列表搜索页
  static String GET_SEARCH_NOVEL_LIST({
    required String search,
    required String category,
    required String sort,
    required int page,
  }) =>
      '/tags-$category$sort/$search/$page.html';

  /// 获取授权，发起 登录 需要使用
  static String POST_MY_LOGIN = '/my/login';

  /// 登录
  static String POST_MEM_LOGIN = '/inc/mem_login.php';
}
