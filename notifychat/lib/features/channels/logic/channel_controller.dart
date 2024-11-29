import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/features/channels/data/models/channel_model.dart';
import 'package:notifychat/features/chat/logic/chats_controller.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';

class ChannelController extends GetxController {
  List<ChannelModel> allChannels = [];
  String userID = Get.find<HomeController>().userID!;

  // list of all subscribed channels
  List<ChannelModel> subscribedChannels = [];

  // new channel attributes
  TextEditingController channelNameController = TextEditingController();
  TextEditingController channelDescriptionController = TextEditingController();
  GlobalKey<FormState> channelFormKey = GlobalKey<FormState>();

  bool isLoading = true;

  @override
  void onInit() async {
    super.onInit();

    getAllChannels();
    await getAllSubscribedChannels();
  }

  getAllChannels() {
    FirebaseFirestore.instance.collection('channels').snapshots().listen(
      (event) {
        isLoading = true;
        allChannels = event.docs
            .map(
              (doc) => ChannelModel.fromMap(doc.data()),
            )
            .toList();
        isLoading = false;
        update(['channels']);
        Get.find<ChatsController>().setAllChannels(allChannels);

        // also update subscribed channels if any channel is deleted
        for (var channel in subscribedChannels) {
          if (!allChannels.map((item) => item.id).contains(channel.id)) {
            removeChannelSubscription(channel);
          }
        }
      },
    );
  }

  Future<void> getAllSubscribedChannels() async {
    try {
      final channelsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('subscribed_channels')
          .get();

      subscribedChannels = channelsSnapshot.docs
          .map((doc) => ChannelModel.fromMap(doc.data()))
          .toList();

      for (var channel in subscribedChannels) {
        await FirebaseMessaging.instance.subscribeToTopic(channel.name);
      }

      update(['channels']);
    } catch (e) {
      print('Error fetching subscribed channels: $e');
    }
  }

  isSubscribed(ChannelModel channel) {
    return subscribedChannels.map((item) => item.id).contains(channel.id);
  }

  submitForm() async {
    if (channelFormKey.currentState!.validate()) {
      final newChannel = ChannelModel(
        name: channelNameController.text,
        description: channelDescriptionController.text,
      );

      Get.back();

      await addChannel(newChannel);

      resetNewChannelForm();
    }
  }

  resetNewChannelForm() {
    channelNameController.clear();
    channelDescriptionController.clear();
  }

  addChannel(ChannelModel channel) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channel.id)
        .set(channel.toMap());
  }

  removeChannel(ChannelModel channel) async {
    await FirebaseFirestore.instance
        .collection('channels')
        .doc(channel.id)
        .delete();

    await Get.find<ChatsController>().removeChatRoom(channel);
  }

  toggleSubscription(ChannelModel channel, index) async {
    // update subscribed channels
    if (isSubscribed(channel)) {
      await removeChannelSubscription(channel);
      showSnackbar('Subscription removed',
          'You have unsubscribed from ${channel.name} successfully!');
    } else {
      await addChannelSubscription(channel);
      showSnackbar('Subscription added',
          'You have subscribed to ${channel.name} successfully!');
    }

    update(['$index']);
  }

  addChannelSubscription(ChannelModel channel) async {
    var subscribedChannelsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('subscribed_channels');

    subscribedChannels.add(channel);
    await subscribedChannelsRef.doc(channel.id).set(channel.toMap());
    await FirebaseMessaging.instance.subscribeToTopic(channel.name);
  }

  removeChannelSubscription(ChannelModel channel) async {
    var subscribedChannelsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('subscribed_channels');
    subscribedChannels.remove(channel);
    await subscribedChannelsRef.doc(channel.id).delete();
    await FirebaseMessaging.instance.unsubscribeFromTopic(channel.name);
  }

  showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.turquoise,
      colorText: AppColors.white,
      isDismissible: true,
      duration: const Duration(seconds: 2),
    );
  }
}
