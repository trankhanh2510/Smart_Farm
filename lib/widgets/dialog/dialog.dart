import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> dialogProgress({Function? handle}) async {
  bool result = false;
  Get.dialog(
    const AlertDialog(
      title: Text("Đang tải..."),
      content: LinearProgressIndicator(),
    ),
  );
  if (handle != null) {
    result = await handle();
    Get.back();
  }
  return result;
}

Future<bool> dialogConfirm({
  String? title,
  String? ok,
  String? cancel,
  required String content,
}) async {
  bool result = false;
  await Get.dialog(
    AlertDialog(
      title: Text(title ?? "Xác nhận"),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(cancel ?? "Hủy"),
        ),
        TextButton(
          onPressed: () async {
            result = true;
            Get.back();
          },
          child: Text(ok ?? "Đồng ý"),
        ),
      ],
    ),
  );
  return result;
}

dialogNotification(
    {String? message, required String content, Function? accept}) async {
  Get.dialog(
    AlertDialog(
      title: Text(message ?? "Thông báo"),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () async {
            if (accept != null) {
              await accept();
            }
            Get.back();
          },
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

class DownloadController extends GetxController {
  RxInt total = 1.obs;
  RxInt receive = 1.obs;
}

dialogProgressDownload({Function? handle, Function? toPage}) async {
  DownloadController downloadController = Get.put(DownloadController());
  Get.dialog(
    AlertDialog(
      title: const Text("Đang tải..."),
      content: Obx(() {
        int total = downloadController.total.value;
        int receive = downloadController.receive.value;
        return LinearProgressIndicator(value: receive / total);
      }),
    ),
  );
  if (handle != null) {
    await handle();
  }
  Get.back();
  if (toPage != null) {
    await toPage();
  }
}
