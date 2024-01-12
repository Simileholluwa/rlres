import 'package:atles/common/routes/index.dart';
import 'package:atles/welcome/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/widgets/toast_message.dart';
import '../services/Authentication/auth_exceptions.dart';
import '../services/Authentication/auth_service.dart';
import '../common/utils/firestore_ref.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeController extends GetxController {
  WelcomeController();

  final state = WelcomeState();

  @override
  void onInit() {
    super.onInit();
    state.emailController = TextEditingController();
    state.licensePlateController = TextEditingController();
    state.passwordController = TextEditingController();

  }

  @override
  void onClose() {
    state.emailController.dispose();
    state.licensePlateController.dispose();
    state.passwordController.dispose();
    super.onClose();
  }

  checkPlateNumber(String plateNumber) async {
    try {
      state.isLoading.value = true;
      QuerySnapshot snapshot = await allPlateNumbers.where(
          'plate_number', isEqualTo: plateNumber).get();
      if (snapshot.docs.isNotEmpty) {
        QuerySnapshot snapshot = await allViolators.where(
            'plate_number', isEqualTo: plateNumber).get();
        if (snapshot.docs.isNotEmpty) {
          Map<String, dynamic> data = snapshot.docs.first.data() as Map<
              String,
              dynamic>;
          state.isLoading.value = false;
          String date = data['date'];
          String time = data['time'];
          String parsedDate = dateOfViolation(date);
          String parsedTime = timeOfViolation(time);
          return CoolAlert.show(
            context: Get.context!,
            type: CoolAlertType.info,
            animType: CoolAlertAnimType.slideInUp,
            title: '${data['name']}... Oh my!',
            text: 'We ran a check through your license plate and have discovered you violated a red light on $parsedDate at $parsedTime. Please visit the nearest FRSC office to pay your fine.',
            confirmBtnText: 'Okay!',
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
            confirmBtnColor: const Color(0xff13a866),
            backgroundColor: Theme
                .of(Get.context!)
                .canvasColor,
          );
        } else {
          state.isLoading.value = false;
          return CoolAlert.show(
            context: Get.context!,
            type: CoolAlertType.success,
            animType: CoolAlertAnimType.slideInUp,
            title: 'You are awesome!',
            text: 'We ran a check through your license plate and have discovered you did not violate a red light.',

            confirmBtnText: 'Great!',
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
            confirmBtnColor: const Color(0xff13a866),
            backgroundColor: Theme
                .of(Get.context!)
                .canvasColor,
          );
        }
      } else {
        state.isLoading.value = false;
        return CoolAlert.show(
          context: Get.context!,
          type: CoolAlertType.error,
          animType: CoolAlertAnimType.slideInUp,
          title: 'Invalid Plate Number!',
          text: 'Your input does not match any license plate number. Please check that your input is correct..',

          confirmBtnText: 'Okay!',
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
          confirmBtnColor: const Color(0xff13a866),
          backgroundColor: Theme
              .of(Get.context!)
              .canvasColor,
        );
      }
    } catch(e) {
      message('An error occurred. Please try again.');
      print(e);
      state.isLoading.value = false;
    }
  }

  void signInWithEmail(String email, String password) async {
    try {
      state.isLoading.value = true;
      await AuthService.firebase().logIn(
        email: email,
        password: password,
      );
      state.isLoading.value = false;
      Get.offAllNamed(AppRoutes.homepage);
      message('Signed in successfully', isError: false);
    } on UserNotFoundAuthException {
      state.isLoading.value = false;
      message('No account found with this email.');
    } on WrongPasswordAuthException {
      state.isLoading.value = false;
      message('Your password is incorrect.');
    } on UnknownAuthException {
      state.isLoading.value = false;
      message('Text fields cannot be empty.');
    } on InvalidEmailAuthException {
      state.isLoading.value = false;
      message('The email address is invalid.');
    } on NetworkRequestFailedAuthException {
      state.isLoading.value = false;
      message('You are not connected to the internet.');
    } on TooManyRequestAuthException {
      state.isLoading.value = false;
      message(
          'Your account is locked due to too many incorrect password. Please, try again later.');
    } on GenericAuthException {
      state.isLoading.value = false;
      message('Sign in failed. Please try again.');
    }
  }

  String timeOfViolation(String videoName) {
    RxString amPm = ''.obs;
    final parts = videoName.split('-');
    if (int.tryParse(parts[0])! < 12) {
      amPm.value = 'AM';
    } else if (int.tryParse(parts[0])! >= 12) {
      amPm.value = 'PM';
    }
    return '${parts[0]}:${parts[1]}:${parts[2]} ${amPm.value}';
  }

  String dateOfViolation(String folderName) {
    RxString month = ''.obs;
    final parts = folderName.split('-');
    if (parts.length >= 3) {
      switch (parts[1]) {
        case '01':
          month.value = 'Jan.';
          break;
        case '02':
          month.value = 'Feb.';
          break;
        case '03':
          month.value = 'Mar.';
          break;
        case '04':
          month.value = 'Apr.';
          break;
        case '05':
          month.value = 'May';
          break;
        case '06':
          month.value = 'June';
          break;
        case '07':
          month.value = 'July';
          break;
        case '08':
          month.value = 'Aug.';
          break;
        case '09':
          month.value = 'Sep.';
          break;
        case '10':
          month.value = 'Oct.';
          break;
        case '11':
          month.value = 'Nov.';
          break;
        case '12':
          month.value = 'Dec.';
          break;
      }
      return '${month.value} ${parts[2]}, ${parts[0]}';
    } else {
      return 'Captured';
    }
  }

}
