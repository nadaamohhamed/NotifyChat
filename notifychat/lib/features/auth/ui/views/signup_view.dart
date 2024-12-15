import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';

import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/cutsom_app_bar.dart';
import 'package:notifychat/features/auth/logic/auth_controller.dart';
import 'package:notifychat/features/auth/ui/widgets/auth_card.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.resetData();
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: 'NotifyChat'),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            verticalSpace(60),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Text(
                    'Sign Up',
                    style: AppTextStyles.font24BlackW700Kanit,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(12),
                  Text(
                    'Create an account and join our community now!',
                    style: AppTextStyles.font20BlackKanit,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            verticalSpace(30),
            const AuthCard(isLogin: false),
          ],
        ),
      ),
    );
  }
}
