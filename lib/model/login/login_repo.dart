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
  final FirebaseFirestore _firestore;
  LoginRepo._internal(this._firestore);

  factory LoginRepo.getInstance() {
    if (_instance == null) {
      _instance = LoginRepo._internal(FirebaseRepo.getInstance().firestore);
    }
    return _instance;
  }

  Future<LoginResponse> _signIn(firebase.AuthCredential credentials) async {
    final authResult = await _auth.signInWithCredential(credentials);
    if (!authResult.additionalUserInfo.isNewUser) {
      UserRepo.getInstance().setFirstUser(false);
    }
    if (authResult != null && authResult.user != null) {
      final user = authResult.user;
      UserRepo.getInstance().setCurrentUser(User.fromFirebaseUser(user));
      User serializedUser = UserRepo.getInstance().getCurrentUser();
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
      if (authResult.additionalUserInfo.isNewUser) {
        UserRepo.getInstance().setFirstUser(false);
      }
      final user = authResult.user;
      UserRepo.getInstance().setCurrentUser(User.fromFirebaseUser(user));
      User serializedUser = UserRepo.getInstance().getCurrentUser();
      if (!user.emailVerified) {
        UserRepo.getInstance().setEmailVerified(false);
        await user.sendEmailVerification();
        return LoginFailedResponse(ErrMessages.EMAIL_NOT_VERIFIED);
      } else {
        UserRepo.getInstance().setEmailVerified(true);
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
