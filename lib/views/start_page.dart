import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_farm/config/app_colors.dart';
import 'package:smart_farm/controller/start_controller.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StartController());
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            Image.asset("assets/images/logo_seacorp.png"),
            LoadingAnimationWidget.hexagonDots(color: AppColors.mainColor, size: 50)
          ],
        ),
      ),
    );
  }
}
