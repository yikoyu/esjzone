/*
 * @Date: 2023-08-28 13:44:27
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-28 15:40:16
 * @FilePath: \esjzone\lib\app\modules\novel_detail\widgets\details_chapters_panel.dart
 */
import 'package:flutter/material.dart';

class DetailsChaptersPanel extends StatefulWidget {
  final Function(BuildContext context) titleBuilder;
  final Function(BuildContext context) contentBuilder;

  const DetailsChaptersPanel(
      {super.key, required this.titleBuilder, required this.contentBuilder});

  @override
  State<DetailsChaptersPanel> createState() => _DetailsChaptersPanelState();
}

class _DetailsChaptersPanelState extends State<DetailsChaptersPanel> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  bool get _isShow => _crossFadeState == CrossFadeState.showSecond;

  @override
  void initState() {
    super.initState();
    // _animationController
  }

  @override
  Widget build(BuildContext context) {
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
