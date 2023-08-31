/*
 * @Date: 2023-08-18 11:22:57
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-18 11:27:31
 * @FilePath: \esjzone\lib\app\widgets\icon_text.dart
 */
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String? text;
  final int? maxLines;
  final TextOverflow? overflow;

  const IconText(this.icon, this.text,
      {super.key, this.maxLines = 1, this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon),
      Text(
        text ?? '',
        maxLines: maxLines,
        overflow: overflow,
      )
    ]);
  }
}
