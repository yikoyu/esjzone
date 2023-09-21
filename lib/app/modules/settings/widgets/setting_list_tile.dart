import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingListTile extends StatelessWidget {
  final String title;
  final TextAlign titleTextAlign;
  final TextStyle titleTextStyle;
  final bool showTrailing;
  final IconData trailingIcon;
  final Widget? trailingIconWidget;
  final String trailingText;
  final Widget? trailingTextWidget;
  final bool border;
  final bool selected;
  final void Function()? onTap;

  const SettingListTile(
      {super.key,
      required this.title,
      this.titleTextAlign = TextAlign.start,
      this.titleTextStyle = const TextStyle(),
      this.trailingText = '',
      this.trailingTextWidget,
      this.showTrailing = true,
      this.trailingIcon = Icons.chevron_right,
      this.trailingIconWidget,
      this.border = true,
      this.selected = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, textAlign: titleTextAlign, style: titleTextStyle),
      selected: selected,
      trailing: showTrailing
          ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                trailingTextWidget ?? Text(trailingText),
                trailingIconWidget ?? Icon(trailingIcon)
              ],
            )
          : null,
      tileColor: context.isDarkMode ? const Color(0xff131516) : Colors.white,
      shape: border
          ? Border(bottom: BorderSide(color: Theme.of(context).dividerColor))
          : null,
      onTap: () {
        onTap?.call();
      },
    );
  }
}
