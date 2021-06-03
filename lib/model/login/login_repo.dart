import 'dart:async';

import 'package:chatapp/model/login/login_response.dart';
import 'package:chatapp/model/storage/firebase_repo.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:chatapp/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/cupertino.dart';
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

  Future<LoginResponse> _signIn(
      firebase.AuthCredential credentials, BuildContext context) async {
    final authResult = await _auth.signInWithCredential(credentials);
    if (authResult != null && authResult.user != null) {
      final user = authResult.user;
      UserRepo().clearCurrentUser();
      bool isFirstUser = authResult.additionalUserInfo.isNewUser;
      if (isFirstUser) {
        UserRepo().setUpDatabase(user.uid);
        await UserRepo().setCurrentUser(User.fromFirebaseUser(user));
        UserRepo().setEmail(user.email);
        UserRepo().setUserName(user.displayName);
        UserRepo().setFirstUser(true);
        UserRepo().setEmailVerified(true);
        UserRepo().setFirstUser(isFirstUser);
        NavigationHelper.navigateToWelcome(context, addToBackStack: false);
      } else {
        await UserRepo().setCurrentUser(User.fromFirebaseUser(user));
        UserRepo().setEmailVerified(true);
        UserRepo().setFirstUser(isFirstUser);
        NavigationHelper.navigateToIndex(context, addToBackStack: false);
      }
      return LoginSuccessResponse("Login Successful");
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

  Future<LoginResponse> signInWithEmail(
      String email, String password, BuildContext context) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    if (authResult != null && authResult.user != null) {
      final user = authResult.user;
      UserRepo().clearCurrentUser();
      await UserRepo().setCurrentUser(User.fromFirebaseUser(user));
      if (!user.emailVerified) {
        UserRepo().setEmailVerified(false);
        await user.sendEmailVerification();
        NavigationHelper.navigateToVerifyEmailScreen(context,
            addToBackStack: false);
        return LoginFailedResponse(ErrMessages.EMAIL_NOT_VERIFIED);
      } else {
        UserRepo().setEmailVerified(true);
        bool isFirstUser = false;
        isFirstUser = UserRepo().isFirstUser();
        if (isFirstUser) {
          NavigationHelper.navigateToWelcome(context, addToBackStack: false);
        } else {
          NavigationHelper.navigateToIndex(context, addToBackStack: false);
        }
      }
      return LoginSuccessResponse("Login Successful");
    } else {
      return LoginFailedResponse(ErrMessages.NO_USER_FOUND);
    }
  }

  Future<LoginResponse> signInWithGoogle(
      GoogleSignInAccount account, BuildContext context) async {
    final authentication = await account.authentication;
    final credentials = firebase.GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    return _signIn(credentials, context);
  }

  Future<LoginResponse> signInWithFacebook(
      LoginResult result, BuildContext context) async {
    final credentials =
        firebase.FacebookAuthProvider.credential(result.accessToken.token);
    return _signIn(credentials, context);
  }

  Future<bool> signOut() async {
    return _signOut();
  }
}
