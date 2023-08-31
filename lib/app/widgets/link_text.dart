/*
 * @Date: 2023-08-18 10:30:40
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-18 10:55:46
 * @FilePath: \esjzone\lib\app\widgets\link_text.dart
 */
import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String? data;
  final void Function()? onTap;
  final int? maxLines;
  final TextOverflow? overflow;

  const LinkText(this.data,
      {super.key,
      this.onTap,
      this.maxLines = 1,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    if (data != null && data!.isNotEmpty) {
      return InkWell(
          onTap: onTap,
          child: Text(
            data!,
            maxLines: maxLines,
            overflow: overflow,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ));
    }

    return const SizedBox();
  }
}
