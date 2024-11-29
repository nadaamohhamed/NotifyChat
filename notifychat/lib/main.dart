import 'package:notifychat/core/helpers/getx_cache_helper.dart';
import 'package:notifychat/features/notifications/logic/notification_firebase_api.dart';
import 'package:notifychat/features/home/logic/home_bindings.dart';
import 'package:notifychat/features/home/presentation/views/home_view.dart';
import 'package:notifychat/firebase_options.dart';
import 'package:notifychat/core/routes/app_pages.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  await GetXCacheHelper.init();

  WidgetsFlutterBinding.ensureInitialized();

  // initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationFirebaseApi.initNotifications();

  // run the app
  runApp(const NotifyChat());
}

class NotifyChat extends StatelessWidget {
  const NotifyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NotifyChat',
          initialBinding: HomeBindings(),
          home: const HomeView(),
          getPages: AppPages.routes,
        );
      },
    );
  }
}
