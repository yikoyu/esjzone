/*
 * @Date: 2023-08-18 17:15:12
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-23 12:34:06
 * @FilePath: \esjzone\lib\app\modules\novels\widgets\filter_bar.dart
 */
import 'package:flutter/material.dart';
import 'package:esjzone/app/utils/enum.dart';
import 'package:get/get.dart';

class FilterBar extends StatefulWidget implements PreferredSizeWidget {
  final double? itemHeight;
  final void Function(SortLabel? sortLabel, CategoryLabel? categoryLabel)?
      onChanged;

  const FilterBar(
      {super.key, this.itemHeight = kMinInteractiveDimension, this.onChanged});

  @override
  Size get preferredSize =>
      Size.fromHeight(itemHeight ?? kMinInteractiveDimension);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  SortLabel? sortValue = SortLabel.updated;
  CategoryLabel? categoryValue = CategoryLabel.all;

  /// 排序选项列表
  final List<DropdownMenuItem<SortLabel>> _sortLabelEntries =
      SortLabel.values.map((sortLabel) {
    return DropdownMenuItem<SortLabel>(
      value: sortLabel,
      child: Text(sortLabel.label.tr),
    );
  }).toList();

  /// 列表选项列表
  final List<DropdownMenuItem<CategoryLabel>> _categoryLabelEntries =
      CategoryLabel.values.map((categoryLabel) {
    return DropdownMenuItem<CategoryLabel>(
      value: categoryLabel,
      child: Text(categoryLabel.label.tr),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Row(
        children: [
          Expanded(child: _buildSortDropdown()),
          Expanded(child: _buildCategoryDropdown())
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      value: sortValue,
      items: _sortLabelEntries,
      isExpanded: true,
      menuMaxHeight: kMinInteractiveDimension * 6,
      itemHeight: widget.itemHeight,
      alignment: AlignmentDirectional.center,
      onChanged: _onSortChanged,
    ));
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      value: categoryValue,
      items: _categoryLabelEntries,
      itemHeight: widget.itemHeight,
      alignment: AlignmentDirectional.center,
      onChanged: _onCategoryChange,
    ));
  }

  void _onSortChanged(SortLabel? value) {
    setState(() => sortValue = value);
    widget.onChanged?.call(value, categoryValue);
  }

  void _onCategoryChange(CategoryLabel? value) {
    setState(() => categoryValue = value);
    widget.onChanged?.call(sortValue, value);
  }
}
