import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/widgets/novel/novel_chapters_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadNovelChaptersDrawer extends StatelessWidget {
  final String title;
  final String? activeChapterId;
  final List<NovelChapterList> list;
  final Function({String? novelId, String? chapterId})? onTapChapter;

  const ReadNovelChaptersDrawer(
      {super.key,
      this.title = '',
      this.activeChapterId,
      this.onTapChapter,
      this.list = const []});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: ((BuildContext context) => Drawer(
              backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
              width: 306,
              child: SafeArea(
                  child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ).paddingAll(6),
                  Expanded(
                      child: NovelChaptersList(
                          sliver: false,
                          showDetail: true,
                          activeChapterId: activeChapterId,
                          onTap: ({novelId, chapterId}) {
                            Scaffold.of(context).closeEndDrawer();
                            onTapChapter?.call(
                                novelId: novelId, chapterId: chapterId);
                          },
                          chapterList: list))
                ],
              )),
            )));
  }
}
