import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 搜索AppBar
class AppBarSearch extends StatefulWidget implements PreferredSizeWidget {
  const AppBarSearch({
    Key? key,
    this.borderRadius = 20,
    this.autofocus = false,
    this.enabled = true,
    this.focusNode,
    this.controller,
    this.toolbarHeight = kToolbarHeight,
    this.value,
    this.leading,
    this.backgroundColor,
    this.actions = const [],
    this.bottom,
    this.hintText,
    this.initialValue,
    this.readOnly = false,
    this.onTap,
    this.onClear,
    this.onCancel,
    this.onChanged,
    this.onSearch,
    this.onRightTap,
  }) : super(key: key);

  final double? borderRadius;
  final bool? autofocus;
  final bool enabled;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  // 输入框高度 默认40
  final double toolbarHeight;

  // 默认值
  final String? value;

  // 最前面的组件
  final Widget? leading;

  // 背景色
  final Color? backgroundColor;

  // 搜索框右侧组件
  final List<Widget> actions;

  // 搜索框底部
  final PreferredSizeWidget? bottom;

  // 输入框提示文字
  final String? hintText;

  // 搜索初始值
  final String? initialValue;

  // 是否只读
  final bool readOnly;

  // 输入框点击回调
  final VoidCallback? onTap;

  // 清除输入框内容回调
  final VoidCallback? onClear;

  // 清除输入框内容并取消输入
  final VoidCallback? onCancel;

  // 输入框内容改变
  final ValueChanged<String>? onChanged;

  // 点击键盘搜索
  final ValueChanged<String>? onSearch;

  // 点击右边widget
  final VoidCallback? onRightTap;

  @override
  Size get preferredSize {
    return Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));
  }

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  TextEditingController? _controller;
  FocusNode? _focusNode;

  bool get isFocus => _focusNode?.hasFocus ?? false; //是否获取焦点

  bool get isTextEmpty => _controller?.text.isEmpty ?? false; //输入框是否为空

  bool get isActionEmpty => widget.actions.isEmpty; // 右边布局是否为空

  bool isShowCancel = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: widget.toolbarHeight,
        leading: widget.leading != null
            ? Container(
                padding: const EdgeInsets.only(left: 12), child: widget.leading)
            : null,
        bottom: widget.bottom,
        actions: _actions(),
        titleSpacing: 12,
        title: Container(
            height: widget.toolbarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: widget.onTap,
                child: _buildTextField(),
              ),
            )));
  }

  @override
  void initState() {
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    if (widget.value != null) _controller?.text = widget.value ?? "";
    // 焦点获取失去监听
    _focusNode?.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    // 文本输入监听
    _controller?.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // 外部传入不进行注销
    if (widget.controller == null) _controller?.dispose();
    if (widget.focusNode == null) _focusNode?.dispose();
    super.dispose();
  }

  Widget _buildTextField() {
    return TextField(
      enabled: widget.enabled,
      // 是否只读
      readOnly: widget.readOnly,
      // 是否启用
      autofocus: widget.autofocus ?? false,
      // 是否自动获取焦点
      focusNode: _focusNode,
      // 焦点控制
      controller: _controller,
      // 与输入框交互控制器
      //装饰
      decoration: InputDecoration(
          // isDense: true,
          // border: InputBorder.none,
          // isCollapsed: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          border: const OutlineInputBorder(),
          hintText: widget.hintText ?? 'please_enter_keywords'.tr,
          prefixIcon: const Icon(Icons.search),
          prefixIconConstraints: BoxConstraints(
            minWidth: kMinInteractiveDimension,
            minHeight: widget.toolbarHeight,
          ),
          suffixIcon: _suffix(),
          suffixIconConstraints: BoxConstraints(
            minWidth: kMinInteractiveDimension,
            minHeight: widget.toolbarHeight,
          ),
          hintStyle: const TextStyle(fontSize: 14),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0))),
      style: const TextStyle(
          // fontSize: 14.sp,
          // color: MyColors.color_333333,
          ),
      // 键盘动作右下角图标
      textInputAction: TextInputAction.search,
      // 输入框内容改变回调
      onChanged: widget.onChanged,
      onSubmitted: widget.onSearch, //输入框完成触发
    );
  }

  // 清除输入框内容
  void _onClearInput() {
    if (!mounted) return;
    setState(() {
      _controller?.clear();
      _focusNode?.requestFocus(); //失去焦点
    });
    widget.onClear?.call();
  }

  // 点击搜索输入框编辑失去焦点
  void _onSearchInput() {
    if (!mounted) return;
    setState(() {
      _focusNode?.unfocus(); //失去焦点
    });
    // 执行onSearch
    widget.onSearch?.call(_controller?.text ?? '');
  }

  Widget _suffix() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isTextEmpty ? 0 : 1,
      child: InkWell(
        onTap: _onClearInput,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        child: const Icon(Icons.cancel, size: 20),
      ),
    );
  }

  List<Widget> _actions() {
    List<Widget> list = [];
    if (isFocus || !isTextEmpty) {
      list.add(InkWell(
        onTap: widget.onRightTap ?? _onSearchInput,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            'search'.tr,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ));
    } else if (!isActionEmpty) {
      list.addAll(widget.actions);
    }
    return list;
  }
}
