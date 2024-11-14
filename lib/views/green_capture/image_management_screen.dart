import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/image_controller/image_management_controller.dart';
import 'package:smart_farm/objs/image_local.dart';
import 'package:smart_farm/objs/plant.dart';
import 'package:smart_farm/objs/upload_obj.dart';
import 'package:smart_farm/utils/tool.dart';
import 'package:smart_farm/widgets/progress.dart';
import 'package:smart_farm/widgets/widgets.dart';

class ImageManagementScreen extends StatelessWidget {
  const ImageManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ImageManagementController imageManagementController =
        Get.put(ImageManagementController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý hình ảnh"),
        backgroundColor: Tool.appBar_bg,
        foregroundColor: Tool.appBar_title,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Tool.appBar_title,
        ),
        actions: [
          IconButton(
            onPressed: () async =>
                await imageManagementController.uploadAllImage(),
            icon: const Icon(Icons.cloud_upload_rounded),
          ),
        ],
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    ImageManagementController imageManagementController =
        Get.find<ImageManagementController>();
    return Obx(() {
      bool loading = imageManagementController.loading.value;
      List<Rx<ImageLocal>> items = imageManagementController.imageLocalViews;
      List<Rx<UploadObj>> itemsUploadObj = imageManagementController.uploadObjs;
      return loading
          ? const CircularProgress()
          : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const _ButtonAdd();
                } else {
                  return _Item(
                    item: items[index - 1],
                    index: index,
                    uploadObj: itemsUploadObj[index - 1],
                  );
                }
              },
              separatorBuilder: separatorBuilder,
              itemCount: items.length + 1,
            );
    });
  }
}

class _ButtonAdd extends StatelessWidget {
  const _ButtonAdd();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded),
            SizedBox(width: 10),
            Text("Thêm hình ảnh"),
          ],
        ),
      ),
      onTap: () => Get.toNamed("/add-image"),
    );
  }
}

class _Item extends StatelessWidget {
  final Rx<ImageLocal> item;
  final Rx<UploadObj> uploadObj;
  final int index;
  const _Item({
    required this.item,
    required this.uploadObj,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    ImageManagementController imageManagementController =
        Get.find<ImageManagementController>();
    return GetBuilder(
      init: imageManagementController,
      builder: (controller) {
        ImageLocal imageLocal = item.value;
        Plant? plant = imageManagementController.plantViews
            .firstWhereOrNull((e) => e.id == imageLocal.idPlant);

        PlantType? plantType = imageManagementController.plantTypeViews
            .firstWhereOrNull((e) => e.id == imageLocal.idPlantType);

        PlantCondition? plantCondition = imageManagementController
            .plantConditionViews
            .firstWhereOrNull((e) => e.id == imageLocal.idCondition);
        UploadObj upload = uploadObj.value;

        return ListTile(
          leading: imageLocal.imageFile == null
              ? null
              : SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.file(
                    imageLocal.imageFile!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Giống: ${plant?.name ?? ""}"),
              Text("Loại hình ảnh: ${plantType?.name ?? ""}"),
              Text("Sinh trưởng: ${plantCondition?.name ?? ""}"),
              Text("Mô tả: ${imageLocal.description ?? ""}"),
              imageLocal.uploaded == true
                  ? const Text(
                      "Đã tải lên server",
                      style: TextStyle(color: Colors.green),
                    )
                  : const SizedBox(),
              upload.message == null ? const SizedBox() : Text(upload.message!),
            ],
          ),
          onTap: () async =>
              await imageManagementController.onClickImage(imageLocal, index),
        );
      },
    );
  }
}
