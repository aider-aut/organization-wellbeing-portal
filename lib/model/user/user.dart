import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:chatapp/model/login/login_response.dart';

class User extends LoginResponse {
  final String uid;
  final String name;
  final String imgURL;
  final String fcmToken;
  final String tenantId;
  final String emotion;

  User(this.uid, this.name, this.imgURL, this.fcmToken, this.tenantId,
      {this.emotion = "Happy"});

  User.fromFirebaseUser(auth.User firebaseUser)
      : this(
          firebaseUser.uid,
          firebaseUser.displayName,
          firebaseUser.photoURL,
          "",
          firebaseUser.tenantId,
        );
  Map<String, dynamic> get map {
    return {"uid": uid, "name": name, 'imgURL': imgURL, 'fcmToken': fcmToken, 'tenantId': tenantId, 'emotion': emotion};
  }
}
