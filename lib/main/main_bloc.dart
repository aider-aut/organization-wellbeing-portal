import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatapp/main/main_event.dart';
import 'package:chatapp/main/main_state.dart';
import 'package:chatapp/model/chat/chat_repo.dart';
import 'package:chatapp/model/chat/chatroom.dart';
import 'package:chatapp/model/login/login_repo.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc(MainState initialState) : super(initialState) {
    _initialize();
    // retrieveUserChatrooms();
  }
  User _currentUser;
  Map<String, String> imageUrls = new Map();
  final _instance = firebase_storage.FirebaseStorage.instance;
  String _emotion;
  bool _isEmailVerified;
  bool _isFirstUser;

  StreamSubscription<List<Chatroom>> chatroomsSubscription;

  void _initialize() async {
    add(MainUpdateEventInProgress());
    _currentUser = await UserRepo.getInstance().getCurrentUser();
    UserRepo.getInstance().isEmailVerified().then((value) {
      _isEmailVerified = value;
    });
    UserRepo.getInstance().isFirstUser().then((value) {
      _isFirstUser = value;
    });
    // if (_currentUser != null) {
    imageUrls = await getImages();
    _emotion = await UserRepo.getInstance().getEmotion();
    add(MainUpdateEvent(_currentUser.name, _currentUser.imgURL, imageUrls));
    // }
  }

  bool isEmailVerified() {
    return _isEmailVerified;
  }

  bool isFirstUser() {
    return _isFirstUser;
  }

  Future<Map<String, String>> getImages() async {
    final profile_url = await _instance.ref('profile.png').getDownloadURL();
    final love_url = await _instance.ref('love.png').getDownloadURL();
    final barrier_url = await _instance.ref('barrier.png').getDownloadURL();

    imageUrls = {
      'mood': love_url,
      'barrier': barrier_url,
      'profile': profile_url,
    };

    return imageUrls;
  }

  Map<String, String> getImageUrls() {
    return imageUrls;
  }

  void logout(VoidCallback onLogout) {
    LoginRepo.getInstance().signOut().then((success) {
      if (success) {
        onLogout();
      }
    });
  }

  void updateEmotion(String emotion) {
    UserRepo.getInstance().setEmotion(emotion);
  }

  String getEmotion() {
    return _emotion;
  }

  // void retrieveUserChatrooms() async {
  //   add(ClearChatroomsEvent());
  //   final user = await UserRepo.getInstance().getCurrentUser();
  //   if (user != null) {
  //     chatroomsSubscription =
  //         ChatRepo.getInstance().getChatroomsForUser(user).listen((chatrooms) {
  //       chatrooms.forEach((room) {
  //         if (room.participants.first.uid == user.uid) {
  //           Util.swapElementsInList(room.participants, 0, 1);
  //         }
  //       });
  //     });
  //   } else {
  //     add(MainErrorEvent());
  //   }
  // }

  void retrieveChatroomForChatBotConversation(
      Function(SelectedChatroom) onChatBotConversationProcessed) async {
    final currentUser = await UserRepo.getInstance().getCurrentUser();
    ChatRepo.getInstance()
        .startConversationWithChatBot(currentUser)
        .then((chatroom) {
      onChatBotConversationProcessed(chatroom);
    });
  }

  // void retrieveChatroomForParticipant(
  //     User user, Function(SelectedChatroom) onChatroomProcessed) async {
  //   final currentUser = await UserRepo.getInstance().getCurrentUser();
  //   List<User> users = new List<User>.empty(growable: true);
  //   users.add(user);
  //   users.add(currentUser);
  //   ChatRepo.getInstance().startChatroomForUsers(users).then((chatroom) {
  //     onChatroomProcessed(chatroom);
  //   });
  // }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is MainUpdateEventInProgress) {
      yield MainState.isLoading(true, state);
    } else if (event is MainUpdateEvent) {
      yield MainState.update(
          event.name, event.profileImg, event.imageUrls, state);
    } else if (event is MainErrorEvent) {
      yield MainState.isLoading(false, state);
    }
  }

  @override
  Future<void> close() async {
    if (chatroomsSubscription != null) {
      chatroomsSubscription.cancel();
    }
    return super.close();
  }
}
