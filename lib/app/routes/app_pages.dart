import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/index/bindings/index_binding.dart';
import '../modules/index/views/index_view.dart';
import '../modules/novel_detail/bindings/novel_detail_binding.dart';
import '../modules/novel_detail/views/novel_detail_view.dart';
import '../modules/novel_read/bindings/novel_read_binding.dart';
import '../modules/novel_read/views/novel_read_view.dart';
import '../modules/novels/bindings/novels_binding.dart';
import '../modules/novels/views/novels_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/search_novels/bindings/search_novels_binding.dart';
import '../modules/search_novels/views/search_novels_view.dart';
import '../modules/searching/bindings/searching_binding.dart';
import '../modules/searching/views/searching_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INDEX;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.INDEX,
      page: () => const IndexView(),
      binding: IndexBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOVELS,
      page: () => const NovelsView(),
      binding: NovelsBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH_NOVELS,
      page: () => const SearchNovelsView(),
      binding: SearchNovelsBinding(),
    ),
    GetPage(
      name: _Paths.SEARCHING,
      page: () => const SearchingView(),
      binding: SearchingBinding(),
    ),
    GetPage(
      name: _Paths.NOVEL_DETAIL,
      page: () => const NovelDetailView(),
      binding: NovelDetailBinding(),
    ),
    GetPage(
      name: _Paths.NOVEL_READ,
      page: () => const NovelReadView(),
      binding: NovelReadBinding(),
    ),
  ];
}
