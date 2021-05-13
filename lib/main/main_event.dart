import 'package:chatapp/model/chat/chatroom.dart';

abstract class MainEvent {}

class ClearChatroomsEvent extends MainEvent {}
class MainUpdateEventInProgress extends MainEvent {}

class MainUserNotFoundEvent extends MainEvent {}

class MainUpdateEvent extends MainEvent {
  MainUpdateEvent(this.name, this.profileImg, this.imageUrls);
  final String name;
  final String profileImg;
  final Map<String, String> imageUrls;
}


class MainErrorEvent extends MainEvent {}
