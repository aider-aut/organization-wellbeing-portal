import 'dart:async';

import 'package:chatapp/login/login_event.dart';
import 'package:chatapp/model/login/login_repo.dart';
import 'package:chatapp/signup/signup_event.dart';
import 'package:chatapp/signup/signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(SignUpState initialState) : super(initialState);

  void onSignUpWithEmail(String email, String password) async {
    add(SignUpEventInProgress());
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      LoginRepo.getInstance().signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        add(SignUpErrorEvent('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        add(SignUpErrorEvent('The account already exists for that email.'));
      }
    } catch (e) {
      print(e);
    }
    add(SignUpWithEmailEvent());
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpWithEmailEvent) {
      yield SignUpState.loading(false);
    } else if (event is SignUpEvent) {
      yield SignUpState.loading(false);
    } else if (event is SignUpEventInProgress) {
      yield SignUpState.loading(true);
    } else if (event is LoginErrorEvent) {}
  }
}
