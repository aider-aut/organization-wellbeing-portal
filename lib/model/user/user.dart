import 'package:chatapp/model/login/login_response.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User extends LoginResponse {
  final String uid;
  final String name;
  final String email;
  final String imgURL;
  final String fcmToken;
  final String tenantId;
  final String emotion;
  final bool isFirstUser;
  final bool isEmailVerified;
  final String birthday;

  User(
    this.uid,
    this.name,
    this.email,
    this.imgURL,
    this.fcmToken,
    this.tenantId, {
    this.emotion = "Happy",
    this.isFirstUser = true,
    this.isEmailVerified = false,
    this.birthday = "",
  });

  User.fromFirebaseUser(auth.User firebaseUser)
      : this(
          firebaseUser.uid,
          firebaseUser.displayName,
          firebaseUser.email,
          firebaseUser.photoURL,
          "",
          firebaseUser.tenantId,
        );
  Map<String, dynamic> get map {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      'imgURL': imgURL,
      'fcmToken': fcmToken,
      'tenantId': tenantId,
      'emotion': emotion,
      'isFirstUser': isFirstUser,
      'isEmailVerified': isEmailVerified,
      'birthday': birthday,
    };
  }
}
