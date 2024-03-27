// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_farm/api/api_service.dart';
import 'package:smart_farm/config/app_colors.dart';
import 'package:smart_farm/controller/home_controller.dart';
import 'package:smart_farm/widgets/customWidget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void detectPicture() async {
    Get.find<HomeController>().detecting.value = true;
    // Lấy dữ liệu nhị phân của hình ảnh
    // String result = await postImage(File(imagePath));
    String result = await postImage(
        imageFileToBase64(Get.find<HomeController>().image.value.path));
    // log("result: $result"); // In kết quả từ server // Back to the previous screen (TakePictureScreen)
    // Chuyển đổi chuỗi JSON thành một Map<String, dynamic>
    Map<String, dynamic> jsonResponse = jsonDecode(result);
    Get.find<HomeController>().result.value = jsonResponse;
    Get.find<HomeController>().detecting.value = false;
  }

  void choosePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.find<HomeController>().image.value = pickedImage;
      Get.find<HomeController>().result.value = {};
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        buildBtnPart(context),
        const Divider(),
        Expanded(
          child: Center(
            child: Obx(() {
              if (Get.find<HomeController>().image.value.path != '') {
                if (Get.find<HomeController>().result.isEmpty) {
                  return buildResultPart();
                }
                return buildResultInfoPart();
              }
              return const Text('Vui lòng chọn ảnh hoặc chụp ảnh mới!');
            }),
          ),
        ),
      ]),
    );
  }

  SizedBox buildBtnPart(BuildContext context) => SizedBox(
        height: Get.height * 0.25,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWidget.homeBtn(
                onTap: () {
                  Get.toNamed('/take_picture');
                },
                title: 'Start Camera',
                icon: Icons.camera_alt),
            SizedBox(height: Get.height * 0.03),
            CustomWidget.homeBtn(
              onTap: choosePicture,
              title: 'Open Gallery',
              icon: Icons.photo,
            ),
          ],
        ),
      );

  SizedBox buildResultPart() => SizedBox(
        height: Get.height * 0.72,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(Get.find<HomeController>().image.value.path),
                height: Get.height * 0.6,
                width: Get.width * 0.9,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Obx(() {
              return CustomWidget.homeBtn(
                title: 'DETECT',
                textSize: 20,
                height: Get.height * 0.06,
                width: Get.width * 0.9,
                onTap: () async {
                  detectPicture();
                },
                loadingWidget:
                    Get.find<HomeController>().detecting.value == true
                        ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColors.white, size: 30),
                          )
                        : null,
              );
            }),
          ],
        ),
      );

  SizedBox buildResultInfoPart() => SizedBox(
        height: Get.height * 0.72,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              height: Get.height * 0.05,
              child: Text(
                Get.find<HomeController>().result['predicted_class'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(Get.find<HomeController>().image.value.path),
                height: Get.height * 0.45,
                width: Get.width * 0.9,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Obx(() {
              return CustomWidget.homeBtn(
                title: 'DETECT',
                textSize: 20,
                height: Get.height * 0.06,
                width: Get.width * 0.9,
                onTap: () async {
                  detectPicture();
                },
                loadingWidget:
                    Get.find<HomeController>().detecting.value == true
                        ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColors.white, size: 30),
                          )
                        : null,
              );
            }),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomWidget.homeBtn(
                      onTap: precautionDialog,
                      color: AppColors.infoColor,
                      title: 'Precaution',
                      textSize: 20,
                      height: Get.height * 0.06,
                      width: Get.width * 0.42),
                  CustomWidget.homeBtn(
                      onTap: reportDialog,
                      color: AppColors.dangerColor,
                      textColor: AppColors.black,
                      title: 'Report',
                      textSize: 20,
                      height: Get.height * 0.06,
                      width: Get.width * 0.42),
                ],
              ),
            ),
          ],
        ),
      );

  void precautionDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(Get.find<HomeController>().result['predicted_class']),
        content: const Text('Disease info and precaution will be showed here!'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  void reportDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Report'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tell us what wrong!'),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Give us the true name of this disease!'),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Sent'),
          )
        ],
      ),
    );
  }
}


// // Hàm gọi khi người dùng chụp ảnh hoặc chọn ảnh từ thư viện
// void captureOrSelectImage() async {
//   // Code để chụp ảnh hoặc chọn ảnh từ thư viện ở đây
//   // Sau khi có được ảnh, gọi hàm postImage và chờ kết quả từ server
//   File? imageFile =
//       await getImage(); // Hàm này để chụp ảnh hoặc chọn ảnh từ thư viện
//   if (imageFile != null) {
//     String result = await postImage(imageFile);
//     print(result); // In kết quả từ server
//   }
// }