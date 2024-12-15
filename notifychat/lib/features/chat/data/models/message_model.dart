import 'package:get/get.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';

class MessageModel {
  final String messageText;
  final String senderID;
  final DateTime sentTime;

  MessageModel({
    required this.messageText,
    required this.senderID,
    required this.sentTime,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageText: map['messageText'] as String,
      senderID: map['senderID'] as String,
      sentTime: DateTime.parse(map['sentTime'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageText': messageText,
      'senderID': senderID,
      'sentTime': sentTime.toString(),
    };
  }

  bool get isSentByMe {
    final currentUserID = Get.find<HomeController>().userID;
    return senderID == currentUserID;
  }
}
