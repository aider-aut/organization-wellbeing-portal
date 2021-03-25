import 'package:chatapp/login/login_email/login_email_view.dart';
import 'package:chatapp/signup/signup_view.dart';
import 'package:flutter/material.dart';

import 'package:chatapp/login/login_view.dart';
import 'package:chatapp/main/main_view.dart';
import 'package:chatapp/create_chatroom/create_chatroom_view.dart';
import 'package:chatapp/instant_messaging/instant_messaging_view.dart';

bool Function(Route<dynamic>) _defaultRule = (_) => true;

class NavigationHelper {
  static void navigateToLogin(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  static void navigateToMain(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
  }

  static void navigateToAddChat(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CreateChatroomScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => CreateChatroomScreen()));
    }
  }

  static void navigateToSignUp(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }
  }

  static void navigateToLogInWithEmail(BuildContext context,
      {bool addToBackStack: false, bool Function(Route<dynamic>) removeUntil}) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginEmailScreen()),
          removeUntil ?? _defaultRule);
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginEmailScreen()));
    }
  }

  static void navigateToInstantMessaging(
    BuildContext context,
    String displayName,
    String chatroomId, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => InstantMessagingScreen(
            displayName: displayName,
            chatroomId: chatroomId,
          ),
        ),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InstantMessagingScreen(
            displayName: displayName,
            chatroomId: chatroomId,
          ),
        ),
      );
    }
  }
}
