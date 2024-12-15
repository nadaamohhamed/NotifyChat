import 'package:get/get.dart';

import 'package:notifychat/core/middlewares/auth_middleware.dart';
import 'package:notifychat/core/routes/app_routes.dart';
import 'package:notifychat/features/auth/logic/auth_bindings.dart';
import 'package:notifychat/features/auth/ui/views/login_view.dart';
import 'package:notifychat/features/auth/ui/views/signup_view.dart';
import 'package:notifychat/features/auth/ui/views/welcome_view.dart';
import 'package:notifychat/features/chat/presentation/views/chat_room_view.dart';
import 'package:notifychat/features/home/logic/home_bindings.dart';
import 'package:notifychat/features/home/presentation/views/home_view.dart';

abstract class AppPages {
  static const initial = AppRoutes.welcome;

  static final routes = [
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeView(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBindings(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: AppRoutes.chatRoom,
      page: () => const ChatRoomView(),
    ),
  ];
}
