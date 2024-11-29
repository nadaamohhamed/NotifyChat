import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:notifychat/core/helpers/get_dialog_helper.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/default_progress_indicator.dart';
import 'package:notifychat/features/channels/logic/channel_controller.dart';
import 'package:notifychat/features/channels/presentation/widgets/add_channel_dialog.dart';
import 'package:notifychat/features/channels/presentation/widgets/channel_tile.dart';

class ChannelsView extends StatelessWidget {
  const ChannelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ChannelController>(
        id: 'channels',
        builder: (controller) {
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: 24.h,
            ),
            child: controller.isLoading
                ? const Center(
                    child: DefaultProgressIndicator(),
                  )
                : controller.allChannels.isEmpty
                    ? Column(
                        children: [
                          _buildTitleAndAddRow(context),
                          const Spacer(),
                          Text(
                            'No available channels right now to show.',
                            style: AppTextStyles.font18BlackKanit,
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleAndAddRow(context),
                            verticalSpace(18),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.allChannels.length,
                              itemBuilder: (context, index) {
                                return ChannelTile(
                                  index: index,
                                  channel: controller.allChannels[index],
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

  Row _buildTitleAndAddRow(context) {
    return Row(
      children: [
        Text(
          'Available Channels',
          style: AppTextStyles.font20BlackKanit,
        ),
        const Spacer(),
        CircleAvatar(
          radius: 16.r,
          backgroundColor: AppColors.turquoise,
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // open dialog to add channel
              GetDialogHelper.generalDialog(
                barrierDismissible: true,
                child: const AddChannelDialog(),
                context: context,
              );
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
