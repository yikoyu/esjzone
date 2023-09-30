import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NovelDetailActions extends StatelessWidget {
  final String? activeChapterId;
  final bool? isFavorite;
  final String? rawNovelLink;
  final void Function()? onTapRead;
  final void Function()? onTapFavorite;

  const NovelDetailActions(
      {super.key,
      this.activeChapterId,
      this.isFavorite,
      this.rawNovelLink,
      this.onTapRead,
      this.onTapFavorite});

  bool get hasHistory => activeChapterId != null && activeChapterId!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    List<ElevatedButton> btnList = [_buildReadButton(), _buildFavoriteButton()];

    if (rawNovelLink != null) {
      btnList.add(_buildRawNovelButton());
    }

    return Wrap(
      spacing: 6,
      children: btnList,
    );
  }

  /// 阅读按钮
  ElevatedButton _buildReadButton() {
    return ElevatedButton.icon(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: onTapRead,
        icon: const Icon(Icons.menu_book_outlined),
        label: hasHistory
            ? const Text('继续阅读', style: TextStyle(fontSize: 12))
            : const Text('阅读', style: TextStyle(fontSize: 12)));
  }

  /// 收藏按钮
  ElevatedButton _buildFavoriteButton() {
    if (isFavorite != null && isFavorite == true) {
      return ElevatedButton.icon(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onPressed: onTapFavorite,
          icon: const Icon(Icons.favorite),
          label: const Text('已收藏', style: TextStyle(fontSize: 12)));
    }

    return ElevatedButton.icon(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: onTapFavorite,
        icon: const Icon(Icons.favorite_outline),
        label: const Text(
          '收藏',
          style: TextStyle(fontSize: 12),
        ));
  }

  /// 跳转生肉
  ElevatedButton _buildRawNovelButton() {
    return ElevatedButton.icon(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: () => toNovelRaw(rawNovelLink!),
        icon: const Icon(Icons.raw_on),
        label: const Text('生肉', style: TextStyle(fontSize: 12)));
  }

  void toNovelRaw(String url) {
    launchUrl(Uri.parse(url));
  }
}
