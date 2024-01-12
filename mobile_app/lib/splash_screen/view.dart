import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import 'controller.dart';

class SplashScreen extends GetView<AuthController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        systemNavBarStyle: FlexSystemNavBarStyle.scaffoldBackground,
        useDivider: false,
        opacity: 1,
      ),
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
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
            ],
          ),
        ),
      ),
    );
  }
}
