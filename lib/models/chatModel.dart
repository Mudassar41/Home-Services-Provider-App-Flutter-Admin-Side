import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String user_1;
  String user_2;
  Timestamp time;
  String userFirstName;
  String userLastName;
  String providerFirstName;
  String providerLastName;
  List<ChatUser> chats;

  Chat();

  Chat.getAllChat({
    this.user_1,
    this.user_2,
    this.chats,
    this.time,
    this.userFirstName,
    this.userLastName,
    this.providerFirstName,
    this.providerLastName,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat.getAllChat(
    user_1: json["user_1"],
    user_2: json['user_2'],
    time: json['time'],
    chats:
    List<ChatUser>.from(json["chats"].map((x) => ChatUser.fromJson(x))),
    userFirstName: json['userFirstName'],
    userLastName: json['userLastName'],
    providerFirstName: json['providerFirstName'],
    providerLastName: json['providerLastName'],
  );
}

class ChatUser {
  String senderId;
  String recieverId;

  String message;
  Timestamp timestamp;

  ChatUser({this.senderId, this.recieverId, this.message, this.timestamp});

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
      senderId: json["senderId"],
      recieverId: json['recieverId'],
      message: json['message'],
      timestamp: json['time']);
}
