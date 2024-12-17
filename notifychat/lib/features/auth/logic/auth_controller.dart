import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:notifychat/core/helpers/validation_helper.dart';
import 'package:notifychat/core/routes/app_routes.dart';
import 'package:notifychat/core/theme/app_colors.dart';
import 'package:notifychat/features/auth/data/models/user_model.dart';

class AuthController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // attributes for tab bar
  final tabs = ['Email', 'Phone'];
  late final TabController tabController;

  // attributes for email form
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  RxBool isObscurePassword = true.obs;

  // attributes for phone form
  TextEditingController phoneController = TextEditingController();
  GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  bool isOTPSent = false;
  String otpCode = '';
  int phoneTextMaxLength = 11;

  // firebase auth instance and analytics
  final auth = FirebaseAuth.instance;
  final analytics = FirebaseAnalytics.instance;

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  // ----------------------- Analytics Methods -----------------
  isFirstLogin() {
    return auth.currentUser!.metadata.creationTime ==
        auth.currentUser!.metadata.lastSignInTime;
  }

  logFirstLogin(loginMethod) async {
    print('First login: ${isFirstLogin()}');
    if (isFirstLogin()) {
      await analytics.logEvent(
        name: 'first_time_login',
        parameters: {
          'login_method': loginMethod,
        },
      );
      print('Logged first time login done');
    }
  }

  // ----------------------------------------------------------

  resetEmailControllers() {
    emailController.clear();
    passwordController.clear();
  }

  resetPhoneControllers() {
    phoneController.clear();
    setOtpSent(false);
    phoneTextMaxLength = 11;
  }

  resetData() {
    resetEmailControllers();
    resetPhoneControllers();
  }

  void togglePasswordVisibility() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  loginWithEmail() async {
    if (emailFormKey.currentState!.validate()) {
      try {
        // sign in user
        await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await Get.offAllNamed(AppRoutes.home);

        resetEmailControllers();
      } on FirebaseAuthException catch (e) {
        handleLoginEmailExceptions(e);
      } catch (e) {
        print('Error logging in: $e');
        showSnackbar(
          'Error',
          'Something went wrong. Please try again later.',
          AppColors.red,
        );
      }
    }
  }

  signupWithEmail() async {
    if (emailFormKey.currentState!.validate() &&
        ValidationHelper.hasMinXCharacters(passwordController.text, 8) &&
        ValidationHelper.validateEmail(emailController.text)) {
      try {
        final credentials = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        UserModel user = UserModel(
          id: credentials.user!.uid,
          email: emailController.text,
        );

        // save user to database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toMap());

        await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await Get.offAllNamed(AppRoutes.home);

        resetEmailControllers();
        await logFirstLogin('email');
      } // handle exceptions
      on FirebaseAuthException catch (e) {
        handleSignupEmailExceptions(e);
      } catch (e) {
        showSnackbar(
          'Error',
          'Something went wrong. Please try again later.',
          AppColors.red,
        );
        print('Error signing up: $e');
      }
    } else {
      showSnackbar(
          'Invalid',
          'Please enter a valid email and password with at least 8 characters .',
          AppColors.red);
    }
  }

  submitEmailForm(bool isLogin) async {
    if (isLogin) {
      await loginWithEmail();
    } else {
      await signupWithEmail();
    }
  }

  void setOtpSent(value) {
    isOTPSent = value;
    update(['otp']);
  }

  verifyOTP(isLogin) async {
    // verify phone number with OTP
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: otpCode,
      smsCode: phoneController.text,
    );

    try {
      final result = await auth.signInWithCredential(phoneAuthCredential);
      final wasRegistered = await isRegisteredBefore(result.user!.uid);

      if (!wasRegistered && isLogin) {
        await deleteUser();
        showSnackbar('Login Failed', 'Phone number isn\'t registred before',
            AppColors.red);
        return;
      } else if (wasRegistered && !isLogin) {
        showSnackbar('Sign Up Failed',
            'Phone number is already registered, try login.', AppColors.red);
        resetPhoneControllers();
        return;
      }
      // will proceed to home screen only if user wasn't registered before + not login or user was registered before + login

      if (!wasRegistered) {
        UserModel user = UserModel(
          id: result.user!.uid,
          phoneNumber: result.user!.phoneNumber,
        );

        // save user to database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toMap());
      }
      await Get.offAllNamed(AppRoutes.home);
      await logFirstLogin('phone');

      resetPhoneControllers();
    } // handle exceptions
    on FirebaseAuthException catch (e) {
      handlePhoneOTPExceptions(e);
      print('FirebaseAuthException: $e');
    } catch (e) {
      showSnackbar(
        'Error',
        'Something went wrong. Please try again later.',
        AppColors.red,
      );
      print('Error verifying OTP: $e');
    }
  }

  sendOTP() async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "+2${phoneController.text}",
        verificationCompleted: (phoneAuthCredential) async {
          print('OTP verification completed');
        },
        verificationFailed: (error) {
          print('Error verifying phone number: $error');
          setOtpSent(false);
        },
        codeSent: (verificationId, resendToken) {
          otpCode = verificationId;

          // reset phone controller and set max length to 6 for otp
          phoneController.clear();
          phoneTextMaxLength = 6;
          setOtpSent(true);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          // called when the auto-retrieval times out
          setOtpSent(false);
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      showSnackbar(
        'Error',
        'Something went wrong. Please try again later.',
        AppColors.red,
      );
      print('Error sending OTP: $e');
    }
  }

  submitPhoneForm(bool isLogin) async {
    if (phoneFormKey.currentState!.validate()) {
      if (isOTPSent) {
        await verifyOTP(isLogin);
      } else {
        if (ValidationHelper.validatePhoneNumber(phoneController.text)) {
          await sendOTP();
        } else {
          showSnackbar(
              'Invalid', 'Please enter a valid phone number.', AppColors.red);
        }
      }
    }
  }

  submitGoogleGmail(bool isLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result = await auth.signInWithCredential(credential);
      final wasRegistered = await isRegisteredBefore(result.user!.uid);

      if (!wasRegistered && isLogin) {
        await deleteUser();
        showSnackbar(
          'Login Failed',
          'Google account isn\'t registred before.',
          AppColors.red,
        );
        return;
      } else if (wasRegistered && !isLogin) {
        showSnackbar(
          'Sign Up Failed',
          'Google account is already registred, try login.',
          AppColors.red,
        );
        resetEmailControllers();
        return;
      }
      // will proceed to home screen only if user wasn't registered before + not login or user was registered before + login

      if (!wasRegistered) {
        UserModel user = UserModel(
          id: result.user!.uid,
          email: result.user!.email,
        );
        // save user to database
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toMap());
      }
      await Get.offAllNamed(AppRoutes.home);
      await logFirstLogin('google');
    } // handle exceptions
    on FirebaseAuthException catch (e) {
      handleGoogleExceptions(e);
      print('FirebaseAuthException: $e');
    } catch (e) {
      showSnackbar(
        'Error',
        'Something went wrong. Please try again later.',
        AppColors.red,
      );
      print('Error signing in with Google: $e');
    }
  }

  deleteUser() async {
    await auth.currentUser!.delete();
    await auth.signOut();
  }

  isRegisteredBefore(String id) async {
    try {
      final user =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      return user.exists;
    } catch (e) {
      print('Error checking if user is registered before: $e');
      return false;
    }
  }

  logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // ----------------------- Exception handling -----------------

  void handleSignupEmailExceptions(FirebaseAuthException e) {
    if (e.code == 'email-already-in-use') {
      showSnackbar(
        'Sign Up Failed',
        'The email is already registered. Please try logging in.',
        AppColors.red,
      );
    } else if (e.code == 'network-request-failed') {
      showSnackbar(
        'Network Error',
        'Network error. Please check your connection.',
        AppColors.red,
      );
    } else {
      showSnackbar(
        'Sign Up Failed',
        e.message ?? 'An error occurred while signing up.',
        AppColors.red,
      );
    }
    print('FirebaseAuthException: $e');
  }

  void handleLoginEmailExceptions(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      showSnackbar(
        'Login Failed',
        'No user found with this email. Please check and try again.',
        AppColors.red,
      );
    } else if (e.code == 'wrong-password') {
      showSnackbar(
        'Login Failed',
        'The password is incorrect. Please try again.',
        AppColors.red,
      );
    } else if (e.code == 'invalid-email') {
      showSnackbar(
        'Login Failed',
        'The email address is invalid. Please check and try again.',
        AppColors.red,
      );
    } else if (e.code == 'too-many-requests') {
      showSnackbar(
        'Login Failed',
        'Too many failed login attempts. Please try again later.',
        AppColors.red,
      );
    } else if (e.code == 'network-request-failed') {
      showSnackbar(
        'Error',
        'Network error. Please check your connection.',
        AppColors.red,
      );
    } else {
      showSnackbar(
        'Error',
        e.message ?? 'An error occurred. Please try again later.',
        AppColors.red,
      );
    }
  }

  void handlePhoneOTPExceptions(FirebaseAuthException e) {
    if (e.code == 'invalid-verification-code') {
      showSnackbar(
        'Error',
        'The OTP entered is invalid. Please try again.',
        AppColors.red,
      );
    } else if (e.code == 'network-request-failed') {
      showSnackbar(
        'Error',
        'Network error. Please check your connection.',
        AppColors.red,
      );
    } else {
      showSnackbar(
        'Error',
        e.message ?? 'An error occurred. Please try again.',
        AppColors.red,
      );
    }
  }

  void handleGoogleExceptions(FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      showSnackbar(
        'Error',
        'This Google account is linked with a different sign-in method. Please try another way.',
        AppColors.red,
      );
    } else if (e.code == 'invalid-credential') {
      showSnackbar(
        'Error',
        'The credential is invalid or expired. Please try again.',
        AppColors.red,
      );
    } else if (e.code == 'network-request-failed') {
      showSnackbar('Error', 'Network error. Please check your connection.',
          AppColors.red);
    } else {
      showSnackbar(
        'Error',
        e.message ?? 'An error occurred during Google sign-in.',
        AppColors.red,
      );
    }
  }

  // --------------------------------------------------------------
  showSnackbar(String title, String message, Color color) async {
    await Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      colorText: AppColors.white,
      isDismissible: true,
      duration: const Duration(seconds: 2),
    );
  }
}
