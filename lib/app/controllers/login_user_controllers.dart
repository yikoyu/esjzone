import 'package:esjzone/app/data/login_user_model.dart';
import 'package:esjzone/app/utils/esjzone/esjzone.dart';
import 'package:get/get.dart';

class LoginUserController extends GetxController {
  var isLogin = false.obs;
  var avatar = ''.obs;
  var exp = ''.obs;
  var level = ''.obs;
  var username = ''.obs;

  Future<void> getLoginUser(EsjzoneParseData esjzone) async {
    LoginUser loginUser = await esjzone.getLoginUser();
    avatar.value = loginUser.avatar ?? '';
    exp.value = loginUser.exp ?? '';
    isLogin.value = loginUser.isLogin ?? false;
    level.value = loginUser.level ?? '';
    username.value = loginUser.username ?? '';
  }
}
