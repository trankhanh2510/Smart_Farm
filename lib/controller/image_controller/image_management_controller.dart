import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_farm/objs/image_local.dart';
import 'package:smart_farm/objs/plant.dart';
import 'package:smart_farm/objs/upload_obj.dart';
import 'package:smart_farm/objs/upload_response.dart';
import 'package:smart_farm/services/image.dart';
import 'package:smart_farm/services/local_storage.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/widgets/dialog/dialog.dart';
import 'package:smart_farm/widgets/dialog/dialog_bottom_menu.dart';

class ImageManagementController extends GetxController {
  RxBool loading = false.obs;
  RxList<Rx<ImageLocal>> imageLocalViews = <Rx<ImageLocal>>[].obs;
  RxList<Rx<UploadObj>> uploadObjs = <Rx<UploadObj>>[].obs;

  RxList<Plant> plantViews = <Plant>[].obs;
  RxList<PlantType> plantTypeViews = <PlantType>[].obs;
  RxList<PlantCondition> plantConditionViews = <PlantCondition>[].obs;
  RxList<ImageLocal> uploadedViews = <ImageLocal>[].obs;

  Future<void> uploadServer(ImageLocal item, int index) async {
    if (item.id == null && item.imageFile == null) {
      Fluttertoast.showToast(
          msg: "Dữ liệu không chính xác vui lòng xóa hình ảnh và thêm lại");
      return;
    }

    if (item.uploaded == true) {
      Fluttertoast.showToast(msg: "Hình này đã tải lên server");
      return;
    }

    bool check = await dialogConfirm(content: "Tải hình này lên server");
    if (!check) {
      return;
    }
    bool? result = await dialogProgress(handle: () async {
      UploadResponse? uploadResponse =
          await ImageService().upload(item, (count, total) {
        uploadObjs[index].value.total = total;
        uploadObjs[index].value.count = count;
        uploadObjs[index].value.message =
            "Đã tải lên ${(count / total * 100).toStringAsFixed(1)}%";
        update();
      });
      if (uploadResponse != null) return true;
    });

    if (result) {
      item.uploaded = true;
      if (item.id != null) {
        await (await LocalStorage.init(Config.imageDetailLocal))
            .update(item.id!, item.toJson());
      }
      imageLocalViews[index].value = item;
      Fluttertoast.showToast(msg: "Hình ảnh đã tải lên server");

      bool checkDelete = await dialogConfirm(
          content: "Bạn có muốn xóa hình ảnh trong mục quản lý?");

      if (checkDelete) {
        await ImageService().deleteImageLocal(item);
        await getImages();
      }
    }
    update();
  }

  Future<void> deleteAllImageUploaded() async {
    await reload();
    if (imageLocalViews.isNotEmpty) {
      bool checkDelete = await dialogConfirm(
          content: "Bạn có muốn xóa hình ảnh trong mục quản lý?");

      if (checkDelete) {
        for (var item in uploadedViews) {
          if (item.uploaded == true) {
            await ImageService().deleteImageLocal(item);
          }
        }
        Get.back();
      } else {
        uploadedViews.value = [];
      }
    }
  }

  Future<void> uploadAllImage() async {
    bool check =
        await dialogConfirm(content: "Tải toàn bộ hình ảnh lên server");
    if (!check) {
      return;
    }
    for (int i = 0; i < imageLocalViews.length; i++) {
      ImageLocal item = imageLocalViews[i].value;
      if (item.id == null && item.imageFile == null) {
        continue;
      }

      if (item.uploaded == true) {
        continue;
      }

      bool? result = await dialogProgress(handle: () async {
        UploadResponse? uploadResponse =
            await ImageService().upload(item, (count, total) {
          uploadObjs[i].value.total = total;
          uploadObjs[i].value.count = count;
          uploadObjs[i].value.message =
              "Đã tải lên ${(count / total * 100).toStringAsFixed(1)}%";
          update();
        });
        if (uploadResponse != null) return true;
      });

      if (result) {
        uploadedViews.add(item);
        item.uploaded = true;
        if (item.id != null) {
          await (await LocalStorage.init(Config.imageDetailLocal))
              .update(item.id!, item.toJson());
        }
        imageLocalViews[i].value = item;
        update();
      }
    }
    await deleteAllImageUploaded();
  }

  Future<void> deleteImage(ImageLocal item) async {
    if (item.id == null && item.imageFile == null) {
      Fluttertoast.showToast(
          msg: "Dữ liệu không chính xác vui lòng xóa hình ảnh và thêm lại");
    }
    bool check = await dialogConfirm(content: "Xóa hình ảnh");
    if (check) {
      bool result = await ImageService().deleteImageLocal(item);
      if (result) {
        Fluttertoast.showToast(msg: "Đã xóa hình ảnh");
        await reload();
      }
    }
  }

  Future<void> onClickImage(ImageLocal item, int index) async {
    List<DialogBottomMenuItem> menus = [];
    if (item.imageFile != null) {
      menus.add(const DialogBottomMenuItem(
        icon: Icon(Icons.file_upload_rounded),
        child: Text("Tải lên hình này server"),
        key: "upload",
      ));
      menus.add(const DialogBottomMenuItem(
        icon: Icon(Icons.visibility_rounded),
        child: Text("Xem"),
        key: "view",
      ));
    }
    menus.add(const DialogBottomMenuItem(
      icon: Icon(Icons.delete_rounded, color: Colors.red),
      child: Text("Xóa"),
      key: "delete",
    ));

    DialogBottomMenuItem? dialogBottomMenuItem =
        await dialogBottomMenu("Menu", menus);

    if (dialogBottomMenuItem?.key == "view" && item.imageFile != null) {
      Get.toNamed("/image-view", arguments: {"image": item.imageFile});
    }

    if (dialogBottomMenuItem?.key == "upload") {
      // lý do index - 1 là vì giao diện có thêm item "thêm hình ảnh" có index = 0
      await uploadServer(item, index - 1);
    }

    if (dialogBottomMenuItem?.key == "delete") {
      await deleteImage(item);
    }
  }

  Future<void> reload() async {
    loading.value = true;
    await getImages();
    loading.value = false;
  }

  Future<void> getImages() async {
    List<ImageLocal> images = await ImageService().getImagesLocal();
    images.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return b.createdAt!.compareTo(a.createdAt!);
      }
      return 0;
    });

    uploadObjs.value = List.generate(
      images.length,
      (i) => Rx(UploadObj(total: 1, count: 1)),
    ).toList();

    imageLocalViews.value = images.map((e) => Rx(e)).toList();
  }

  Future<void> _init() async {
    loading.value = true;
    List<dynamic> plants = (await LocalStorage.init(Config.plant)).read();
    plantViews.value =
        plants.map((e) => Plant.fromJson(jsonDecode(jsonEncode(e)))).toList();

    List<dynamic> plantTypes =
        (await LocalStorage.init(Config.plantType)).read();
    plantTypeViews.value = plantTypes
        .map((e) => PlantType.fromJson(jsonDecode(jsonEncode(e))))
        .toList();

    List<dynamic> plantConditions =
        (await LocalStorage.init(Config.plantCondition)).read();
    plantConditionViews.value = plantConditions
        .map((e) => PlantCondition.fromJson(jsonDecode(jsonEncode(e))))
        .toList();

    await getImages();
    loading.value = false;
  }

  @override
  void onInit() async {
    super.onInit();

    await _init();
  }
}
