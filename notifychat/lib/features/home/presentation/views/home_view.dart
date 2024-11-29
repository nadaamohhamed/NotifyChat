import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/widgets/cutsom_app_bar.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';
import 'package:notifychat/features/home/presentation/widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'home',
      builder: (controller) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'NotifyChat'),
          body: controller.navBarPages[controller.currentIndex],
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }
}
