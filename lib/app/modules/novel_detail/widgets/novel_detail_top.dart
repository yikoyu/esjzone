import 'package:esjzone/app/data/novel_detail_model.dart';
import 'package:esjzone/app/widgets/cached_image.dart';
import 'package:esjzone/app/widgets/link_text.dart';
import 'package:flutter/material.dart';

/// 顶部详情（标题、封面、作者、各种数据等）
class NovelDetailTop extends StatelessWidget {
  final NovelDetail detail;
  final void Function(String? author)? onTapAuthor;

  const NovelDetailTop({super.key, required this.detail, this.onTapAuthor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(children: [
        _buildTitle(detail.title),
        const SizedBox(height: 6),
        _buildCover(detail.img),
        const SizedBox(height: 6),
        _buildAuthorAndUpdate(
            author: detail.author, updateTime: detail.updateTime),
        const SizedBox(height: 6),
        _buildDetailData(
          favorite: detail.favorite,
          views: detail.views,
          words: detail.words,
          category: detail.category,
        ),
      ]),
    );
  }

  /// 标题
  Widget _buildTitle(String? title) {
    return Text(
      title ?? '',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  /// 封面 && 小说信息
  Widget _buildCover(String? cover) {
    return SizedBox(
        width: 200,
        child: AspectRatio(aspectRatio: 0.6875, child: CachedImage(cover)));
  }

  /// 作者 && 更新
  Widget _buildAuthorAndUpdate({
    String? author = '--',
    String? updateTime = '--',
  }) {
    return Wrap(
      children: [
        LinkText(
          author,
          onTap: () => onTapAuthor?.call(author),
        ),
        const Text(' 著'),
        Text(' | $updateTime 更新'),
      ],
    );
  }

  /// 数据
  Widget _buildDetailData({
    String? favorite = '0',
    String? views = '0',
    String? words = '0',
    String? category = '--',
  }) {
    return Wrap(
      children: [
        Text('$favorite 收藏'),
        Text(' / $views 观看'),
        Text(' / $words 字'),
        Text(' | $category'),
      ],
    );
  }
}
