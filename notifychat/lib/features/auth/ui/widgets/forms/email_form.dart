import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/constants/app_assets.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/default_button.dart';
import 'package:notifychat/core/widgets/default_text_field.dart';
import 'package:notifychat/features/auth/logic/auth_controller.dart';

class EmailForm extends GetView<AuthController> {
  const EmailForm({
    super.key,
    required this.isLogin,
  });

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: controller.emailFormKey,
          child: Column(
            children: [
              DefaultTextField(
                color: AppColors.white,
                borderColor: AppColors.purple,
                textController: controller.emailController,
                hintText: 'Email',
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.blue,
                ),
              ),
              verticalSpace(24),
              Obx(
                () => DefaultTextField(
                  color: AppColors.white,
                  borderColor: AppColors.purple,
                  textController: controller.passwordController,
                  hintText: 'Password',
                  obscureText: controller.isObscurePassword.value,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.blue,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      controller.togglePasswordVisibility();
                    },
                    child: Icon(
                      controller.isObscurePassword.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
              verticalSpace(40),
              DefaultButton(
                buttonColor: AppColors.blue,
                text: isLogin ? 'Login' : 'Sign Up',
                onPressed: () async {
                  await controller.submitEmailForm(isLogin);
                },
              ),
              verticalSpace(14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLine(),
                  horizontalSpace(4),
                  Text(
                    'OR',
                    style: AppTextStyles.font10WhiteKanit,
                  ),
                  horizontalSpace(4),
                  _buildLine()
                ],
              ),
              verticalSpace(14),
              DefaultButton(
                buttonColor: AppColors.blue,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.google,
                      height: 20.h,
                      width: 20.w,
                    ),
                    horizontalSpace(8),
                    Text(
                      'Continue with Google',
                      style: AppTextStyles.font14WhiteKanit,
                    ),
                  ],
                ),
                onPressed: () async {
                  await controller.submitGoogleGmail(isLogin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildLine() {
    return Container(
      height: 1.h,
      width: 120.w,
      color: AppColors.grey,
    );
  }
}
