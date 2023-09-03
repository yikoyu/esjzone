/*
 * @Date: 2023-08-25 10:42:23
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 17:17:19
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

  /// 小说详情页
  static String GET_NOVEL_DETAIL({required String id}) => '/detail/$id.html';

  /// 小说阅读页
  static String GET_NOVEL_READ(
          {required String novelId, required String chapterId}) =>
      '/forum/$novelId/$chapterId.html';

  /// 获取授权，发起 登录 需要使用
  static String POST_MY_LOGIN = '/my/login';

  /// 登录
  static String POST_MEM_LOGIN = '/inc/mem_login.php';

  /// 收藏
  static String POST_MEM_FAVORITE = '/inc/mem_favorite.php';

  // 章节点赞
  static String POST_FORUM_LIKES = '/inc/forum_likes.php';
}
