import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/config/app_colors.dart';
import 'package:smart_farm/controller/home_controller.dart';
import 'package:smart_farm/controller/take_picture_controller.dart';

class TakePictureScreen extends StatelessWidget {
  const TakePictureScreen({super.key});

  void takePicture() async {
    try {
      await Get.find<TakePictureController>().initializeControllerFuture;
      Get.find<HomeController>().image.value =
          await Get.find<TakePictureController>()
              .cameraController
              .takePicture();
      Get.find<HomeController>().result.value = {};
      Get.back();
    } catch (e) {
      log('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TakePictureController>(
      builder: (takePictureController) => Scaffold(
        body: FutureBuilder<void>(
          future: takePictureController.initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return buildCameraScreen();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Container buildCameraScreen() => Container(
        color: AppColors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            takePictureTools(),
            CameraPreview(Get.find<TakePictureController>().cameraController),
            takePictureBtn(),
          ],
        ),
      );

  Container takePictureTools() => Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 28,
              ),
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Icon(
            //       Icons.flash_on,
            //       color: AppColors.white,
            //       size: 28,
            //     ),
            //     SizedBox(
            //       width: Get.width * 0.05,
            //     ),
            //     InkWell(
            //       onTap: () {},
            //       child: Icon(
            //         Icons.flip_camera_android,
            //         color: AppColors.white,
            //         size: 28,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      );

  Widget takePictureBtn() => InkWell(
    onTap: takePicture,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      width: Get.width * 0.15,
      height: Get.width * 0.15,
    ),
  );
}
