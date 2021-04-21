import 'package:chatapp/model/user/user.dart';
import 'package:chatapp/model/chat/chatroom.dart';

class CreateChatroomAction {
  CreateChatroomAction(this.chatroom, this.canceled);

  final SelectedChatroom chatroom;
  final bool canceled;
}

class CreateChatroomState {
  final List<User> users;
  final bool isLoading;
  final CreateChatroomAction action;

  CreateChatroomState._internal(this.users, this.isLoading, {this.action});

  factory CreateChatroomState.initial() =>
      CreateChatroomState._internal(new List<User>.empty(growable: true), true);

  factory CreateChatroomState.isLoading(
          bool isLoading, CreateChatroomState state) =>
      CreateChatroomState._internal(state.users, isLoading);

  factory CreateChatroomState.users(
          List<User> users, CreateChatroomState state) =>
      CreateChatroomState._internal(users, state.isLoading);
}
