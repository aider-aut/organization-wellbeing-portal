import 'package:chatapp/model/login/login_response.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User extends LoginResponse {
  final String uid;
  final String name;
  final String imgURL;
  final String fcmToken;
  final String tenantId;
  final String emotion;
  final bool isFirstUser;
  final bool isEmailVerified;

  User(this.uid, this.name, this.imgURL, this.fcmToken, this.tenantId,
      {this.emotion = "Happy",
      this.isFirstUser = false,
      this.isEmailVerified = false});

  User.fromFirebaseUser(auth.User firebaseUser)
      : this(
          firebaseUser.uid,
          firebaseUser.displayName,
          firebaseUser.photoURL,
          "",
          firebaseUser.tenantId,
        );
  Map<String, dynamic> get map {
    return {
      "uid": uid,
      "name": name,
      'imgURL': imgURL,
      'fcmToken': fcmToken,
      'tenantId': tenantId,
      'emotion': emotion,
      'isFirstUser': isFirstUser,
      'isEmailVerified': isEmailVerified
    };
  }
}
