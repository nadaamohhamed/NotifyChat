import 'package:flutter/material.dart';
import 'package:notifychat/core/theme/app_colors.dart';

abstract class GetDialogHelper {
  static Future generalDialog({
    required Widget child,
    required BuildContext context,
    bool? barrierDismissible,
  }) {
    return showGeneralDialog(
      barrierLabel: "",
      barrierDismissible: barrierDismissible ?? false,
      context: context,
      transitionDuration: const Duration(
        milliseconds: 400,
      ),
      pageBuilder: (_, __, ___) {
        return Dialog(
          clipBehavior: Clip.none,
          insetPadding: EdgeInsets.zero,
          backgroundColor: AppColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }
}
