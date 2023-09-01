/*
 * @Date: 2023-08-28 13:44:27
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-01 20:05:41
 * @FilePath: \esjzone\lib\app\widgets\novel\novel_details_chapters_panel.dart
 */
import 'package:flutter/material.dart';

class NovelDetailsChaptersPanel extends StatefulWidget {
  final bool show;
  final Function(BuildContext context) titleBuilder;
  final Function(BuildContext context) contentBuilder;

  const NovelDetailsChaptersPanel(
      {super.key,
      this.show = false,
      required this.titleBuilder,
      required this.contentBuilder});

  @override
  State<NovelDetailsChaptersPanel> createState() =>
      _NovelDetailsChaptersPanelState();
}

class _NovelDetailsChaptersPanelState extends State<NovelDetailsChaptersPanel>
    with AutomaticKeepAliveClientMixin {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  bool get _isShow => _crossFadeState == CrossFadeState.showSecond;

  @override
  void initState() {
    _crossFadeState =
        widget.show ? CrossFadeState.showSecond : CrossFadeState.showFirst;

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(children: [_buildTitle(context), _buildContent(context)]);
  }

  Widget _buildContent(BuildContext context) {
    return AnimatedCrossFade(
      firstCurve: Curves.fastOutSlowIn,
      secondChild: widget.contentBuilder(context),
      firstChild: Container(height: 0.0),
      secondCurve: Curves.fastOutSlowIn,
      crossFadeState: _crossFadeState,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return InkWell(
      onTap: _togglePanel,
      child: Row(
        children: [
          _isShow
              ? const Icon(Icons.arrow_drop_down)
              : const Icon(Icons.arrow_right),
          Expanded(child: widget.titleBuilder(context))
        ],
      ),
    );
  }

  void _togglePanel() {
    setState(() {
      _crossFadeState =
          _isShow ? CrossFadeState.showFirst : CrossFadeState.showSecond;
    });
  }
}
