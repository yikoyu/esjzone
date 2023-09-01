/*
 * @Date: 2023-08-30 16:14:29
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-01 10:42:10
 * @FilePath: \esjzone\lib\app\modules\novel_detail\widgets\rating_detail_panel.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class RatingDetailPanel extends StatelessWidget {
  final double rating;
  final Widget Function(BuildContext, int)? itemBuilder;
  final int itemCount;
  final Color color;
  final List<int> rateList;
  final void Function()? onTap;

  const RatingDetailPanel(
      {super.key,
      required this.rating,
      this.itemCount = 5,
      this.itemBuilder,
      this.color = Colors.amber,
      this.rateList = const [0, 0, 0, 0, 0],
      this.onTap});

  int get rateTotal {
    return rateList.reduce((value, current) => value + current);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        child: InkWell(
            onTap: onTap,
            child: Column(
              children: [
                _buildTop(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildTotalRating(), _buildAllRating()],
                )
              ],
            ).paddingAll(12)));
  }

  Widget _buildTop() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '参与评论，表达对作品的喜爱',
          style: TextStyle(fontSize: 12),
        ),
        Icon(
          Icons.chevron_right,
          size: 20,
        )
      ],
    );
  }

  Widget _buildTotalRating() {
    return Row(
      children: [
        Text('$rating',
                style:
                    const TextStyle(fontSize: 34, fontWeight: FontWeight.w400))
            .paddingOnly(right: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingBarIndicator(
                rating: rating,
                itemCount: itemCount,
                color: color,
                itemSize: 16),
            Text(
              '$rateTotal个评分',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAllRating() {
    Iterable<Row> rateWidgetList = rateList.asMap().entries.map((entry) {
      int i = entry.key + 1;
      int v = entry.value;

      return Row(
        children: [
          _buildRatingBarIndicator(
                  rating: i.toDouble(), itemCount: i, itemSize: 8)
              .paddingOnly(right: 6),
          LinearProgressIndicator(
                  value: rateTotal == 0 ? 0 : (v / rateTotal),
                  valueColor: const AlwaysStoppedAnimation(Colors.amber))
              .width(80)
        ],
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: rateWidgetList.toList().reversed.toList(),
    );
  }

  Widget _buildRatingBarIndicator(
      {required double rating,
      required int itemCount,
      required double itemSize,
      Color? color}) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) {
        if (itemBuilder != null) {
          return itemBuilder!(context, index);
        }

        return Icon(
          Icons.star,
          color: color,
        );
      },
      itemCount: itemCount,
      itemSize: itemSize,
    );
  }
}
