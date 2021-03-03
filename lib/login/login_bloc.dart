import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/login/login_state.dart';
import 'package:chatapp/model/login/login_repo.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(LoginState initialState) : super(initialState);

  void onLoginGoogle() async {
    add(LoginEventInProgress());
    final googleSignInRepo = GoogleSignIn(
        signInOption: SignInOption.standard, scopes: ["profile", "email"]);
    final account = await googleSignInRepo.signIn();
    if (account != null) {
      LoginRepo.getInstance().signInWithGoogle(account);
    } else {
      add(LogoutEvent());
    }
  }

  // void onLoginFacebook() async {
  //   add(LoginEventInProgress());
  //   final facebookSignInRepo = FacebookAuth.instance;
  //   final signInResult = await facebookSignInRepo.login();
  //   if (signInResult.status == 200) {
  //     LoginRepo.getInstance().signInWithFacebook(signInResult);
  //   } else if (signInResult.status == 403) {
  //     add(LogoutEvent());
  //   } else {
  //     add(LoginErrorEvent("An error occurred."));
  //   }
  // }

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
    } else if (event is LogoutEvent) {
      yield LoginState.loading(false);
    } else if (event is LoginEventInProgress) {
      yield LoginState.loading(true);
    } else if (event is LoginErrorEvent) {}
  }
}
