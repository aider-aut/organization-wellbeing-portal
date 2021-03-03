import 'package:chatapp/model/message/message.dart';

abstract class InstantMessagingEvent {}

class MessageReceivedEvent extends InstantMessagingEvent {
  final List<Message> messages;

  MessageReceivedEvent(this.messages);
}

class MessageSendErrorEvent extends InstantMessagingEvent {}

class FileUploadingEvent extends InstantMessagingEvent {}
