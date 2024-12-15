import 'package:get/get.dart';
import 'package:notifychat/features/auth/logic/auth_controller.dart';

class AuthBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
