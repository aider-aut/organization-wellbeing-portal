import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chatapp/main/main_event.dart';
import 'package:chatapp/main/main_state.dart';
import 'package:chatapp/model/chat/chatroom.dart';
import 'package:chatapp/model/login/login_repo.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/user/user_repo.dart';
import 'package:chatapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/model/chat/chat_repo.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc(MainState initialState) : super(initialState) {
    retrieveUserChatrooms();
  }

  StreamSubscription<List<Chatroom>> chatroomsSubscription;

  void logout(VoidCallback onLogout) {
    LoginRepo.getInstance().signOut().then((success) {
      if (success) {
        onLogout();
      }
    });
  }

  void retrieveUserChatrooms() async {
    add(ClearChatroomsEvent());
    final user = await UserRepo.getInstance().getCurrentUser();
    if (user != null) {
      chatroomsSubscription =
          ChatRepo.getInstance().getChatroomsForUser(user).listen((chatrooms) {
        chatrooms.forEach((room) {
          if (room.participants.first.uid == user.uid) {
            Util.swapElementsInList(room.participants, 0, 1);
          }
        });
        add(ChatroomsUpdatedEvent(chatrooms));
      });
    } else {
      add(MainErrorEvent());
    }
  }

  void retrieveChatroomForChatBotConversation(Function(SelectedChatroom) onChatBotConversationProcessed) async {
    final currentUser = await UserRepo.getInstance().getCurrentUser();
    ChatRepo.getInstance().startConversationWithChatBot(currentUser).then((chatroom) {
      onChatBotConversationProcessed(chatroom);
    });
  }

  void retrieveChatroomForParticipant(
      User user, Function(SelectedChatroom) onChatroomProcessed) async {
    final currentUser = await UserRepo.getInstance().getCurrentUser();
    List<User> users = new List<User>.empty(growable: true);
    users.add(user);
    users.add(currentUser);
    ChatRepo.getInstance().startChatroomForUsers(users).then((chatroom) {
      onChatroomProcessed(chatroom);
    });
  }

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is ClearChatroomsEvent) {
      yield MainState.isLoading(true, MainState.initial());
    } else if (event is ChatroomsUpdatedEvent) {
      yield MainState.isLoading(
          false, MainState.chatrooms(event.chatrooms, state));
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
