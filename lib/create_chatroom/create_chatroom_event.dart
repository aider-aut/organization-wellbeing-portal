import 'package:chatapp/model/user/user.dart';

abstract class CreateChatroomEvent {}

class ChatroomUserListUpdatedEvent extends CreateChatroomEvent {
  ChatroomUserListUpdatedEvent(this.users);

  final List<User> users;
}

class CreateChatroomRequestedEvent extends CreateChatroomEvent {}

class CancelCreateChatroomEvent extends CreateChatroomEvent {}
