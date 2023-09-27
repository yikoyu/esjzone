import 'package:esjzone/app/utils/app_storage.dart';
import 'package:esjzone/app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'setting_list_tile.dart';

class SettingNovelCategory extends StatefulWidget {
  final void Function(CategoryLabel categoryLabel)? onTap;

  const SettingNovelCategory({super.key, this.onTap});

  @override
  State<SettingNovelCategory> createState() => _SettingNovelCategoryState();
}

class _SettingNovelCategoryState extends State<SettingNovelCategory> {
  ReadWriteValue<String> likeCategory = ReadWriteValue<String>(
      AppStorageKeys.settingLikeNovelCategory.key, CategoryLabel.all.value);

  List<SettingListTile> get _categoryLabelEntries =>
      CategoryLabel.values.map((categoryLabel) {
        return SettingListTile(
          title: categoryLabel.label.tr,
          selected: categoryLabel.value == likeCategory.val,
          trailingIconWidget: categoryLabel.value == likeCategory.val
              ? const Icon(Icons.check)
              : const SizedBox(),
          onTap: () {
            setState(() {
              likeCategory.val = categoryLabel.value;
            });
            widget.onTap?.call(categoryLabel);
          },
        );
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _categoryLabelEntries,
    );
  }
}
