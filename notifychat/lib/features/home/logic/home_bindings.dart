import 'package:get/get.dart';
import 'package:notifychat/features/channels/logic/channel_controller.dart';
import 'package:notifychat/features/chat/logic/chats_controller.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';
import 'package:notifychat/features/notifications/logic/notification_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => ChannelController(), fenix: true);
    Get.lazyPut(() => ChatsController(), fenix: true);
  }
}
