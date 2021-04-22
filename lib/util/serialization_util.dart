import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/model/chat/chatroom.dart';
import 'package:chatapp/model/message/message.dart';
import 'package:chatapp/model/user/user.dart';

class Deserializer {
  static List<User> deserializeUserFromReference(
      List<dynamic> refs, List<User> users) {
    return users.where((el) => refs.any((ref) => ref.id == el.uid)).toList();
  }

  static List<User> deserializeUsers(List<DocumentSnapshot> users) {
    return users.map((doc) => deserializeUser(doc)).toList();
  }

  static User deserializeUser(DocumentSnapshot doc) {
    return User(
      doc.data()['uid'],
      doc.data()['name'],
      doc.data()['imgUrl'],
      doc.data()['fcmToken'],
    );
  }

  static List<Chatroom> deserializeChatrooms(
      List<DocumentSnapshot> chatrooms, List<User> users) {
    return chatrooms.map((doc) => deserializeChatroom(doc, users)).toList();
  }

  static Chatroom deserializeChatroom(DocumentSnapshot doc, List<User> users) {
    List<dynamic> participantRefs = doc.data()['participants'];
    return Chatroom(
        deserializeUserFromReference(participantRefs, users).toList(),
        new List<Message>.empty(growable: true));
  }

  static Message deserializeMessage(
      Map<String, dynamic> doc, List<User> users) {
    DocumentReference authorReference = doc['author'];
    User author = users.firstWhere((user) => user.uid == authorReference.id);
    return Message(author, doc['timestamp'], doc['value']);
  }


  static List<Message> deserializeMessages(
      List<dynamic> messages, List<User> users) {
    return messages.map((data) {
      return deserializeMessage(Map<String, dynamic>.from(data), users);
    }).toList();
  }

  static Chatroom deserializeChatroomMessages(
      DocumentSnapshot doc, List<User> users) {
    List<dynamic> participantRefs = doc.data()['participants'];
    Chatroom chatroom = Chatroom(
        deserializeUserFromReference(participantRefs, users).toList(),
        new List<Message>.empty(growable: true));
    chatroom.messages
        .addAll(deserializeMessages(doc.data()['messages'], users));
    return chatroom;
  }
}
