import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/views/green_capture/green_capture_page.dart';
import 'package:smart_farm/views/home_page.dart';
import 'package:smart_farm/views/picture_page.dart';

class HomeController extends GetxController {
  // loading state variants
  RxBool detecting = false.obs;
  // data variants
  Rx<XFile> image = XFile('').obs;
  RxMap result = {}.obs;

  List<Widget> pages = [
    const HomePage(),
    const PicturePage(),
    const GreenCapturePage(),
  ];
  List<String> titles = [
    'Trang chủ',
    'Picture',
    'Green Capture',
  ];
  RxInt numPage = 0.obs;
}
