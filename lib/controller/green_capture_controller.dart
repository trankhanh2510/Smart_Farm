import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_farm/objs/image.dart';
import 'package:smart_farm/objs/plant.dart';
import 'package:smart_farm/services/crud.dart';
import 'package:smart_farm/services/image.dart';
import 'package:smart_farm/services/local_storage.dart';
import 'package:smart_farm/services/server.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/views/green_capture/dialog_bottom_menu.dart';
import 'package:smart_farm/widgets/dialog/dialog.dart';

class GreenCaptureController extends GetxController {
  // static GreenCaptureController get to => Get.find<GreenCaptureController>();
  RxBool isLoading = false.obs;
  RxBool loadingMore = false.obs;

  RxList<Rx<ImageDetail>> imageDetailViews = <Rx<ImageDetail>>[].obs;
  RxList<Plant> plantViews = <Plant>[].obs;
  RxList<PlantType> plantTypeViews = <PlantType>[].obs;
  RxList<PlantCondition> plantConditionViews = <PlantCondition>[].obs;

  int limit = Config.limitDefault;
  RxInt skip = 0.obs;
  RxInt page = 1.obs;
  Rx<Map<String, dynamic>?> filterValues = Rx(null);
  Rx<DateTime?> dateStartFilter = Rx(null);
  Rx<DateTime?> dateEndFilter = Rx(null);
  Rx<Plant?> plantSelectedFilter = Rx(null);
  Rx<PlantType?> plantTypeSelectedFilter = Rx(null);
  Rx<PlantCondition?> plantConditionSelectedFilter = Rx(null);

  List<DialogBottomMenuItem> menus = [
    const DialogBottomMenuItem(
      icon: Icon(Icons.visibility_rounded),
      child: Text("Xem ảnh"),
      key: "view",
    ),
    const DialogBottomMenuItem(
      icon: Icon(Icons.edit_rounded),
      child: Text("Sửa thông tin ảnh"),
      key: "edit_detail",
    ),
    const DialogBottomMenuItem(
      icon: Icon(
        Icons.delete_rounded,
        color: Colors.red,
      ),
      child: Text(
        "Xóa",
        style: TextStyle(color: Colors.red),
      ),
      key: "delete",
      danger: true,
      dangerContent: "Xóa hình ảnh?",
    ),
  ];

  Future<void> loadData() async {
    isLoading.value = true;
    await ServerService().initFirstData();
    await loadPlants();
    await getImages();
    isLoading.value = false;
  }

  Future<void> loadPlants() async {
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
  }

  Future<void> getImages() async {
    List<Map<String, dynamic>> imageDetails = await CrudService().getDatas(
      Config.imageDetail,
      filter: filterValues.value,
      limit: limit,
      skip: skip.value,
      sort: {"created_at": -1},
      populates: ["id_image"],
    );

    List<ImageDetail> datas = [];
    for (var e in imageDetails) {
      try {
        datas.add(ImageDetail.fromJson(jsonDecode(jsonEncode(e))));
        // ignore: empty_catches
      } catch (e) {}
    }

    imageDetailViews.value = datas.map((e) => Rx(e)).toList();
  }

  Future<void> deleteFilter() async {
    plantSelectedFilter.value = null;
    plantTypeSelectedFilter.value = null;
    plantConditionSelectedFilter.value = null;
    dateStartFilter.value = null;
    dateEndFilter.value = null;
    filterValues.value = null;
    Get.back();
    await reload();
  }

  Future<void> filter() async {
    Map<String, dynamic> filterData = {};
    if (plantSelectedFilter.value != null) {
      filterData
          .addEntries({"id_plant": "${plantSelectedFilter.value?.id}"}.entries);
    }
    if (plantTypeSelectedFilter.value != null) {
      filterData.addEntries(
          {"id_plant_type": "${plantTypeSelectedFilter.value?.id}"}.entries);
    }
    if (plantConditionSelectedFilter.value != null) {
      filterData.addEntries({
        "id_condition": "${plantConditionSelectedFilter.value?.id}"
      }.entries);
    }
    if (dateStartFilter.value != null && dateEndFilter.value == null) {
      filterData.addEntries({
        "created_at": {
          "\$gte": {
            "\$date": dateStartFilter.value!.millisecondsSinceEpoch ~/ 1000
          },
        },
      }.entries);
    }
    if (dateStartFilter.value != null && dateEndFilter.value != null) {
      filterData.addEntries({
        "created_at": {
          "\$gte": {
            "\$date": dateStartFilter.value!.millisecondsSinceEpoch ~/ 1000
          },
          "\$lte": {
            "\$date":
                dateEndFilter.value!.millisecondsSinceEpoch ~/ 1000 + 86400
          },
        },
      }.entries);
    }
    filterValues.value = filterData;
    await reload();
  }

  Future<void> loadMoreImages() async {
    loadingMore.value = true;
    if (imageDetailViews.isNotEmpty) {
      skip.value = page.value * limit;
    } else {
      skip.value = 0;
    }
    List<Map<String, dynamic>> imageDetails = await CrudService().getDatas(
      Config.imageDetail,
      limit: limit,
      skip: skip.value,
      sort: {"created_at": -1},
      populates: ["id_image"],
    );
    List<ImageDetail> images = [];
    for (var e in imageDetails) {
      try {
        ImageDetail imageDetail =
            ImageDetail.fromJson(jsonDecode(jsonEncode(e)));
        imageDetailViews.add(Rx(imageDetail));
        // ignore: empty_catches
      } catch (e) {}
    }
    imageDetailViews.addAll(images.map((e) => Rx(e)).toList());
    if (images.isNotEmpty) {
      page.value += 1;
    }
    loadingMore.value = false;
  }

  Future<void> onClickImage(ImageDetail item, int index) async {
    if (item.idImage == null) {
      Fluttertoast.showToast(msg: "Không tìm thấy hình ảnh");
      return;
    }
    ImageApp imageApp = item.idImage!;

    DialogBottomMenuItem? menuItem = await dialogBottomMenu("Menu", menus);

    if (menuItem?.key == "view") {
      Get.toNamed("/image-view", arguments: {"url": imageApp.downloadUri});
    }
    if (menuItem?.key == "edit_detail") {
      Get.toNamed("/edit-image-detail", arguments: {
        "image-detail": item,
      });
    }
    if (menuItem?.key == "delete") {
      bool result = await dialogProgress(handle: () async {
        return await ImageService().delete(imageApp);
      });

      if (result) {
        imageDetailViews.removeAt(index);
        Fluttertoast.showToast(msg: "Đã xóa");
        Get.back();
      }
    }
  }

  Future<void> reload() async {
    isLoading.value = true;
    page.value = 1;
    skip.value = 0;
    await getImages();
    isLoading.value = false;
  }
}
