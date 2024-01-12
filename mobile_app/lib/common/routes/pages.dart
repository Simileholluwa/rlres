import 'package:atles/homepage/index.dart';
import 'package:atles/splash_screen/binding.dart';
import 'package:get/get.dart';
import '../../splash_screen/view.dart';
import '../../welcome/index.dart';
import 'names.dart';

class AppPages {
  static const initial = AppRoutes.initial;

  static final List<GetPage> routes = [

    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.downToUp,
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const Welcome(),
      binding: WelcomeBinding(),
      transition: Transition.downToUp,
    ),

    GetPage(
      name: AppRoutes.homepage,
      page: () => const Homepage(),
      binding: HomepageBinding(),
      transition: Transition.downToUp,
    ),

  ];






}