import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/features/channels/data/models/channel_model.dart';
import 'package:notifychat/features/channels/logic/channel_controller.dart';

class ChannelTile extends GetView<ChannelController> {
  final int index;
  final ChannelModel channel;

  const ChannelTile({
    super.key,
    required this.channel,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChannelController>(
      id: '$index',
      builder: (controller) {
        return Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12.h),
            child: Dismissible(
              key: Key(channel.id),
              direction: DismissDirection.endToStart,
              resizeDuration: const Duration(milliseconds: 200),
              onDismissed: (direction) async {
                await controller.removeChannel(channel);
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
                subtitle: Text(
                  channel.description,
                  style: AppTextStyles.font14WhiteKanit,
                ),
                trailing: GestureDetector(
                  child: Column(
                    children: [
                      Icon(
                        controller.isSubscribed(channel)
                            ? Icons.check
                            : Icons.add,
                        color: AppColors.white,
                      ),
                      verticalSpace(4),
                      Text(
                        controller.isSubscribed(channel)
                            ? 'Unsubscribe'
                            : 'Subscribe',
                        style: AppTextStyles.font14WhiteKanit,
                      ),
                    ],
                  ),
                  onTap: () {
                    controller.toggleSubscription(channel, index);
                  },
                ),
              ),
            ));
      },
    );
  }
}
