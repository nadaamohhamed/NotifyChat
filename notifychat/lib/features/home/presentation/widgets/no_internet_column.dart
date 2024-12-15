import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';

class NoInternetColumn extends StatelessWidget {
  const NoInternetColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 80.sp,
          color: AppColors.red,
        ),
        verticalSpace(12),
        Text(
          'Failed to connect, please check your internet connection.',
          style: AppTextStyles.font16BlackKanit,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
