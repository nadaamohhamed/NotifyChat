import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final int maxLength;

  const DefaultTextField({
    super.key,
    required this.textController,
    required this.hintText,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      cursorColor: AppColors.blue,
      controller: textController,
      decoration: InputDecoration(
        counterStyle: AppTextStyles.font10BlackKanit,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: AppColors.blue,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: AppColors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: AppColors.blue,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(
            color: AppColors.red,
          ),
        ),
        hintStyle: AppTextStyles.font14BlackKanit,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $hintText';
        }
        return null;
      },
    );
  }
}
