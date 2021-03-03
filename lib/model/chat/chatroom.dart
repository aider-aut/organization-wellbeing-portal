import 'package:chatapp/model/message/message.dart';
import 'package:chatapp/model/user/user.dart';

class SelectedChatroom {
  SelectedChatroom(this.id, this.name);

  final String id;
  final String name;
}

class Chatroom {
  Chatroom(this.participants, [this.messages]);

  final List<User> participants;
  final List<Message> messages;
}
