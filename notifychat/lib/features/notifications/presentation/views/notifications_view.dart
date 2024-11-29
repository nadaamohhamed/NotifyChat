import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/default_progress_indicator.dart';
import 'package:notifychat/features/notifications/logic/notification_controller.dart';
import 'package:notifychat/features/notifications/presentation/widgets/notification_tile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      id: 'notifications',
      builder: (controller) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: 24.h,
            ),
            child: controller.isLoading
                ? const Center(
                    child: DefaultProgressIndicator(),
                  )
                : controller.notifications.isEmpty
                    ? Center(
                        child: Text(
                          'You have no notifications yet.',
                          style: AppTextStyles.font18BlackKanit,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'All Notifications',
                              style: AppTextStyles.font20BlackKanit,
                            ),
                            verticalSpace(18),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.notifications.length,
                              itemBuilder: (context, index) {
                                return NotificationTile(
                                  notification: controller.notifications[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}
