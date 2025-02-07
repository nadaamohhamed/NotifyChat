import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:notifychat/features/channels/data/models/channel_model.dart';
import 'package:notifychat/features/chat/logic/chats_controller.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';

class ChannelController extends GetxController {
  List<ChannelModel> allChannels = [];
  String userID = Get.find<HomeController>().userID;

  // list of all subscribed channels
  List<ChannelModel> subscribedChannels = [];

  // new channel attributes
  TextEditingController channelNameController = TextEditingController();
  TextEditingController channelDescriptionController = TextEditingController();
  GlobalKey<FormState> channelFormKey = GlobalKey<FormState>();

  bool isLoading = true;

  final analytics = FirebaseAnalytics.instance;

  @override
  void onInit() {
    super.onInit();

    getAllChannels();
    getAllSubscribedChannels();
  }

  //  ------------------------- Analytics Methods -----------------------------

  logUserSubscription(
    action,
    channelName,
  ) async {
    await analytics.logEvent(
      name:
          action == 'subscribe' ? 'channel_subscribed' : 'channel_unsubscribed',
      parameters: {
        'channel_name': channelName,
        'action': action,
      },
    );
  }

  // custom event to log when channel created
  logChannelCreated(channelName) async {
    await analytics.logEvent(
      name: 'channel_created',
      parameters: {
        'channel_name': channelName,
      },
    );
  }

  // ---------------------------------------------------------------------------

  getAllChannels() {
    FirebaseFirestore.instance.collection('channels').snapshots().listen(
      (event) {
        isLoading = true;
        allChannels = event.docs
            .map(
              (doc) => ChannelModel.fromMap(doc.data()),
            )
            .toList();
        allChannels.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        isLoading = false;
        update(['channels']);

        // also update subscribed channels if any channel is deleted
        for (var channel in subscribedChannels) {
          if (!allChannels.map((item) => item.id).contains(channel.id)) {
            int index =
                allChannels.indexWhere((element) => element.id == channel.id);
            removeChannelSubscription(channel, index);
          }
        }
      },
      onError: (error) {
        print('Error fetching channels: $error');
      },
    );
  }

  getAllSubscribedChannels() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('subscribed_channels')
        .snapshots()
        .listen(
      (event) async {
        subscribedChannels = event.docs
            .map(
              (doc) => ChannelModel.fromMap(doc.data()),
            )
            .toList();

        Get.find<ChatsController>().setSubscribedChannels(subscribedChannels);
      },
      onError: (error) {
        print('Error fetching subscribed channels: $error');
      },
    );
  }

  isSubscribed(ChannelModel channel) {
    return subscribedChannels.map((item) => item.id).contains(channel.id);
  }

  isAdminOfChannel(ChannelModel channel) {
    return channel.adminId == userID;
  }

  submitForm() async {
    if (channelFormKey.currentState!.validate()) {
      final newChannel = ChannelModel(
        name: channelNameController.text,
        description: channelDescriptionController.text,
        createdAt: DateTime.now(),
        adminId: userID,
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
    try {
      await FirebaseFirestore.instance
          .collection('channels')
          .doc(channel.id)
          .set(channel.toMap());
      Get.find<HomeController>().showSnackbar('Channel added',
          'You have added ${channel.name} channel successfully!');
      await logChannelCreated(channel.name);
    } catch (e) {
      print('Error adding channel: $e');
    }
  }

  removeChannel(ChannelModel channel) async {
    try {
      await FirebaseFirestore.instance
          .collection('channels')
          .doc(channel.id)
          .delete();

      await Get.find<ChatsController>().removeChatRoom(channel);
      Get.find<HomeController>().showSnackbar('Channel removed',
          'You have removed ${channel.name} channel successfully!');
    } catch (e) {
      print('Error removing channel: $e');
    }
  }

  toggleSubscription(ChannelModel channel, int index) async {
    // update subscribed channels
    if (isSubscribed(channel)) {
      await removeChannelSubscription(channel, index);
      Get.find<HomeController>().showSnackbar('Subscription removed',
          'You have unsubscribed from ${channel.name} successfully!');
    } else {
      await addChannelSubscription(channel, index);
      Get.find<HomeController>().showSnackbar('Subscription added',
          'You have subscribed to ${channel.name} successfully!');
    }
  }

  addChannelSubscription(ChannelModel channel, int index) async {
    try {
      var subscribedChannelsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('subscribed_channels');

      subscribedChannels.add(channel);

      update(['$index']);

      await subscribedChannelsRef.doc(channel.id).set(channel.toMap());
      await FirebaseMessaging.instance.subscribeToTopic(channel.name);
      await logUserSubscription('subscribe', channel.name);
    } catch (e) {
      print('Error adding channel subscription: $e');
    }
  }

  removeChannelSubscription(ChannelModel channel, int index) async {
    try {
      var subscribedChannelsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('subscribed_channels');

      subscribedChannels.removeWhere((item) => item.id == channel.id);
      update(['$index']);

      await subscribedChannelsRef.doc(channel.id).delete();
      await FirebaseMessaging.instance.unsubscribeFromTopic(channel.name);
      await logUserSubscription('unsubscribe', channel.name);
    } catch (e) {
      print('Error removing channel subscription: $e');
    }
  }
}
