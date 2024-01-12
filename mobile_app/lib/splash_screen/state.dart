import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashState {
  late FirebaseAuth auth;
  final user = Rxn<User>();
  late Stream<User?> authStateChanges;
}