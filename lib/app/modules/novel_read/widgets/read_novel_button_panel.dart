import 'package:flutter/material.dart';

class ReadNovelButtonPanel extends StatelessWidget {
  final String? chapterPrevId;
  final String? novelId;
  final String? chapterNextId;
  final Function({String? novelId, String? chapterId})? onTapChapter;

  const ReadNovelButtonPanel(
      {super.key,
      this.chapterPrevId,
      this.novelId,
      this.chapterNextId,
      this.onTapChapter});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPrevButton(),
            // _buildChapterButton(),
            _buildNextButton(),
          ],
        ));
  }

  Widget _buildPrevButton() {
    return Visibility(
        visible: chapterPrevId != null,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: ElevatedButton.icon(
            onPressed: () =>
                onTapChapter?.call(novelId: novelId, chapterId: chapterPrevId),
            icon: const Icon(Icons.arrow_back),
            label: const Text('上一章')));
  }

  Widget _buildNextButton() {
    return Visibility(
        visible: chapterNextId != null,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
                onPressed: () => onTapChapter?.call(
                    novelId: novelId, chapterId: chapterNextId),
                icon: const Icon(Icons.arrow_back),
                label: const Text('下一章'))));
  }

  Widget _buildChapterButton() {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.list),
      style: const ButtonStyle(elevation: MaterialStatePropertyAll(12)),
    );
  }
}
