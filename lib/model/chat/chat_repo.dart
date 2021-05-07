import 'dart:async';
import 'dart:convert';
import 'package:chatapp/model/message/message.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/model/user/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chatapp/util/constants.dart';
import 'package:chatapp/util/serialization_util.dart';
import 'package:chatapp/model/chat/chatroom.dart';
import 'package:chatapp/model/storage/firebase_repo.dart';
import 'package:chatapp/model/user/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatRepo {
  static ChatRepo _instance;

  final FirebaseFirestore _firestore;
  bool _isChatBot = false;
  final _chatUsersSubject = BehaviorSubject<List<User>>();
  String _chatBotId;

  ChatRepo._internal(this._firestore);

  factory ChatRepo.getInstance() {
    if (_instance == null) {
      _instance = ChatRepo._internal(FirebaseRepo.getInstance().firestore);
      _instance._getChatUsersInternal();
    }
    return _instance;
  }

  void _getChatUsersInternal() {
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .orderBy("name")
        .snapshots()
        .map((data) => Deserializer.deserializeUsers(data.docs))
        .listen((users) {
        _chatUsersSubject.sink.add(users);
    });
  }


  Stream<List<User>> getChatUsers() {
    return _chatUsersSubject.stream;
  }

  bool isOtherUserChatBot() {
    return _isChatBot;
  }

  Future<SelectedChatroom> getChatroom(
      String chatroomId, User currentUser, User otherUser) async {
    DocumentReference chatroomRef =
        _firestore.doc(FirestorePaths.CHATROOMS_COLLECTION + "/" + chatroomId);
    if (chatroomRef != null) {
      List<User> users = new List.empty(growable: true);
      users.add(otherUser);
      users.add(currentUser);
      try {
        return SelectedChatroom(chatroomId, otherUser.name);
      } catch (error) {
        print(error);
        return null;
      }
    } else {
      return null;
    }
  }

  Stream<List<Chatroom>> getChatroomsForUser(User user) {
    DocumentReference userRef =
        _firestore.doc(FirestorePaths.USERS_COLLECTION + "/" + user.uid);
    return _firestore
        .collection(FirestorePaths.CHATROOMS_COLLECTION)
        .where(
          "participants",
          arrayContains: userRef,
        )
        .snapshots()
        .map((data) => Deserializer.deserializeChatrooms(
            data.docs, _chatUsersSubject.value));
  }

  Stream<Chatroom> getMessagesForChatroom(String chatroomId) {
    return _firestore
        .collection(FirestorePaths.CHATROOMS_COLLECTION)
        .doc(chatroomId)
        .snapshots()
        .map((data) {
      Chatroom chatroom = Deserializer.deserializeChatroomMessages(
          data, _chatUsersSubject.value);
      chatroom.messages.sort((message1, message2) =>
          message1.timestamp.compareTo(message2.timestamp));
      return chatroom;
    });
  }
  Future<SelectedChatroom> startConversationWithChatBot(User user) async {
    _isChatBot = true;
    DocumentReference chatbotRef = _firestore.collection(FirestorePaths.USERS_COLLECTION).doc("7D8rg58JthJzV7vhhZQ4");
    DocumentReference userRef = _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(user.uid);
    QuerySnapshot queryResults = await _firestore.collection(FirestorePaths.CHATROOMS_COLLECTION).where("participants",arrayContains: userRef).get();
    DocumentSnapshot roomSnapshot = queryResults.docs.firstWhere((room) {
      return room.data()['participants'].contains(chatbotRef);
    }, orElse: () => null);
    if (roomSnapshot != null) {
      return SelectedChatroom(roomSnapshot.id, "chatbot");
    } else {
      //if does not exist
      Map<String, dynamic> chatHistory = Map<String, dynamic>();
      chatHistory['messages'] = new List<String>.empty(growable: true);
      List<DocumentReference> participants = new List<DocumentReference>.empty(growable: true);
      participants.add(chatbotRef);
      participants.add(userRef);
      chatHistory['participants'] = participants;
      DocumentReference ref = await _firestore.collection(FirestorePaths.CHATROOMS_COLLECTION).add(chatHistory);
      DocumentSnapshot chatHistorySnapshot = await ref.get();
      return SelectedChatroom(chatHistorySnapshot.id, "chatbot");
    }
  }

  Future<SelectedChatroom> startChatroomForUsers(List<User> users) async {
    DocumentReference userRef = _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(users[1].uid);
    QuerySnapshot queryResults = await _firestore
        .collection(FirestorePaths.CHATROOMS_COLLECTION)
        .where("participants", arrayContains: userRef)
        .get();
    DocumentReference otherUserRef = _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(users[0].uid);
    DocumentSnapshot roomSnapshot = queryResults.docs.firstWhere((room) {
      return room.data()["participants"].contains(otherUserRef);
    }, orElse: () => null);
    if (roomSnapshot != null) {
      return SelectedChatroom(roomSnapshot.id, users[0].name);
    } else {
      Map<String, dynamic> chatroomMap = Map<String, dynamic>();
      chatroomMap["messages"] = new List<String>.empty(growable: true);
      List<DocumentReference> participants = new List<DocumentReference>.empty(growable: true);
      participants.add(otherUserRef);
      participants.add(userRef);
      chatroomMap["participants"] = participants;
      DocumentReference reference = await _firestore
          .collection(FirestorePaths.CHATROOMS_COLLECTION)
          .add(chatroomMap);
      DocumentSnapshot chatroomSnapshot = await reference.get();
      return SelectedChatroom(chatroomSnapshot.id, users[0].name);
    }
  }

  Future<bool> sendMessageToChatbot(String chatBotId, String message) async {
    _chatBotId = chatBotId;
    User currentUser = await UserRepo.getInstance().getCurrentUser();
    DocumentReference authorRef = _firestore.collection(
        FirestorePaths.USERS_COLLECTION).doc(currentUser.uid);
    DocumentReference chatHistoryRef = _firestore.collection(
        FirestorePaths.CHATROOMS_COLLECTION).doc(chatBotId);
    DocumentReference chatbotRef = _firestore.collection(
        FirestorePaths.USERS_COLLECTION).doc("7D8rg58JthJzV7vhhZQ4");
    try {
      Map<String, dynamic> serializedMessage = {
        "author": authorRef,
        "timestamp": DateTime.now(),
        "value": message,
        "option": false
      };
      chatHistoryRef.update({
        "messages": FieldValue.arrayUnion([serializedMessage])
      });
    } catch(err) {
      print("ERROR SENDING: ${err.toString()}");
    }
    try {
      final response = await http.post(
        env['CHATBOT_ENDPOINT'],
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'sender': currentUser.uid,
          'message': message
        }),
      );
      if(response.statusCode == 200 ){

        List<dynamic> temp = jsonDecode(response.body);

          for(var i = 0; i < temp.length; i++){
            Map<String, dynamic> res = temp[i];
            print("BOTRES: ${res.toString()}");
            if(res['text'] != null) {
              Map<String, dynamic> serializedMessage = {
                "author": chatbotRef,
                "timestamp": DateTime.now(),
                "value": res['text'],
                "option": false
              };
              chatHistoryRef.update({
                "messages": FieldValue.arrayUnion([serializedMessage])
              });
            }
            if (res['buttons'] != null) {
              List<dynamic> buttons_arr = res['buttons'];
              // print("BUTTONS: ${res['buttons']}");
              for(var i = 0; i < buttons_arr.length; i++) {
                Map<String, dynamic> res = buttons_arr[i];
                if (res['title'] != null) {
                  Map<String, dynamic> serializedMessage = {
                    "author": chatbotRef,
                    "timestamp": DateTime.now(),
                    "value": res['title'],
                    "option": true
                  };
                  chatHistoryRef.update({
                    "messages": FieldValue.arrayUnion([serializedMessage])
                  });
                }
              }
            }
          }
        return true;
      } else {
        print("CHATBOT: Failed at receiving data from RASA: status code - ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("CHATBOT: something went wrong at POST request: ${e.toString()}");
      return false;
    }
  }

  Future<void> deleteMessageAfterSelected(Message sentMessage) {
    WriteBatch batch = _firestore.batch();
    DocumentReference chatHistoryRef = _firestore.collection(
        FirestorePaths.CHATROOMS_COLLECTION).doc(_chatBotId);
    return chatHistoryRef.get().then((data) {
      if (data.data()['messages'] != null) {
        Map<String, dynamic> temp = data.data();
        temp['messages'].removeWhere((item) => item['option'] == true);
        batch.update(data.reference, temp);
      }
      return batch.commit();
    });

  }

  Future<bool> sendMessageToChatroom(
      String chatroomId, User user, String message) async {
    try {
      DocumentReference authorRef =
          _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(user.uid);
      DocumentReference chatroomRef = _firestore
          .collection(FirestorePaths.CHATROOMS_COLLECTION)
          .doc(chatroomId);
      Map<String, dynamic> serializedMessage = {
        "author": authorRef,
        "timestamp": DateTime.now(),
        "value": message
      };
      chatroomRef.update({
        "messages": FieldValue.arrayUnion([serializedMessage])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void dismiss() {
    _chatUsersSubject.close();
  }
}
