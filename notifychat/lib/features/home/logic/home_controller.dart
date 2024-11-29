import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/helpers/getx_cache_helper.dart';
import 'package:notifychat/features/channels/presentation/views/channels_view.dart';
import 'package:notifychat/features/chat/presentation/views/chats_view.dart';
import 'package:notifychat/features/notifications/presentation/views/notifications_view.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  int currentIndex = 0;
  final GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  final List<Widget> navBarPages = [
    const NotificationsView(),
    const ChannelsView(),
    const ChatsView(),
  ];

  String? userID;

  @override
  void onInit() async {
    super.onInit();
    await getUserID();
  }

  getUserID() async {
    userID = GetXCacheHelper.getData(key: 'user_id');
    if (userID == null) {
      // generate a new id
      userID = const Uuid().v4();
      await GetXCacheHelper.saveData(key: 'user_id', value: userID);
    }
  }

  void changePage(int index) {
    currentIndex = index;
    update(['home']);
  }
}
