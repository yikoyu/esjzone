import 'package:flutter/material.dart';

class HomeChipBar extends StatefulWidget implements PreferredSizeWidget {
  final double? itemHeight;
  final void Function(bool isUpdate)? onChange;

  const HomeChipBar(
      {super.key, this.itemHeight = kMinInteractiveDimension, this.onChange});

  @override
  Size get preferredSize =>
      Size.fromHeight(itemHeight ?? kMinInteractiveDimension);

  @override
  State<HomeChipBar> createState() => _HomeChipBarState();
}

class _HomeChipBarState extends State<HomeChipBar> {
  bool _isUpdate = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Row(
          children: [
            ChoiceChip(
              avatar: !_isUpdate ? const Icon(Icons.update) : null,
              label: const Text('最新更新'),
              padding: const EdgeInsets.all(4),
              elevation: 3,
              selected: _isUpdate,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onSelected: (value) => toggleSelected(),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              avatar: _isUpdate ? const Icon(Icons.favorite) : null,
              label: const Text('最新收藏'),
              padding: const EdgeInsets.all(4),
              elevation: 3,
              selected: !_isUpdate,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onSelected: (value) => toggleSelected(),
            ),
          ],
        ));
  }

  void toggleSelected() {
    setState(() {
      _isUpdate = !_isUpdate;
    });

    widget.onChange?.call(_isUpdate);
  }
}
