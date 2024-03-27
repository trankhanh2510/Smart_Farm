import 'package:camera/camera.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // loading state variants
  RxBool detecting = false.obs;
  // data variants
  Rx<XFile> image = XFile('').obs;
  RxMap result = {}.obs;
}