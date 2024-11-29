import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/features/notifications/data/models/notification_model.dart';
import 'package:notifychat/features/notifications/logic/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationTile extends GetView<NotificationController> {
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 12.h),
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        resizeDuration: const Duration(milliseconds: 200),
        onDismissed: (direction) {
          controller.deleteNotification(notification.id);
        },
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.r),
              bottomRight: Radius.circular(10.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(
                Icons.delete_forever,
                color: AppColors.white,
              ),
              horizontalSpace(8),
              Text(
                'Delete',
                style: AppTextStyles.font14WhiteKanit,
              ),
              horizontalSpace(16),
            ],
          ),
        ),
        child: ListTile(
          leading: Icon(
            Icons.notifications_active,
            color: AppColors.white,
            size: 32.sp,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          tileColor: AppColors.blue,
          title: Text(
            notification.title,
            style: AppTextStyles.font20WhiteKanit,
          ),
          subtitle: Text(
            notification.content,
            style: AppTextStyles.font14WhiteKanit,
          ),
        ),
      ),
    );
  }
}
