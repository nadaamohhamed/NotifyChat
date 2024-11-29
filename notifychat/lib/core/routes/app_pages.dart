import 'package:get/get.dart';
import 'package:notifychat/core/routes/app_routes.dart';
import 'package:notifychat/features/chat/presentation/views/chat_room_view.dart';

abstract class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.chatRoom,
      page: () => const ChatRoomView(),
    ),
  ];
}
