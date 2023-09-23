import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: controller.formKey,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(children: [
                // const SizedBox(height: kToolbarHeight), // 距离顶部一个工具栏的高度
                Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Image.asset('assets/images/logo.png', width: 42),
                    _buildTitle(), // Login
                  ]),
                  _buildTitleLine(), // 标题下面的下滑线
                ]),
                const SizedBox(height: 50),
                _buildEmailTextField(),
                const SizedBox(height: 8),
                _buildPwdTextField(),
                const SizedBox(height: 30),
                _buildLoginBtn()
              ]))),
    );
  }

  /// Login
  Widget _buildTitle() {
    return const Padding(
        // 设置边距
        padding: EdgeInsets.all(8),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 42),
        ));
  }

  /// 标题下面的下滑线
  Widget _buildTitleLine() {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Get.isDarkMode ? const Color(0xffeceded) : Colors.black,
            width: 90,
            height: 2,
          ),
        ));
  }

  /// 邮箱输入框
  Widget _buildEmailTextField() {
    return TextFormField(
        initialValue: controller.email.value,
        onChanged: (value) => controller.email.value = value,
        decoration: const InputDecoration(
            labelText: '邮箱',
            hintText: '请输入邮箱',
            helperText: '',
            prefixIcon: Icon(Icons.email_outlined),
            isDense: true),
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return '邮箱不能为空';
          }
          return null;
        }));
  }

  /// 密码输入框
  Widget _buildPwdTextField() {
    return TextFormField(
        obscureText: true,
        initialValue: controller.pwd.value,
        onChanged: (value) => controller.pwd.value = value,
        decoration: const InputDecoration(
            labelText: '密码',
            hintText: '请输入密码',
            helperText: '',
            prefixIcon: Icon(Icons.lock_outline),
            isDense: true),
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return '邮箱不能为空';
          }
          return null;
        }));
  }

  /// 登录按钮
  Widget _buildLoginBtn() {
    return SizedBox(
      height: 45,
      width: 270,
      child: ElevatedButton(
          onPressed: controller.getLoginAuthToken,
          child: Obx(() => controller.loggingIn.value
              ? const Text('登录中...')
              : const Text('登录'))),
    );
  }
}
