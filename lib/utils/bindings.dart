import 'package:get/get.dart';
import 'package:smart_farm/controller/home_controller.dart';
import 'package:smart_farm/controller/take_picture_controller.dart';

class InitialBindings extends Bindings {
  @override
  Future dependencies() async {
    await homeController();
    // await greenCaptureController();
  }

  Future<void> homeController() async {
    Get.put(HomeController());
  }

  // Future<void> greenCaptureController() async {
  //   Get.put(GreenCaptureController());
  // }
}

class CameraBindings extends Bindings {
  @override
  Future dependencies() async {
    await takePictureController();
  }

  Future<void> takePictureController() async {
    Get.put(TakePictureController());
  }
}
