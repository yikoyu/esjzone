/*
 * @Date: 2023-08-18 21:34:50
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-18 22:32:21
 * @FilePath: \esjzone\lib\app\modules\novels\widgets\novel_list_card.dart
 */
import 'package:flutter/material.dart';
import 'package:esjzone/app/data/novel_list_model.dart';
import 'package:esjzone/app/widgets/cached_image.dart';
import 'package:esjzone/app/widgets/icon_text.dart';
import 'package:esjzone/app/widgets/link_text.dart';
import 'package:esjzone/app/widgets/option_grid_view.dart';

import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class NovelListCard extends StatelessWidget {
  final NovelList item;

  const NovelListCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 0.6875, child: _buildImage(item)).width(134),
          Expanded(child: _buildCardDetail(item))
        ],
      ),
    );
  }

  Widget _buildImage(NovelList item) {
    if (item.xRated != null && item.xRated == true) {
      return Stack(alignment: AlignmentDirectional.topEnd, children: [
        Positioned(
            left: 0, top: 0, right: 0, bottom: 0, child: CachedImage(item.img)),
        Container(
          color: Colors.red,
          width: 24,
          height: 24,
          child: const Center(
              child: Text('18+',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500))),
        )
      ]);
    }

    return CachedImage(item.img);
  }

  Widget _buildCardDetail(NovelList item) {
    final List<Widget> iconTextList = [
      IconText(Icons.star_outline, item.stars),
      IconText(Icons.abc_outlined, item.words),
      IconText(Icons.remove_red_eye_outlined, item.views),
      IconText(Icons.favorite_outline, item.favorite),
      IconText(Icons.article_outlined, item.feathers),
      IconText(Icons.chat_bubble_outline, item.messages)
    ];

    final Widget title = Text(
      '${item.title}\n',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ).fontSize(16).fontWeight(FontWeight.w500).padding(bottom: 4);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      title,
      LinkText(item.author, onTap: () => debugPrint('跳转作者页'))
          .padding(bottom: 4),
      LinkText(item.lastEp, onTap: () => debugPrint('跳转章节页'))
          .padding(bottom: 4),
      OptionGridView(
          itemCount: iconTextList.length,
          rowCount: 2,
          itemBuilder: (context, index) => iconTextList[index])
    ]).paddingAll(12);
  }
}
