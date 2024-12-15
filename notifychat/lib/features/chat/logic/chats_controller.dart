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
  List<ChannelModel> subscribedChannels =
      Get.find<ChannelController>().subscribedChannels;

  TextEditingController newMessageController = TextEditingController();

  // temporary dummy chat room first before setting the actual chat room
  ChatRoomModel selectedChatRoom = ChatRoomModel(
    roomName: '',
    channelTopicId: '-1',
    chatRoomMessages: [],
  );

  ScrollController listViewScrollController = ScrollController();

  // called before navigating to the chat room screen
  setSelectedChatRoom(ChannelModel channel) async {
    try {
      final db = FirebaseDatabase.instance.ref('/chatRooms/${channel.id}/');

      final snapshot = await db.get();

      if (!snapshot.exists) {
        // if the chat room does not exist, create it
        createChatRoom(channel);
      } else {
        setData(snapshot.value);
      }
      // add listener for changes in the chat room
      db.onValue.listen((event) {
        setData(event.snapshot.value);
      });
    } catch (e) {
      print('Error fetching or creating chat room: $e');
    }
  }

  void setData(snapshot) {
    final data = Map<String, dynamic>.from(snapshot as Map);
    final chatRoom = ChatRoomModel.fromMap(data);

    selectedChatRoom = chatRoom;
    update(['chatRoom']);
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

    final userID = Get.find<HomeController>().userID;
    final newMessage = MessageModel(
      sentTime: DateTime.now(),
      senderID: userID,
      messageText: newMessageController.text,
    );

    // add message to chat room channel
    selectedChatRoom.chatRoomMessages.add(newMessage);
    update(['chatRoom']);

    newMessageController.clear();

    await updateChatRoomFirebase();
  }

  updateChatRoomFirebase() async {
    try {
      // update firebase realtime database
      final channelID = selectedChatRoom.channelTopicId;
      final db = FirebaseDatabase.instance.ref('/chatRooms/$channelID/');
      await db.set(selectedChatRoom.toMap());
    } catch (e) {
      print('Error updating chat room: $e');
    }
  }

  // used if the channel is deleted to remove the corresponding chat room
  removeChatRoom(ChannelModel channel) async {
    try {
      final channelID = channel.id;
      final db = FirebaseDatabase.instance.ref('/chatRooms/$channelID/');
      await db.remove();
    } catch (e) {
      print('Error removing chat room: $e');
    }
  }

  scrollToLastMessage() {
    listViewScrollController.animateTo(
      listViewScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
    update(['chatRoom']);
  }

  void setSubscribedChannels(List<ChannelModel> channels) {
    subscribedChannels = channels;
    update(['chats']);
  }
}
