import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/green_capture_controller.dart';
import 'package:smart_farm/controller/home_controller.dart';
import 'package:smart_farm/utils/tool.dart';
import 'package:smart_farm/widgets/dialog/dialog_filter.dart';
import 'package:smart_farm/widgets/drawer.dart';
import 'package:smart_farm/widgets/progress.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    Get.put(GreenCaptureController());
    GreenCaptureController greenCaptureController =
        Get.find<GreenCaptureController>();
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: Text(homeController.titles[homeController.numPage.value]),
            backgroundColor: Tool.appBar_bg,
            foregroundColor: Tool.appBar_title,
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Tool.appBar_title,
            ),
            actions: homeController.numPage.value != 2
                ? []
                : [
                    Obx(() {
                      bool loadingMore =
                          greenCaptureController.loadingMore.value;
                      return loadingMore
                          ? const CircularProgress()
                          : const SizedBox();
                    }),
                    IconButton(
                      onPressed: () async => dialogFilterImages(),
                      icon: const Icon(Icons.filter_alt_rounded),
                    ),
                    IconButton(
                      onPressed: () async =>
                          await greenCaptureController.reload(),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
          ),
          body: homeController.pages[homeController.numPage.value],
          drawer: const MainDrawer(),
        );
      },
    );
  }
}
