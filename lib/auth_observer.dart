import 'dart:async';

import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthObserver extends NavigatorObserver {
  AuthObserver() {
    _setup();
  }

  StreamSubscription<firebase.User> _authStateListener;

  Future<void> _setup() async {
    await Firebase.initializeApp();
    if (_authStateListener == null) {
      _authStateListener =
          firebase.FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          print("user: ${user.toString()}");
          final loginProvider = user.providerData.first.providerId;
          UserRepo().setCurrentUser(User.fromFirebaseUser(user));
          // UserRepo().fetchCurrentUser(user.uid);
          if (loginProvider == "google") {
            // TODO analytics call for google login provider
          } else {
            // TODO analytics call for facebook login provider
          }
          bool isFirstUser = false;
          isFirstUser = UserRepo().isFirstUser(userId: user.uid);
          if (!user.emailVerified) {
            NavigationHelper.navigateToVerifyEmailScreen(navigator.context,
                removeUntil: (_) => false);
          } else if (isFirstUser) {
            try {
              NavigationHelper.navigateToWelcome(navigator.context,
                  removeUntil: (_) => false);
            } catch (error) {
              print(
                  "[navigateToWelcome] error happened on auth observer ${error.toString()}");
            }
          } else {
            try {
              NavigationHelper.navigateToIndex(navigator.context,
                  removeUntil: (_) => false);
            } catch (error) {
              print(
                  "[navigateToIndex] error happened on auth observer ${error.toString()}");
            }
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
