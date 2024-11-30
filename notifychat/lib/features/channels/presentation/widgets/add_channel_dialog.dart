import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:notifychat/core/helpers/spacing_helper.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/core/theme/app_text_styles.dart';
import 'package:notifychat/core/widgets/default_text_field.dart';
import 'package:notifychat/features/channels/logic/channel_controller.dart';

class AddChannelDialog extends GetView<ChannelController> {
  const AddChannelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.resetNewChannelForm();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        width: 320.w,
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 24.w,
            vertical: 16.h,
          ),
          child: Form(
            key: controller.channelFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Channel',
                  style: AppTextStyles.font18BlackKanit,
                  textAlign: TextAlign.center,
                ),
                verticalSpace(20),
                DefaultTextField(
                  textController: controller.channelNameController,
                  hintText: 'Channel Name',
                  maxLength: 20,
                ),
                verticalSpace(16),
                DefaultTextField(
                  textController: controller.channelDescriptionController,
                  hintText: 'Channel Description',
                  maxLength: 50,
                ),
                verticalSpace(24),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ElevatedButton(
                    onPressed: controller.submitForm,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        AppColors.turquoise,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: AppTextStyles.font14WhiteKanit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
