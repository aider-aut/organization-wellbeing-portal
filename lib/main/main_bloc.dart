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
  }
  User _currentUser;
  Map<String, String> imageUrls = new Map();
  final _instance = firebase_storage.FirebaseStorage.instance;
  List<String> _challenges = [];
  String _emotion;
  SelectedChatroom _chatroom;

  StreamSubscription<List<Chatroom>> chatroomsSubscription;

  void _initialize() {
    add(MainUpdateEventInProgress());
    _currentUser = UserRepo().getCurrentUser();
    if (_currentUser.tenantId == 'Employer') {
      UserRepo().fetchEmployees();
    }
    _challenges = UserRepo().getMyChallenges();
    retrieveChatroomForChatBotConversation();
    _getAssets();
  }

  void _getAssets() async {
    await getImages();
  }

  List<User> getEmployees() {
    return UserRepo().getEmployees();
  }

  String getBusiness() {
    return _currentUser.business;
  }

  bool isEmailVerified() {
    return _currentUser.isEmailVerified;
  }

  bool isUserEmployer() {
    return _currentUser.tenantId == 'Employer';
  }

  List<String> getMyChallenges() {
    return _challenges;
  }

  bool isFirstUser() {
    return _currentUser.isFirstUser;
  }

  Future<void> getImages() async {
    add(MainUpdateEventInProgress());
    final profileImage = _currentUser.imgURL;
    final profileUrl = (profileImage != null && profileImage.isNotEmpty)
        ? profileImage
        : await _instance.ref('profile.png').getDownloadURL();
    final loveUrl = await _instance.ref('love.png').getDownloadURL();
    final barrierUrl = await _instance.ref('barrier.png').getDownloadURL();

    imageUrls = {
      'mood': loveUrl,
      'barrier': barrierUrl,
      'profile': profileUrl,
    };
    add(MainUpdateEvent(_currentUser.name, _currentUser.imgURL,
        _currentUser.tenantId, imageUrls));
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
    UserRepo().setEmotion(emotion);
  }

  String getEmotion() {
    return _currentUser.emotion;
  }

  // void retrieveUserChatrooms() async {
  //   add(ClearChatroomsEvent());
  //   final user = await UserRepo().getCurrentUser();
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

  SelectedChatroom getChatroom() {
    return _chatroom;
  }

  void retrieveChatroomForChatBotConversation() {
    final currentUser = UserRepo().getCurrentUser();
    ChatRepo.getInstance()
        .startConversationWithChatBot(currentUser)
        .then((chatroom) {
      _chatroom = chatroom;
    });
  }

  // void retrieveChatroomForParticipant(
  //     User user, Function(SelectedChatroom) onChatroomProcessed) async {
  //   final currentUser = await UserRepo().getCurrentUser();
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
          event.name, event.profileImg, event.tenant, event.imageUrls);
    } else if (event is MainErrorEvent) {
      yield MainState.isLoading(false, state);
    } else if (event is MainEmployeesListUpdate) {
      yield MainState.updateEmployees(false, event.employees, state);
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
