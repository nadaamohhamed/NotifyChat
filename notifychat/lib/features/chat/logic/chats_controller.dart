import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:notifychat/features/channels/data/models/channel_model.dart';
import 'package:notifychat/features/channels/logic/channel_controller.dart';
import 'package:notifychat/features/chat/data/models/chat_room_model.dart';
import 'package:notifychat/features/chat/data/models/message_model.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';

class ChatsController extends GetxController {
  List<ChannelModel> allChannels = Get.find<ChannelController>().allChannels;

  TextEditingController newMessageController = TextEditingController();

  ChatRoomModel? selectedChatRoom;

  setSelectedChatRoom(ChannelModel channel) async {
    try {
      final db = FirebaseDatabase.instance.ref('/chatRooms/${channel.id}/');

      final snapshot = await db.get();

      if (!snapshot.exists) {
        // if the chat room does not exist, create it
        createChatRoom(channel);
      }
      // listen for changes in the chat room
      db.onValue.listen((event) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final chatRoom = ChatRoomModel.fromMap(data);

        selectedChatRoom = chatRoom;
        update(['chatRoom']);
      });
    } catch (e) {
      // temporary dummy chat room if there is an error to not break the UI by selectChatRoom
      selectedChatRoom = ChatRoomModel(
        roomName: 'Chat Room',
        channelTopicId: '0',
        chatRoomMessages: [],
      );
      print('Error fetching or creating chat room: $e');
    }
  }

  createChatRoom(ChannelModel channel) {
    final chatRoom = ChatRoomModel(
      roomName: channel.name,
      channelTopicId: channel.id,
      chatRoomMessages: [],
    );
    selectedChatRoom = chatRoom;
  }

  sendMessage() async {
    if (newMessageController.text.isEmpty) return;

    final userID = Get.find<HomeController>().userID!;
    final newMessage = MessageModel(
      sentTime: DateTime.now(),
      senderID: userID,
      messageText: newMessageController.text,
    );

    // add message to chat room channel
    selectedChatRoom!.chatRoomMessages.add(newMessage);
    update(['chatRoom']);

    newMessageController.clear();

    await updateChatRoomFirebase();
  }

  updateChatRoomFirebase() async {
    // update firebase realtime database
    final channelID = selectedChatRoom!.channelTopicId;
    final db = FirebaseDatabase.instance.ref('/chatRooms/$channelID/');

    try {
      await db.set(selectedChatRoom!.toMap());
    } catch (e) {
      print('Error updating chat room: $e');
    }
  }

  // used if the channel is deleted to remove the corresponding chat room
  removeChatRoom(ChannelModel channel) async {
    final channelID = channel.id;
    final db = FirebaseDatabase.instance.ref('/chatRooms/$channelID/');

    try {
      await db.remove();
      print('Chat room removed successfully for channel: $channelID');
    } catch (e) {
      print('Error removing chat room: $e');
    }
  }

  void setAllChannels(List<ChannelModel> channels) {
    allChannels = channels;
    update(['chats']);
  }
}
