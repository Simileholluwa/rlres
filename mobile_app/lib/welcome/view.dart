import 'package:atles/common/widgets/index.dart';
import 'package:atles/welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends GetView<WelcomeController> {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AndroidBottomNav(
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            scrolledUnderElevation: 0,
          ),
          bottomNavigationBar: Container(
            height: 60,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.state.isCheckPlate.isTrue
                      ? 'User mode'
                      : 'Admin mode',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Theme(
                  data: ThemeData().copyWith(
                      colorScheme: Theme.of(context)
                          .colorScheme
                          .copyWith(outline: Colors.transparent)),
                  child: Switch(
                    value: controller.state.isCheckPlate.value,
                    onChanged: (value) {
                      controller.state.isCheckPlate.value = value;
                    },
                    inactiveThumbColor: const Color(0xff13a866),
                    inactiveTrackColor: Colors.white,
                    activeTrackColor: Colors.white,
                    activeColor: const Color(0xffffbd3a),
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/splash_screen_logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      'R.L.R.E.S',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'Red Light Running Enforcement System',
                      style:
                          TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: controller.state.formKey,
                      child: Column(
                        children: [
                          controller.state.isCheckPlate.isTrue
                              ? CustomTextField(
                                  onSaved: (value) {
                                    controller.state.licensePlateController.text =
                                        value!;
                                  },
                                  inputAction: TextInputAction.done,
                                  controller:
                                      controller.state.licensePlateController,
                                  hintText: 'Enter your plate number',
                                  validator: (value) {
                                    RegExp format1 = RegExp(r'^[A-Za-z]{3}-\d{2,3}[A-Za-z]{2}$');
                                    RegExp format2 = RegExp(r'^[A-Za-z]{2}\d{3}-[A-Za-z]{3}$');
                                    RegExp format3 = RegExp(r'^[A-Za-z]{3}-[0-9]{4}[A-Za-z]{1}$');
                                    if (value!.isEmpty) {
                                      return "Please enter your plate number";
                                    } else if (value.contains(' ')) {
                                      return 'Space character is not allowed';
                                    } else {
                                      return null;
                                    }
                                  },
                                  focusedColor: Color(0xffffbd3a),
                                )
                              : CustomTextField(
                                  onSaved: (value) {
                                    controller.state.emailController.text =
                                        value!;
                                  },
                                  controller: controller.state.emailController,
                                  hintText: 'Enter your email address',
                                  validator: (String? value) {
                                    if (!GetUtils.isEmail(value!)) {
                                      return 'Email a valid email address';
                                    } else if (value.isEmpty) {
                                      return 'Email cannot be empty';
                                    } else if (value.contains(' ')) {
                                      return 'Remove all whitespaces';
                                    } else {
                                      return null;
                                    }
                                  },
                                  prefixIcon: Icon(Icons.email),
                                  textInputType: TextInputType.emailAddress,
                                  focusedColor: Color(0xff13a866),
                                ),
                          controller.state.isCheckPlate.isTrue
                              ? Container()
                              : SizedBox(height: 20),
                          controller.state.isCheckPlate.isTrue
                              ? Container()
                              : CustomTextField(
                                  onSaved: (value) {
                                    controller.state.passwordController.text =
                                        value!;
                                  },
                                  isHidden: true,
                                  inputAction: TextInputAction.done,
                                  controller: controller.state.passwordController,
                                  hintText: 'Enter your password',
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter your password";
                                    } else if (value.length < 6) {
                                      return 'Password is greater than 6 characters';
                                    } else {
                                      return null;
                                    }
                                  },
                                  prefixIcon: Icon(Icons.password),
                                  focusedColor: Color(0xff13a866),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                      onTap: () {
                        final isValid =
                            controller.state.formKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        } else {
                          controller.state.isCheckPlate.isTrue
                              ? controller.checkPlateNumber(controller.state.licensePlateController.text
                              .removeAllWhitespace.toUpperCase())
                              : controller.signInWithEmail(
                                  controller.state.emailController.text
                                      .removeAllWhitespace,
                                  controller.state.passwordController.text
                                      .removeAllWhitespace);
                        }
                      },
                      loadingColor: controller.state.isCheckPlate.isTrue
                          ? const Color(0xffffbd3a)
                          : Color(0xff13a866),
                      buttonColor: controller.state.isCheckPlate.isTrue
                          ? Color(0xffffbd3a)
                          : Color(0xff13a866),
                      text: controller.state.isCheckPlate.isTrue
                          ? 'Check violators list'
                          : 'Connect to stream',
                      isLoading:
                          controller.state.isLoading.isFalse ? false : true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
