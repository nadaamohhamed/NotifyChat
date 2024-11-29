import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          Text(
            "User.${message.senderID.substring(0, 4)}", // random username for now
            style: AppTextStyles.font14BlackKanit,
          ),
          verticalSpace(4),
          Bubble(
            margin: BubbleEdges.only(bottom: 12.h),
            alignment: message.isSentByMe
                ? Alignment.centerRight
                : Alignment.centerLeft,
            nip: message.isSentByMe ? BubbleNip.rightTop : BubbleNip.leftTop,
            color: message.isSentByMe ? AppColors.purple : AppColors.blue,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 90.w),
              child: Text(
                message.messageText,
                style: AppTextStyles.font16WhiteKanit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
