import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/config/app_colors.dart';

class CustomWidget {
  CustomWidget._();
  // this file defines custom widget that used many times in this app

  static InkWell homeBtn(
      {Function()? onTap,
      double? height,
      double? width,
      String? title,
      Color? color,
      Color? textColor,
      double? textSize,
      IconData? icon,
      Color? iconColor,
      Widget? loadingWidget}) {
    List<Widget> chilrenOnRow = [
      Text(
        title ?? '',
        style: TextStyle(color: textColor ?? AppColors.white, fontSize: textSize ?? 16),
      ),
    ];
    if (icon != null) {
      chilrenOnRow.addAll([
        const SizedBox(width: 5),
        Icon(
          icon,
          color: iconColor ?? AppColors.white,
        ),
      ]);
    }
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColors.mainColor,
          borderRadius: BorderRadius.circular(30),
        ),
        width: width ?? Get.width * 0.5,
        height: height ?? Get.height * 0.05,
        child: loadingWidget ?? Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: chilrenOnRow,
        ),
      ),
    );
  }
}
