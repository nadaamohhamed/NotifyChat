import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';

class BottomNavBar extends GetView<HomeController> {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      color: AppColors.purple,
      backgroundColor: AppColors.white,
      key: controller.bottomNavigationKey,
      items: const <Widget>[
        Icon(
          Icons.notifications,
          color: AppColors.white,
        ),
        Icon(
          Icons.list,
          color: AppColors.white,
        ),
        Icon(
          Icons.chat,
          color: AppColors.white,
        ),
      ],
      onTap: (index) {
        controller.changePage(index);
      },
    );
  }
}
