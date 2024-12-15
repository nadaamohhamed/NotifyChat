import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/animations/scale_animation.dart';
import 'package:notifychat/core/animations/up_down_animation.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/routes/app_routes.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/default_button.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          UpDownAnimation(
            child: Align(
              alignment: AlignmentDirectional.topCenter,
              child: _buildWave(AppColors.turquoise, false, false),
            ),
          ),
          UpDownAnimation(
            reverse: true,
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: _buildWave(AppColors.purple, true, true),
            ),
          ),
          ScaleAnimation(
            duration: const Duration(seconds: 1),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: 16.w,
                vertical: 24.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to NotifyChat, we\'re glad to have you here!',
                    style: AppTextStyles.font20BlackKanit.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(24),
                  Text(
                    'Please signup or login to continue.',
                    style: AppTextStyles.font14BlackKanit,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpace(80),
                  DefaultButton(
                    text: 'Sign Up',
                    onPressed: () => {
                      Get.toNamed(AppRoutes.signup),
                    },
                  ),
                  verticalSpace(32),
                  DefaultButton(
                    text: 'Login',
                    onPressed: () => {
                      Get.toNamed(AppRoutes.login),
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildWave(color, reverse, flip) {
    return ClipPath(
      clipper: WaveClipperOne(
        reverse: reverse,
        flip: flip,
      ),
      child: Container(
        height: 100.h,
        color: color,
      ),
    );
  }
}
