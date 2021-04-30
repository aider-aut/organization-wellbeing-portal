import 'dart:async';

import 'package:chatapp/model/login/login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/navigation_helper.dart';

class AuthObserver extends NavigatorObserver {
  AuthObserver() {
    _setup();
  }

  StreamSubscription<firebase.User> _authStateListener;

  Future<void> _setup() async {
    await Firebase.initializeApp();
    if (_authStateListener == null) {
      // final actionCodeSettings = firebase.ActionCodeSettings(
      //     url: "https://chatapp-2dfea.firebaseapp.com/",
      //     handleCodeInApp: true,
      //     iOSBundleId: "com.example.ios",
      //     androidPackageName: "com.example.android");
      _authStateListener =
          firebase.FirebaseAuth.instance.authStateChanges().listen((user) {
        //print("this is a user ${user.email}");
        // firebase.FirebaseAuth.instance.sendSignInLinkToEmail(email: user.email, actionCodeSettings: actionCodeSettings).whenComplete()

        if (user != null) {
          final loginProvider = user.providerData.first.providerId;
          UserRepo.getInstance().setCurrentUser(User.fromFirebaseUser(user));
          if (loginProvider == "google") {
            // TODO analytics call for google login provider
          } else {
            // TODO analytics call for facebook login provider
          }
          if (LoginRepo.getInstance().isNewUser()) {
            NavigationHelper.navigateToWelcome(navigator.context,
                removeUntil: (_) => false);
          } else {
            NavigationHelper.navigateToMain(navigator.context,
                removeUntil: (_) => false);
          }
        } else {
          NavigationHelper.navigateToLogin(navigator.context,
              removeUntil: (_) => false);
        }
      }, onError: (error) {
        NavigationHelper.navigateToLogin(navigator.context,
            removeUntil: (_) => false);
      });
    }
  }

  void close() {
    _authStateListener?.cancel();
  }
}
