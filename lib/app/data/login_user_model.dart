class LoginUser {
  String? avatar;
  String? username;
  String? exp;
  String? level;
  bool? isLogin;

  LoginUser({this.avatar, this.username, this.exp, this.level, this.isLogin});

  LoginUser.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'];
    username = json['username'];
    exp = json['exp'];
    level = json['level'];
    isLogin = json['isLogin'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['username'] = username;
    data['exp'] = exp;
    data['level'] = level;
    data['isLogin'] = isLogin;
    return data;
  }
}
