import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/widgets/dialog/dialog.dart';
import 'package:smart_farm/widgets/theme.dart';

class DialogBottomMenuItem {
  final Widget? icon;
  final Widget child;
  final String key;
  final bool? danger;
  final String? dangerContent;
  const DialogBottomMenuItem({
    this.icon,
    required this.child,
    required this.key,
    this.danger,
    this.dangerContent,
  });
}

Future<DialogBottomMenuItem?> dialogBottomMenu(
  String title,
  List<DialogBottomMenuItem> menus,
) async {
  DialogBottomMenuItem? dialogBottomMenu;
  await Get.bottomSheet(
    Container(
      color: Get.theme.colorScheme.surface,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                title,
                style: ThemeApp.textStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ...menus.map(
                      (e) => ListTile(
                        leading: e.icon,
                        title: e.child,
                        onTap: () async {
                          if (e.danger == true) {
                            bool check = await dialogConfirm(
                                content: e.dangerContent ?? "Xác nhận");
                            if (check) {
                              dialogBottomMenu = e;
                              Get.back();
                            }
                          } else {
                            dialogBottomMenu = e;
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
    isScrollControlled: false,
  );

  return dialogBottomMenu;
}
