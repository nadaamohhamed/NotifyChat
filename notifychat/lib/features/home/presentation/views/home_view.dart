import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/widgets/cutsom_app_bar.dart';
import 'package:notifychat/core/widgets/default_progress_indicator.dart';
import 'package:notifychat/features/home/presentation/widgets/bottom_nav_bar.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';
import 'package:notifychat/features/home/presentation/widgets/no_internet_column.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      id: 'home',
      builder: (controller) {
        return StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: CustomAppBar(
                title: 'NotifyChat',
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      controller.logout();
                    },
                  ),
                ],
              ),
              body: _buildBody(snapshot, controller),
              bottomNavigationBar: const BottomNavBar(),
            );
          },
        );
      },
    );
  }

  _buildBody(snapshot, controller) {
    // failed to connect
    if (snapshot.connectionState == ConnectionState.active &&
        snapshot.data?.contains(ConnectivityResult.none)) {
      return const NoInternetColumn();
    }
    // waiting for connection
    if (snapshot.connectionState == ConnectionState.waiting &&
        snapshot.data == null) {
      return const DefaultProgressIndicator();
    }
    // connected
    return controller.navBarPages[controller.currentIndex];
  }
}
