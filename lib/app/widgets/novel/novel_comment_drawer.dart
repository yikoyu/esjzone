import 'package:esjzone/app/data/comment_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'novel_comment.dart';

class NovelCommentDrawer extends StatelessWidget {
  final List<CommentList> comment;

  const NovelCommentDrawer({super.key, this.comment = const []});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
        width: 306,
        child: SafeArea(
            child: ListView.builder(
          itemCount: comment.length,
          itemBuilder: ((context, index) {
            var item = comment[index];

            return NovelComment(
              poster: item.poster,
              floor: item.floor,
              replyFrom: item.replyFrom,
              replyTo: item.replyToHtml,
              createTime: item.createTime,
            );
          }),
        )));
  }
}
