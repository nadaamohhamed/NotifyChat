import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/animations/up_down_animation.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/features/auth/logic/auth_controller.dart';
import 'package:notifychat/features/auth/ui/widgets/forms/email_form.dart';
import 'package:notifychat/features/auth/ui/widgets/auth_tabbar.dart';
import 'package:notifychat/features/auth/ui/widgets/forms/phone_form.dart';

class AuthCard extends GetView<AuthController> {
  final bool isLogin;

  const AuthCard({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: UpDownAnimation(
        reverse: true,
        child: Container(
          padding: EdgeInsetsDirectional.only(
            start: 24.w,
            end: 24.w,
            top: 24.h,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.purple,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.r),
              topRight: Radius.circular(40.r),
            ),
          ),
          child: Column(
            children: [
              const AuthTabbar(),
              verticalSpace(8),
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    EmailForm(isLogin: isLogin),
                    PhoneForm(isLogin: isLogin),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
