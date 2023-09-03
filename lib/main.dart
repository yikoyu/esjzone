/*
 * @Date: 2023-08-09 11:58:17
 * @LastEditors: yikoyu 2282373181@qq.com
 * @LastEditTime: 2023-09-03 15:58:39
 * @FilePath: \esjzone\lib\main.dart
 */

import 'package:flutter/material.dart';
import 'package:esjzone/app/utils/app_theme_data.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/utils/request/request.dart';
import 'env.dart';
import 'generated/locales.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Map<String, String> headers = {
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'en-US,en;q=0.9,zh-CN;q=0.8,zh-Hans;q=0.7,zh;q=0.6',
    'user-agent':
        'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Mobile Safari/537.36 Edg/115.0.1901.200'
  };

  // 初始化存储
  await GetStorage.init();

  await HttpUtils.init(Env.envConfig.apiHost, headers: headers);

  runApp(
    GetMaterialApp(
        title: Env.envConfig.appTitle,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        builder: EasyLoading.init(),
        // theme
        theme: AppThemeData.light(),
        darkTheme: AppThemeData.dark(),
        // translations
        translationsKeys: AppTranslation.translations,
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          Locale('zh', 'CN')
        ],
        localizationsDelegates: const [
          // 本地化的代理类
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ]),
  );
}
