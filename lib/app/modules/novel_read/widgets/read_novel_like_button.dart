import 'package:esjzone/app/data/novel_read_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class ReadNovelLikeButton extends StatelessWidget {
  final Rx<NovelRead> readDetail;
  final Future<void> Function(bool isLiked) onTap;

  const ReadNovelLikeButton(
      {super.key, required this.readDetail, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Container(
        padding: const EdgeInsets.all(6),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Obx(() => LikeButton(
                mainAxisAlignment: MainAxisAlignment.start,
                isLiked: readDetail.value.isLike,
                likeCount: int.tryParse(readDetail.value.likes ?? '0'),
                likeBuilder: (isLiked) => Icon(
                    isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                    color: isLiked ? primaryColor : null),
                countBuilder: (likeCount, isLiked, text) => Text(text,
                    style: TextStyle(color: isLiked ? primaryColor : null)),
                onTap: onHandleLike,
              ))
        ]));
  }

  Future<bool> onHandleLike(bool isLiked) async {
    try {
      await onTap.call(isLiked);
      return readDetail.value.isLike ?? false;
    } catch (e) {
      return readDetail.value.isLike ?? false;
    }
  }
}
