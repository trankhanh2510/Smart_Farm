import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/green_capture_controller.dart';
import 'package:smart_farm/objs/image.dart';
import 'package:smart_farm/objs/plant.dart';
import 'package:smart_farm/services/crud.dart';
import 'package:smart_farm/services/local_storage.dart';
// import 'package:smart_farm/src/home/controllers/home_controller.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/widgets/dialog/dialog.dart';

class EditImageDetailController extends GetxController {
  final ImageDetail imageDetail;
  EditImageDetailController({
    required this.imageDetail,
  });

  RxBool loading = false.obs;
  final formKey = GlobalKey<FormState>();

  RxList<Plant> plantViews = <Plant>[].obs;
  RxList<PlantType> plantTypeViews = <PlantType>[].obs;
  RxList<PlantCondition> plantConditionViews = <PlantCondition>[].obs;

  Rx<Plant?> plantSelected = Rx(null);
  Rx<PlantType?> plantTypeSelected = Rx(null);
  Rx<PlantCondition?> plantConditionSelected = Rx(null);
  TextEditingController controllerDescription = TextEditingController();

  Future<void> save() async {
    if (plantSelected.value == null ||
        plantTypeSelected.value == null ||
        plantConditionSelected.value == null) {
      Fluttertoast.showToast(msg: "Vui lòng chọn đầy đủ thông tin");
      return;
    }

    Map<String, dynamic> value = {
      "id": imageDetail.id,
      "id_plant": plantSelected.value!.id,
      "id_plant_type": plantTypeSelected.value!.id,
      "id_condition": plantConditionSelected.value!.id,
      "description": controllerDescription.text,
    };

    bool result = await dialogProgress(handle: () async {
      return await CrudService().update(
        Config.imageDetail,
        [value],
      );
    });

    if (result) {
      await Get.find<GreenCaptureController>().reload();
      Fluttertoast.showToast(msg: "Đã lưu");
    } else {
      Fluttertoast.showToast(msg: "Không thể chỉnh sửa thông tin hình ảnh");
    }
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

    Plant? plant =
        plantViews.firstWhereOrNull((e) => e.id == imageDetail.idPlant);
    plantSelected.value = plant;
    PlantType? plantType =
        plantTypeViews.firstWhereOrNull((e) => e.id == imageDetail.idPlantType);
    plantTypeSelected.value = plantType;
    PlantCondition? plantCondition = plantConditionViews
        .firstWhereOrNull((e) => e.id == imageDetail.idCondition);
    plantConditionSelected.value = plantCondition;
    controllerDescription.text = imageDetail.description ?? "";
    loading.value = false;
  }

  @override
  void onInit() async {
    super.onInit();

    await _init();
  }
}
