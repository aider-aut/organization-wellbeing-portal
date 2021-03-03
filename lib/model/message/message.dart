import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/model/user/user.dart';

class Message {
  Message(this.author, this.timestamp, this.value, [this.outgoing = false]);

  final User author;
  final Timestamp timestamp;
  final String value;
  final bool outgoing;
}
