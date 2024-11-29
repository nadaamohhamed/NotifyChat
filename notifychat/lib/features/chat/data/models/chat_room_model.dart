import 'package:notifychat/features/chat/data/models/message_model.dart';

class ChatRoomModel {
  String roomName;
  String channelTopicId;
  List<MessageModel> chatRoomMessages;

  ChatRoomModel({
    required this.roomName,
    required this.channelTopicId,
    required this.chatRoomMessages,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      roomName: map['roomName'] as String,
      channelTopicId: map['channelTopicId'] as String,
      chatRoomMessages: (map['chatRoomMessages'] as List<dynamic>)
          .map((e) => MessageModel.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'roomName': roomName,
      'channelTopicId': channelTopicId,
      'chatRoomMessages': chatRoomMessages.map((e) => e.toMap()).toList(),
    };
  }
}
