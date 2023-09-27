import 'package:esjzone/app/data/novel_read_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReadNovelTop extends StatelessWidget {
  final Rx<NovelRead> readDetail;

  const ReadNovelTop({super.key, required this.readDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note),
              const SizedBox(width: 6),
              Obx(() => _buildAuthorName(context, readDetail.value.authorName))
            ],
          ),
          const SizedBox(height: 6),
          Obx(() => _buildRow(
              icon: Icons.update, title: readDetail.value.updateTime)),
          const SizedBox(height: 6),
          Obx(() => _buildRow(
              icon: Icons.abc_outlined, title: readDetail.value.words)),
          const SizedBox(height: 6),
          Obx(() => Text(
                readDetail.value.chapterName ?? '',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ))
        ],
      ),
    );
  }

  Widget _buildAuthorName(BuildContext context, String? authorName) {
    Color colorPrimary = Theme.of(context).colorScheme.primary;
    Color colorText = Get.isDarkMode ? Colors.white : Colors.black;

    return RichText(
        text: TextSpan(children: [
      TextSpan(text: 'by ', style: TextStyle(color: colorText)),
      TextSpan(text: authorName, style: TextStyle(color: colorPrimary)),
    ]));
  }

  Widget _buildRow({required IconData icon, String? title}) {
    return Row(
      children: [Icon(icon), const SizedBox(width: 6), Text(title ?? '')],
    );
  }
}
