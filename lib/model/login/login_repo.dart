import 'dart:async';

import 'package:chatapp/model/login/login_response.dart';
import 'package:chatapp/model/storage/firebase_repo.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRepo {
  static LoginRepo _instance;
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  String _userName;
  final FirebaseFirestore _firestore;
  bool _isFirstUser = false;
  bool _isEmailVerified = false;
  LoginRepo._internal(this._firestore);

  factory LoginRepo.getInstance() {
    if (_instance == null) {
      _instance = LoginRepo._internal(FirebaseRepo.getInstance().firestore);
    }
    return _instance;
  }

  void setIsNewUser(bool isNewUser) {
    _isFirstUser = isNewUser;
  }

  void setUserName(String name) {
    _userName = name;
  }

  bool isNewUser() {
    _isFirstUser = _auth.currentUser.metadata.creationTime ==
        _auth.currentUser.metadata.lastSignInTime;

    return _isFirstUser;
  }

  bool isEmailVerified() {
    if (_auth.currentUser != null) {
      _isEmailVerified = _auth.currentUser.emailVerified;
    }
    _auth.userChanges().forEach((user) {
      if (user != null) {
        if (user.uid == _auth.currentUser.uid) {
          _isEmailVerified = user.emailVerified;
        }
      }
    });
    print("auth: ${_auth.currentUser.emailVerified}");
    return _isEmailVerified;
  }

  Future<LoginResponse> _signIn(firebase.AuthCredential credentials) async {
    final authResult = await _auth.signInWithCredential(credentials);
    setIsNewUser(false);
    if (authResult.user.metadata.creationTime ==
            authResult.user.metadata.lastSignInTime ||
        authResult.additionalUserInfo.isNewUser) {
      setIsNewUser(true);
    }
    if (authResult != null && authResult.user != null) {
      final user = authResult.user;
      final token = await UserRepo.getInstance().getFCMToken();
      String emotion;
      String id;
      UserRepo.getInstance().getUserId().then((result) {
        id = result;
      });
      UserRepo.getInstance().getEmotion().then((result) {
        emotion = result;
      });
      User serializedUser = User(
          user.uid != null ? user.uid : id,
          (user.displayName != null && user.displayName.isNotEmpty)
              ? user.displayName
              : _userName,
          user.photoURL,
          token,
          user.tenantId,
          emotion: emotion,
          isFirstUser: _isFirstUser);
      await _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(user.uid)
          .set(serializedUser.map, SetOptions(merge: true));
      return serializedUser;
    } else {
      return LoginFailedResponse(ErrMessages.NO_USER_FOUND);
    }
  }

  Future<bool> _signOut() async {
    return _auth.signOut().catchError((error) {
      print("LoginRepo::logOut() encountered an error:\n${error.error}");
      return false;
    }).then((value) {
      return true;
    });
  }

  Future<LoginResponse> signInWithEmail(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (authResult != null && authResult.user != null) {
      setIsNewUser(false);
      if ((authResult.user.metadata.creationTime ==
              authResult.user.metadata.lastSignInTime) ||
          authResult.additionalUserInfo.isNewUser) {
        setIsNewUser(true);
      }
      final user = authResult.user;
      final token = await UserRepo.getInstance().getFCMToken();
      String emotion;
      String id;
      UserRepo.getInstance().getUserId().then((result) {
        id = result;
      });
      UserRepo.getInstance().getEmotion().then((result) {
        emotion = result;
      });
      User serializedUser = User(
          user.uid != null ? user.uid : id,
          (user.displayName != null && user.displayName.isNotEmpty)
              ? user.displayName
              : _userName,
          user.photoURL,
          token,
          user.tenantId,
          emotion: emotion,
          isFirstUser: _isFirstUser);
      if (!user.emailVerified) {
        _isEmailVerified = false;
        await user.sendEmailVerification();
        return LoginFailedResponse(ErrMessages.EMAIL_NOT_VERIFIED);
      } else {
        _isEmailVerified = true;
      }
      await _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(user.uid)
          .set(serializedUser.map, SetOptions(merge: true));
      return serializedUser;
    } else {
      return LoginFailedResponse(ErrMessages.NO_USER_FOUND);
    }
  }

  Future<LoginResponse> signInWithGoogle(GoogleSignInAccount account) async {
    final authentication = await account.authentication;
    final credentials = firebase.GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    return _signIn(credentials);
  }

  Future<LoginResponse> signInWithFacebook(LoginResult result) async {
    final credentials =
        firebase.FacebookAuthProvider.credential(result.accessToken.token);
    return _signIn(credentials);
  }

  Future<bool> signOut() async {
    return _signOut();
  }
}
