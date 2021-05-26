import 'dart:async';

import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/signup/signup_event.dart';
import 'package:chatapp/signup/signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc(SignUpState initialState) : super(initialState);

  void onSignUpWithEmail(
      String name, String date, String email, String password) async {
    add(SignUpEventInProgress());
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      UserRepo().setUpDatabase(credential.user.uid);
      UserRepo().setUserId(credential.user.uid);
      UserRepo().setEmail(email);
      UserRepo().setUserName(name);
      UserRepo().setFirstUser(true);
      UserRepo().setEmailVerified(credential.user.emailVerified);
      UserRepo().setBirthday(date);
      await credential.user.sendEmailVerification();
      add(SignUpSuccessEvent());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        add(SignUpErrorEvent(
            {'code': e.code, 'message': 'The password provided is too weak.'}));
      } else if (e.code == 'email-already-in-use') {
        add(SignUpErrorEvent({
          'code': e.code,
          'message':
              'The account already exists with that email. Please sign up with a different email'
        }));
      } else if (e.code == 'invalid-email') {
        add(SignUpErrorEvent({'code': e.code, 'message': 'Invalid Email'}));
      } else {
        add(SignUpErrorEvent({
          'code': e.code,
          'message':
              'There was an error creating your account. Please try again.'
        }));
      }
    } on Exception catch (e) {
      print("Error: ${e}");
      add(SignUpErrorEvent({'code': e, 'message': 'Unexpected Error'}));
    }
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpEventInProgress) {
      yield SignUpState.loading(true);
    } else if (event is SignUpSuccessEvent) {
      yield SignUpState.status({'success': true});
    } else if (event is SignUpStatusUpdate) {
      yield SignUpState.status(event.status);
    } else if (event is SignUpErrorEvent) {
      yield SignUpState.error(event.error);
    }
  }
}
