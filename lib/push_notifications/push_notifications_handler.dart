import 'dart:io';

import 'package:chatapp/instant_messaging/instant_messaging_view.dart';
import 'package:chatapp/model/chat/chat_repo.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationsHandler extends NavigatorObserver {
  PushNotificationsHandler() {
    _setup();
  }

  void _setup() {
    if (Platform.isIOS) {
      _requestPermissionOniOS();
    } else if (Platform.isAndroid) {
      FirebaseMessaging.instance
          .getToken()
          .then((token) => UserRepo().setFCMToken(token));
    }

    FirebaseMessaging.onMessage.listen((message) {
      return _handleIncomingNotification(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      return _handleIncomingNotification(message.data);
    });
  }

  void _requestPermissionOniOS() {
    final permission = FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);

    permission.then((result) {
      if (result.alert == AppleNotificationSetting.enabled) {
        FirebaseMessaging.instance
            .getToken()
            .then((token) => UserRepo().setFCMToken(token));
      }
    });
  }

  Future<bool> _handleIncomingNotification(Map<String, dynamic> payload) async {
    Map<dynamic, dynamic> data = payload["data"];
    User otherUser = User(
        data["other_member_id"],
        data["other_member_name"],
        data['other_member_email'],
        data["other_member_photo_url"],
        "",
        data['tenantId']);
    User currentUser = UserRepo().getCurrentUser();
    if (currentUser == null) {
      return false;
    }
    ChatRepo.getInstance()
        .getChatroom(
      data["chatroom_id"],
      currentUser,
      otherUser,
    )
        .then(
      (chatroom) {
        navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => InstantMessagingScreen(
                      displayName: chatroom.name,
                      chatroomId: chatroom.id,
                    )),
            (Route<dynamic> route) => route.isFirst);
        return true;
      },
    );
    return false;
  }
}
