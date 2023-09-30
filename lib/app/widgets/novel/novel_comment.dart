import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import 'package:esjzone/app/widgets/link_text.dart';
import 'package:esjzone/env.dart';

class NovelComment extends StatelessWidget {
  final String? poster;
  final String? floor;
  final String? replyFrom;
  final String? replyTo;
  final String? createTime;

  const NovelComment(
      {super.key,
      this.poster,
      this.floor,
      this.replyFrom,
      this.replyTo,
      this.createTime});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildPoster(),
        const SizedBox(height: 6),
        _buildReplyFrom(),
        SizedBox(height: replyFrom != null ? 6 : null),
        HtmlWidget(
          replyTo ?? '',
          baseUrl: Uri.parse(Env.envConfig.apiHost),
        ), // 暂不支持 emoji
        const SizedBox(height: 4),
        Row(
          children: [
            const Spacer(),
            Text(createTime ?? '', style: const TextStyle(fontSize: 12)),
          ],
        )
      ]),
    ));
  }

  Widget _buildPoster() {
    return Row(
      children: [
        LinkText(poster),
        const Spacer(),
        Text(floor ?? '', style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildReplyFrom() {
    if (replyFrom != null) {
      return Container(
        // color: Colors.grey.shade300,
        color: Get.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Text(
          replyFrom ?? '',
          style: TextStyle(
              color:
                  Get.isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600),
        ),
      );
    }

    return const SizedBox();
  }
}
