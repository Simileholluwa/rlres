import 'dart:async';
import 'package:atles/splash_screen/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../common/routes/names.dart';

class AuthController extends GetxController {
  AuthController();

  final state = SplashState();

  @override
  void onReady() {
    initAuth();
    super.onReady();
  }

  void initAuth() async {
    await Future.delayed(const Duration(seconds: 5));
    state.auth = FirebaseAuth.instance;
    state.authStateChanges = state.auth.authStateChanges();
    state.authStateChanges.listen((User? user) {
      state.user.value = user;
    });
    if (state.auth.currentUser != null) {
        Get.offAllNamed(AppRoutes.homepage);
    } else {
        Get.offAllNamed(AppRoutes.login);
    }
  }

}

