import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/features/chat/data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 12.w,
      ),
      child: Column(
        crossAxisAlignment: message.isSentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!message.isSentByMe) _buildChatAvatar(),
              Text(
                message.isSentByMe
                    ? 'You'
                    : "User.${message.senderID.substring(0, 4)}", // random username for now
                style: AppTextStyles.font14BlackKanit,
              ),
              if (message.isSentByMe) _buildChatAvatar(),
            ],
          ),
          verticalSpace(4),
          Bubble(
            margin: BubbleEdges.only(
              bottom: 12.h,
              left: message.isSentByMe ? 0 : 22.w,
              right: message.isSentByMe ? 22.w : 0,
            ),
            nip: message.isSentByMe ? BubbleNip.rightTop : BubbleNip.leftTop,
            color: message.isSentByMe ? AppColors.purple : AppColors.blue,
            nipRadius: 2.r,
            nipWidth: 9.w,
            nipHeight: 8.h,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 110.w,
                maxWidth: 110.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.messageText,
                    style: AppTextStyles.font16WhiteKanit,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(message.sentTime),
                        style: AppTextStyles.font8WhiteKanit,
                        textAlign: TextAlign.end,
                      ),
                      horizontalSpace(4),
                      if (message.isSentByMe)
                        Icon(
                          Icons.done_all,
                          size: 11.w,
                          color: AppColors.white,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildChatAvatar() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: message.isSentByMe ? 8.w : 0,
        end: message.isSentByMe ? 0 : 8.w,
      ),
      child: CircleAvatar(
        radius: 12.w,
        backgroundColor: AppColors.grey,
        child: Icon(
          Icons.person,
          size: 16.w,
          color: AppColors.white,
        ),
      ),
    );
  }
}
