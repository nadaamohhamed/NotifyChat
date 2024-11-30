import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/features/chat/logic/chats_controller.dart';
import 'package:notifychat/features/chat/presentation/widgets/chats_tile.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChatsController>(
        id: 'chats',
        builder: (controller) {
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: 24.h,
            ),
            child: controller.subscribedChannels.isEmpty
                ? Center(
                    child: Text(
                      'You haven’t subscribed to any channels yet, so there\'re no available chat rooms now.',
                      style: AppTextStyles.font18BlackKanit,
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chat Rooms',
                          style: AppTextStyles.font20BlackKanit,
                        ),
                        verticalSpace(18),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.subscribedChannels.length,
                          itemBuilder: (context, index) {
                            return ChatsTile(
                              channel: controller.subscribedChannels[index],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
