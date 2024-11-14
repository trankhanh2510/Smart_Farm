import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/green_capture_controller.dart';
import 'package:smart_farm/objs/image.dart';
import 'package:smart_farm/objs/plant.dart';
import 'package:smart_farm/widgets/loading_page.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class GreenCapturePage extends StatelessWidget {
  const GreenCapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GreenCaptureController());
    GreenCaptureController greenCaptureController =
        Get.find<GreenCaptureController>();

    return Obx(() {
      bool loadMore = greenCaptureController.loadingMore.value;
      List<Rx<ImageDetail>> items = greenCaptureController.imageDetailViews;
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed("/image-management"),
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.folder_rounded,
            color: Colors.white,
          ),
        ),
        body: greenCaptureController.isLoading.value
            ? const LoadingPage()
            : NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    if (notification.metrics.extentAfter <= 100 && !loadMore) {
                      greenCaptureController.loadMoreImages();
                    }
                  }

                  return false;
                },
                child: ListView.separated(
                  separatorBuilder: (context, index) => Container(
                    color: Colors.grey.withOpacity(0.5),
                    height: 0.5,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemDetail(
                      index: index,
                      data: items[index],
                    );
                  },
                ),
              ),
      );
    });
  }
}

class ItemDetail extends StatelessWidget {
  final Rx<ImageDetail> data;
  final int index;
  const ItemDetail({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(GreenCaptureController());
    GreenCaptureController greenCaptureController =
        Get.find<GreenCaptureController>();
    return Obx(() {
      ImageDetail item = data.value;
      ImageApp? imageApp = item.idImage;

      Plant? plant = greenCaptureController.plantViews
          .firstWhereOrNull((e) => e.id == item.idPlant);

      PlantType? plantType = greenCaptureController.plantTypeViews
          .firstWhereOrNull((e) => e.id == item.idPlantType);

      PlantCondition? plantCondition = greenCaptureController
          .plantConditionViews
          .firstWhereOrNull((e) => e.id == item.idCondition);

      DateTime? createdAt = item.createdAt;
      String? formattedDate;
      if (createdAt != null) {
        formattedDate = DateFormat('HH:mm:ss dd-MM-yyyy').format(
          createdAt.add(const Duration(hours: 7)),
        );
      }

      return imageApp == null
          ? const ListTile(
              title: Text(
                "Không tìm thấy hình ảnh",
                style: TextStyle(color: Colors.red),
              ),
            )
          : ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  formattedDate == null
                      ? const SizedBox()
                      : Text("Tạo lúc: $formattedDate"),
                  plant == null
                      ? const SizedBox()
                      : Text("Giống: ${plant.name}"),
                  plantType == null
                      ? const SizedBox()
                      : Text("Loại hình ảnh: ${plantType.name}"),
                  plantCondition == null
                      ? const SizedBox()
                      : Text("Sinh trưởng: ${plantCondition.name}"),
                  Text("Mô tả: ${item.description}"),
                ],
              ),
              onTap: () async =>
                  await greenCaptureController.onClickImage(item, index),
            );
    });
  }
}
