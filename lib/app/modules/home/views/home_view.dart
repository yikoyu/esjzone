/*
 * @Date: 2023-08-15 14:46:32
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-08-18 21:44:37
 * @FilePath: \esjzone\lib\app\modules\home\views\home_view.dart
 */
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NovelsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
