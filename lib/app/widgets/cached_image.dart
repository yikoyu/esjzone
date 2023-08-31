/*
 * @Date: 2023-08-18 11:05:20
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-18 11:15:29
 * @FilePath: \esjzone\lib\app\widgets\cached_image.dart
 */
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CachedImage extends StatelessWidget {
  final String? image;
  final String placeholder;

  const CachedImage(this.image,
      {super.key, this.placeholder = 'assets/images/novel-default.jpg'});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (image != null && image!.isNotEmpty) {
      try {
        return CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: image!,
            placeholder: (context, url) {
              return Container(
                  color: colorScheme.background,
                  child: SpinKitCubeGrid(
                    color: colorScheme.primary,
                    size: 40,
                  ));
            },
            errorWidget: (context, url, error) => _placeholderImage());
      } catch (e) {
        return _placeholderImage();
      }
    }

    return _placeholderImage();
  }

  Image _placeholderImage() {
    return Image.asset(placeholder, fit: BoxFit.cover);
  }
}
