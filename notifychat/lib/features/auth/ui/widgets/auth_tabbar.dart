import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/features/auth/logic/auth_controller.dart';

class AuthTabbar extends GetView<AuthController> {
  const AuthTabbar({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: EdgeInsetsDirectional.only(start: 16.w),
      labelPadding: EdgeInsetsDirectional.only(end: 25.w),
      isScrollable: true,
      splashFactory: NoSplash.splashFactory,
      indicatorColor: AppColors.turquoise,
      tabAlignment: TabAlignment.start,
      labelStyle: AppTextStyles.font20WhiteKanit,
      unselectedLabelStyle: AppTextStyles.font14WhiteKanit,
      dividerColor: Colors.transparent,
      controller: controller.tabController,
      tabs: controller.tabs.map(
        (text) {
          return Tab(text: text);
        },
      ).toList(),
    );
  }
}
