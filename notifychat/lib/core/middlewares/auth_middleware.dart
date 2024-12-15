import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notifychat/core/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

    // If user is authenticated, redirect to home page
    if (isAuthenticated) {
      return const RouteSettings(name: AppRoutes.home);
    }

    return null;
  }
}
