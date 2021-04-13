import 'dart:async';

import 'package:chatapp/model/login/login_repo.dart';
import 'package:chatapp/signup/signup_event.dart';
import 'package:chatapp/signup/signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(SignUpState initialState) : super(initialState);

  void onSignUpWithEmail(String email, String password) async {
    add(SignUpEventInProgress());
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      add(SignUpWithEmailEvent());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        add(SignUpErrorEvent({'code':e.code, 'message':'The password provided is too weak.'}));
      } else if (e.code == 'email-already-in-use') {
        add(SignUpErrorEvent({'code':e.code, 'message':'The account already exists for that email.'}));
      } else if (e.code == 'invalid-email') {
        add(SignUpErrorEvent({'code':e.code, 'message':'Invalid Email'}));
      } else {
        add(SignUpErrorEvent({'code':e.code, 'message':'There was an error creating your account. Please try again.'}));
      }
    } catch (e) {
      print("Error: ${e}");
      add(SignUpErrorEvent({'code':e, 'message':'Unexpected Error'}));
    }

    try {
      await LoginRepo.getInstance().signInWithEmail(email, password);
    } on FirebaseAuthException catch (ex) {
      add(SignUpErrorEvent({'code': ex.code, 'message':"ERR: ${ex.code}"}));
      print("SIGNIN ERROR - Failed with error code: ${ex.code}");
      print(ex.message);
    }
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpWithEmailEvent) {
      yield SignUpState.loading(false);
    } else if (event is SignUpEvent) {
      yield SignUpState.loading(false);
    } else if (event is SignUpEventInProgress) {
      yield SignUpState.loading(true);
    } else if (event is SignUpErrorEvent) {
      yield SignUpState.loading(false);
      yield SignUpState.error(event.error);
    }
  }
}
