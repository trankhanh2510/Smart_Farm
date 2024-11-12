import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/home_controller.dart';
import 'package:smart_farm/widgets/drawer.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: Text(homeController.titles[homeController.numPage.value]),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: homeController.pages[homeController.numPage.value],
          drawer: const MainDrawer(),
        );
      },
    );
  }
}
