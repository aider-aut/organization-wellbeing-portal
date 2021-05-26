import 'package:chatapp/create_chatroom/create_chatroom_view.dart';
import 'package:chatapp/demographics/demographics_view.dart';
import 'package:chatapp/instant_messaging/instant_messaging_view.dart';
import 'package:chatapp/login/login_email/login_email_view.dart';
import 'package:chatapp/login/login_view.dart';
import 'package:chatapp/main/index_view.dart';
import 'package:chatapp/signup/signup_view.dart';
import 'package:chatapp/welcome/welcome_step.dart';
import 'package:flutter/material.dart';

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

  static void navigateToIndex(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => IndexScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IndexScreen()));
    }
  }

  static void navigateToDemographics(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DemographicScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => DemographicScreen()));
    }
  }

  static void navigateToSettings(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'Settings',
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacementNamed(context, 'Settings');
    }
  }

  static void navigateToAccount(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'Account',
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacementNamed(context, 'Account');
    }
  }

  static void navigateToAbout(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        'About',
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacementNamed(context, 'About');
    }
  }

  static void navigateToEdit(BuildContext context, String info) {
    Navigator.pushNamed(context, 'AccountEdit', arguments: info);
  }

  static void navigateToWelcome(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeStepScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => WelcomeStepScreen()));
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
