import 'package:get/get.dart';
import 'package:smart_farm/controller/home_controller.dart';
import 'package:smart_farm/controller/take_picture_controller.dart';

class InitialBindings extends Bindings {
  @override
  Future dependencies() async {
    await homeController();
  }

  Future<void> homeController() async {
    Get.put(HomeController());
  }
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