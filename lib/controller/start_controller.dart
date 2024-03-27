import 'package:get/get.dart';

class StartController extends GetxController {
  @override
  void onInit() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    Get.offAndToNamed("/home");
    super.onInit();
  }
}