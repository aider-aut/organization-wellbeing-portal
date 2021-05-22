import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/model/login/login_repo.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/navigation_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(initialState);

  void onLoginGoogle() async {
    add(LoginEventInProgress());
    final googleSignInRepo = GoogleSignIn(
        signInOption: SignInOption.standard, scopes: ["profile", "email"]);
    final account = await googleSignInRepo.signIn();
    if (account != null) {
      try {
        LoginRepo.getInstance().signInWithGoogle(account);
        add(LoginWithGoogleEvent());
      } on Exception catch (ex) {
        add(LoginErrorEvent("Could not log in with Google: ${ex.toString()}"));
      }
    } else {
      add(LogoutEvent());
    }
  }

  void onLoginFacebook() async {
    add(LoginEventInProgress());
    final facebookSignInRepo = FacebookAuth.instance;
    try {
      final signInResult = await facebookSignInRepo.login();
      LoginRepo.getInstance().signInWithFacebook(signInResult);
      add(LoginWithFacebookEvent());
    } on Exception catch (ex) {
      add(LoginErrorEvent("An error occurred. ${ex.toString()}"));
    }
  }

  void onLoginWithEmail(
      String email, String password, BuildContext context) async {
    add(LoginEventInProgress());
    try {
      await LoginRepo.getInstance().signInWithEmail(email, password);
      bool _isFirstUser = UserRepo().isFirstUser();
      bool _isEmailVerified = UserRepo().isEmailVerified();

      if (_isFirstUser || !_isEmailVerified) {
        NavigationHelper.navigateToWelcome(context, addToBackStack: false);
      } else {
        NavigationHelper.navigateToMain(context, addToBackStack: false);
      }
      add(LoginWithEmailEvent());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == "user-not-found") {
        add(LoginErrorEvent(
            {'code': ex.code, 'message': "Please sign up first!"}));
      } else if (ex.code == 'invalid-email') {
        add(LoginErrorEvent(
            {'code': ex.code, 'message': "Please enter a valid email"}));
      } else {
        add(LoginErrorEvent({'code': ex.code, 'message': "ERR: ${ex.code}"}));
      }

      print("Failed with error code: ${ex.code}");
      print(ex.message);
    }
  }

  void onLogout() async {
    add(LoginEventInProgress());
    bool result = await LoginRepo.getInstance().signOut();
    if (result) {
      add(LogoutEvent());
    }
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithGoogleEvent) {
      yield LoginState.loading(false);
    } else if (event is LoginWithFacebookEvent) {
      yield LoginState.loading(false);
    } else if (event is LoginWithEmailEvent) {
      yield LoginState.loading(false);
    } else if (event is LogoutEvent) {
      yield LoginState.loading(false);
    } else if (event is LoginEventInProgress) {
      yield LoginState.loading(true);
    } else if (event is LoginErrorEvent) {
      yield LoginState.error(event.error);
    }
  }
}
