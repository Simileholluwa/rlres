import 'package:atles/splash_screen/controller.dart';
import 'package:get/get.dart';
import 'local_storage.dart';

class InitialBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<StorageService>(() => StorageService().init());
    Get.put(AuthController());
  }
}