import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';

import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/cutsom_app_bar.dart';
import 'package:notifychat/features/chat/logic/chats_controller.dart';
import 'package:notifychat/features/chat/presentation/widgets/message_bubble.dart';

class ChatRoomView extends GetView<ChatsController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: controller.selectedChatRoom!.roomName),
      body: GetBuilder<ChatsController>(
          id: 'chatRoom',
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(12),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        controller.selectedChatRoom!.chatRoomMessages.length,
                    itemBuilder: (context, index) {
                      final message =
                          controller.selectedChatRoom!.chatRoomMessages[index];
                      return MessageBubble(message: message);
                    },
                  ),
                ),
                Divider(
                  height: 1.h,
                  color: AppColors.turquoise,
                ),
                Container(
                  color: AppColors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.h),
                          child: TextField(
                            controller: controller.newMessageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              border: InputBorder.none,
                              hintStyle: AppTextStyles.font16BlackKanit,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: AppColors.turquoise,
                        ),
                        onPressed: () async {
                          await controller.sendMessage();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
