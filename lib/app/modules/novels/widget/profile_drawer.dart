// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esjzone/app/modules/login/views/login_view.dart';
import 'package:esjzone/app/modules/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:esjzone/app/controllers/login_user_controllers.dart';
import 'package:esjzone/app/utils/app_theme_data.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  LoginUserController get login => Get.find<LoginUserController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 256,
        child: SafeArea(
          child: ListView(children: [
            Obx(() => _buildDrawerHeader()),
            ..._buildDrawerList()
          ]),
        ));
  }

  List<Widget> _buildDrawerList() {
    return [
      _DrawerItemData(leading: Icons.settings, title: '设置', onTap: toSettings),
      _DrawerItemData(
          leading: Icons.lightbulb_outline,
          title: '深色模式',
          trailing: _buildThemeSwitch(context)),
      const Divider(),
      _DrawerItemData(
          leading: login.isLogin.value ? Icons.logout : Icons.login,
          title: login.isLogin.value ? '切换账号' : '登录账号',
          trailing: null,
          onTap: tologin),
    ];
  }

  Widget _buildDrawerHeader() {
    return SizedBox(
      height: 188, // 头部高度
      child: DrawerHeader(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          CircleAvatar(
              radius: 40,
              backgroundImage: CachedNetworkImageProvider(login.avatar.value)),
          const SizedBox(height: 12),
          Text(
            login.isLogin.value ? login.username.value : '请登录',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18),
          ),
          Text('${login.level.value} ${login.exp.value}'),
        ]),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Switch(
      value: context.isDarkMode,
      onChanged: (value) {
        setState(() {
          AppThemeData.changeTheme(isDarkMode: !value);
        });
      },
    );
  }

  void toSettings() {
    Get.back();
    Get.to(() => const SettingsView(), transition: Transition.rightToLeft);
  }

  void tologin() {
    Get.back();
    Get.to(() => const LoginView(), transition: Transition.rightToLeft);
  }
}

class _DrawerItemData extends StatelessWidget {
  final String title;
  final IconData? leading;
  final Widget? trailing;
  final void Function()? onTap;

  const _DrawerItemData(
      {Key? key,
      required this.title,
      this.leading,
      this.trailing = const Icon(Icons.chevron_right),
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(title),
      trailing: trailing,
      onTap: () {
        onTap?.call();
      },
    );
  }
}
