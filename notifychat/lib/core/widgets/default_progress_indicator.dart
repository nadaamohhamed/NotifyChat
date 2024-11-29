import 'package:flutter/material.dart';
import 'package:notifychat/core/theme/app_colors.dart';

class DefaultProgressIndicator extends StatelessWidget {
  const DefaultProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.blue,
      ),
    );
  }
}
