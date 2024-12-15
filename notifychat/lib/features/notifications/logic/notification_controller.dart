import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notifychat/features/home/logic/home_controller.dart';
import 'package:notifychat/features/notifications/data/models/notification_model.dart';

class NotificationController extends GetxController {
  String userID = FirebaseAuth.instance.currentUser!.uid;

  List<NotificationModel> notifications = [];
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    getAllNotifications();
  }

  getAllNotifications() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('notifications')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      isLoading = true;
      notifications = event.docs
          .map(
            (e) => NotificationModel.fromMap(e.data()),
          )
          .toList();

      isLoading = false;
      update(['notifications']);
    }, onError: (error) {
      print('Error fetching notifications: $error');
    });
  }

  void saveNotification(NotificationModel notification) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('notifications')
          .doc(notification.id)
          .get();

      if (docSnapshot.exists) {
        // print('Notification with ID ${notification.id} already exists.');
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toMap());
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  void deleteNotification(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .collection('notifications')
          .doc(id)
          .delete();

      Get.find<HomeController>().showSnackbar('Notification deleted',
          'You have deleted the notification successfully!');
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }
}
