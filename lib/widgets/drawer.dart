import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/home_controller.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Drawer(
      child: Container(
        width: Get.width * 0.5,
        height: Get.height,
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Container(
              height: Get.height * 0.2,
              // width,
              decoration: const BoxDecoration(
                // color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo_seacorp.png'),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      homeController.numPage.value = 0;
                      // Get.toNamed('/main');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text(
                      'Picture',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      homeController.numPage.value = 1;
                      // Get.toNamed('/home');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.wifi),
                    title: const Text(
                      'Green picture',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      // homeController.numPage.value = 1;
                      // Get.toNamed('/home');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
