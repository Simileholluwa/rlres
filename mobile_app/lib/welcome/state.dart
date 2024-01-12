import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class WelcomeState {
  late TextEditingController emailController, passwordController, licensePlateController;
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isCheckPlate = false.obs;
}