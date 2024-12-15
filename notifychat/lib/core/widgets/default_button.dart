import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';

class DefaultButton extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final double? width;
  final double? height;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final Color? buttonColor;
  final Function()? onPressed;
  final Widget? child;

  const DefaultButton({
    super.key,
    this.text,
    this.style,
    this.width,
    this.height,
    this.radius,
    this.padding,
    this.buttonColor,
    this.onPressed,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 16.r),
      ),
      minWidth: width ?? 280.w,
      height: height ?? 47.h,
      color: buttonColor ?? AppColors.blue,
      onPressed: onPressed,
      disabledColor: AppColors.grey,
      padding: padding ?? const EdgeInsets.all(0),
      child: text != null
          ? Text(
              text!,
              style: style ?? (AppTextStyles.font16WhiteKanit),
            )
          : child,
    );
  }
}
