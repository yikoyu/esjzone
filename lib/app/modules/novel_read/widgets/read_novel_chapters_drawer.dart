import 'package:esjzone/app/data/novel_chapter_list_model.dart';
import 'package:esjzone/app/widgets/novel/novel_chapters_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadNovelChaptersDrawer extends StatefulWidget {
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
  State<ReadNovelChaptersDrawer> createState() =>
      _ReadNovelChaptersDrawerState();
}

class _ReadNovelChaptersDrawerState extends State<ReadNovelChaptersDrawer> {
  final GlobalKey activeChapterKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  int? get activeChapterIndex {
    if (widget.activeChapterId != null) {
      return simpleList(widget.list)
          .expand((element) => element)
          .toList()
          .indexWhere((element) => element == widget.activeChapterId);
    }

    return null;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

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
                    widget.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ).paddingAll(6),
                  Expanded(
                      child: NovelChaptersList(
                          scrollController: scrollController,
                          sliver: false,
                          showDetail: true,
                          activeChapterId: widget.activeChapterId,
                          activeChapterKey: activeChapterKey,
                          onTap: ({novelId, chapterId, index = 0}) {
                            Scaffold.of(context).closeDrawer();
                            widget.onTapChapter
                                ?.call(novelId: novelId, chapterId: chapterId);
                          },
                          chapterList: widget.list))
                ],
              )),
            )));
  }

  /// 滚动到选中章节
  void scrollToActiveChapter() {
    debugPrint('滚动到选中章节大概位置 > $activeChapterIndex');
    if (activeChapterIndex != null && activeChapterIndex! > 0) {
      //滚动到大概位置
      scrollController.jumpTo(44.0 * (activeChapterIndex!));

      // 修正位置，滚动到精确位置
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        debugPrint('滚动到选中章节精确位置 > ${activeChapterKey.currentContext}');
        if (activeChapterKey.currentContext != null) {
          Scrollable.ensureVisible(activeChapterKey.currentContext!);
        }
      });
    }
  }

  List<dynamic> simpleList(List<NovelChapterList>? chapters,
      {bool isChild = false}) {
    return (chapters ?? []).map((e) {
      if (e.type == 'text') {
        return isChild ? 'text' : ['text'];
      }
      if (e.type == 'chapter') {
        return isChild
            ? (e.chapterId ?? 'chapter')
            : [e.chapterId ?? 'chapter'];
      }
      if (e.type == 'details' && e.chapters != null && e.chapters!.isNotEmpty) {
        return ['details', ...simpleList(e.chapters, isChild: true)];
      }

      return '';
    }).toList();
  }
}
