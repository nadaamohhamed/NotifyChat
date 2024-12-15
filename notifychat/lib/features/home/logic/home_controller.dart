import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/routes/app_routes.dart';

import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/features/auth/data/models/user_model.dart';
import 'package:notifychat/features/channels/presentation/views/channels_view.dart';
import 'package:notifychat/features/chat/presentation/views/chats_view.dart';
import 'package:notifychat/features/notifications/presentation/views/notifications_view.dart';

class HomeController extends GetxController {
  int currentIndex = 0;
  final GlobalKey<CurvedNavigationBarState> bottomNavigationKey = GlobalKey();

  final List<Widget> navBarPages = [
    const NotificationsView(),
    const ChannelsView(),
    const ChatsView(),
  ];

  String userID = FirebaseAuth.instance.currentUser!.uid;

  late UserModel loggedInUser;

  @override
  void onInit() async {
    super.onInit();
    await getLoggedInUser();
  }

  getLoggedInUser() async {
    try {
      final credentials = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(credentials!.uid)
          .get();

      if (userData.exists) {
        UserModel user = UserModel.fromMap(userData.data()!);
        loggedInUser = user;
      }
    } catch (e) {
      throw Exception('Error getting logged in user: $e');
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(AppRoutes.welcome);
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  void changePage(int index) {
    currentIndex = index;
    update(['home']);
  }

  showSnackbar(String title, String message) async {
    await Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.purple,
      colorText: AppColors.white,
      isDismissible: true,
      duration: const Duration(seconds: 2),
    );
  }
}
