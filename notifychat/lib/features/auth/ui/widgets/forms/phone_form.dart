import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/default_button.dart';
import 'package:notifychat/core/widgets/default_text_field.dart';
import 'package:notifychat/features/auth/logic/auth_controller.dart';

class PhoneForm extends StatelessWidget {
  const PhoneForm({
    super.key,
    required this.isLogin,
  });

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        id: 'otp',
        builder: (controller) {
          return SingleChildScrollView(
            child: Form(
              key: controller.phoneFormKey,
              child: Column(
                children: [
                  verticalSpace(40),
                  DefaultTextField(
                    maxLength: controller.phoneTextMaxLength,
                    color: AppColors.white,
                    borderColor: AppColors.purple,
                    textController: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: controller.isOTPSent ? 'OTP' : 'Phone Number',
                    prefixIcon: Icon(
                      controller.isOTPSent ? Icons.lock_clock : Icons.phone,
                      color: AppColors.blue,
                    ),
                  ),
                  verticalSpace(20),
                  if (controller.isOTPSent)
                    Text(
                      'Your OTP will expire in 1 minute once you receive it.',
                      style: AppTextStyles.font10WhiteKanit,
                    ),
                  verticalSpace(120),
                  DefaultButton(
                    buttonColor: AppColors.blue,
                    width: 200.w,
                    text: controller.isOTPSent ? 'Verify OTP' : 'Send OTP',
                    onPressed: () async {
                      await controller.submitPhoneForm(isLogin);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
