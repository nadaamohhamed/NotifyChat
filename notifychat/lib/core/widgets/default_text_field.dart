import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifychat/core/helpers/validation_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final int? maxLength;
  final Color? color;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType keyboardType;

  const DefaultTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.maxLength,
    this.color,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      cursorColor: borderColor ?? AppColors.blue,
      controller: textController,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: color ?? AppColors.white,
        filled: true,
        counterStyle: AppTextStyles.font8BlackKanit,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.blue,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.blue,
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
        return ValidationHelper.isEmpty(value, hintText);
      },
    );
  }
}
