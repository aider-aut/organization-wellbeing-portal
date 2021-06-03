import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/model/login/login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(initialState);

  void onLoginGoogle(GlobalKey scaffoldKey) async {
    add(LoginEventInProgress());
    final googleSignInRepo = GoogleSignIn(
        signInOption: SignInOption.standard, scopes: ["profile", "email"]);
    final account = await googleSignInRepo.signIn();
    if (account != null) {
      try {
        LoginRepo.getInstance()
            .signInWithGoogle(account, scaffoldKey.currentContext);
        add(LoginWithGoogleEvent());
      } on Exception catch (ex) {
        add(LoginErrorEvent("Could not log in with Google: ${ex.toString()}"));
      }
    } else {
      add(LogoutEvent());
    }
  }

  void onLoginFacebook(GlobalKey scaffoldKey) async {
    add(LoginEventInProgress());
    final facebookSignInRepo = FacebookAuth.instance;
    try {
      final signInResult = await facebookSignInRepo.login();
      LoginRepo.getInstance()
          .signInWithFacebook(signInResult, scaffoldKey.currentContext);
      add(LoginWithFacebookEvent());
    } on Exception catch (ex) {
      add(LoginErrorEvent("An error occurred. ${ex.toString()}"));
    }
  }

  void onLoginWithEmail(
      String email, String password, BuildContext context) async {
    add(LoginEventInProgress());
    try {
      await LoginRepo.getInstance().signInWithEmail(email, password, context);
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
