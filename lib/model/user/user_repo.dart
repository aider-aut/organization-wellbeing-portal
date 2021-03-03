import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/util/constants.dart';

class UserRepo {
  static UserRepo _instance;

  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    String userName = prefs.getString(StorageKeys.USER_NAME_KEY);
    String userImgUrl = prefs.getString(StorageKeys.USER_IMG_URL_KEY);
    String fcmToken = prefs.getString(StorageKeys.FCM_TOKEN);
    if (userId != null && userName != null && userImgUrl != null) {
      return User(userId, userName, userImgUrl, fcmToken);
    }
    return null;
  }

  void setCurrentUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = user.fcmToken.isEmpty
        ? prefs.getString(StorageKeys.FCM_TOKEN)
        : user.fcmToken;
    await prefs
        .setString(StorageKeys.USER_ID_KEY, user.uid)
        .then((val) => prefs.setString(StorageKeys.USER_NAME_KEY, user.name))
        .then(
            (val) => prefs.setString(StorageKeys.USER_IMG_URL_KEY, user.imgURL))
        .then((val) => prefs.setString(StorageKeys.FCM_TOKEN, user.fcmToken));
  }

  void clearCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.FCM_TOKEN);
  }

  void setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.FCM_TOKEN, token);
  }
}
