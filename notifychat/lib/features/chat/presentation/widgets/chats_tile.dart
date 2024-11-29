import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/routes/app_routes.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/features/channels/data/models/channel_model.dart';
import 'package:notifychat/features/chat/logic/chats_controller.dart';

class ChatsTile extends StatelessWidget {
  final ChannelModel channel;

  const ChatsTile({
    super.key,
    required this.channel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 12.h),
      child: ListTile(
        contentPadding: EdgeInsetsDirectional.symmetric(
          vertical: 8.h,
          horizontal: 12.w,
        ),
        tileColor: AppColors.blue,
        title: Text(
          channel.name,
          style: AppTextStyles.font20WhiteKanit,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        trailing: InkWell(
          splashColor: AppColors.semiTransparent,
          borderRadius: BorderRadius.circular(5.r),
          child: Column(
            children: [
              const Icon(
                Icons.door_back_door_rounded,
                color: AppColors.white,
              ),
              verticalSpace(4),
              Text(
                'Enter',
                style: AppTextStyles.font14WhiteKanit,
              ),
            ],
          ),
          onTap: () async {
            await Get.find<ChatsController>().setSelectedChatRoom(channel);

            Get.find<ChatsController>().selectedChatRoom == null
                ? print('Chat room not selected')
                : print('Chat room selected');

            // navigate to chat room with this channel
            Get.toNamed(AppRoutes.chatRoom);
          },
        ),
      ),
    );
  }
}
