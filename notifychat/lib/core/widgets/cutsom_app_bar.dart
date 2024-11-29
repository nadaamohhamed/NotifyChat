import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => Size.fromHeight(55.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.turquoise,
      foregroundColor: AppColors.white,
      centerTitle: true,
      title: Text(
        title,
        style: AppTextStyles.font24WhiteKanit,
      ),
    );
  }
}
