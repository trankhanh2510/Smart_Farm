import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/image_controller/image_management_controller.dart';
import 'package:smart_farm/objs/plant.dart';
import 'package:smart_farm/services/image.dart';
import 'package:smart_farm/services/local_storage.dart';
// import 'package:smart_farm/services/permission_app.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/widgets/dialog/dialog_bottom_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddImageController extends GetxController {
  RxBool loading = false.obs;
  final formKey = GlobalKey<FormState>();
  RxList<Plant> plantViews = <Plant>[].obs;
  RxList<PlantType> plantTypeViews = <PlantType>[].obs;
  RxList<PlantCondition> plantConditionViews = <PlantCondition>[].obs;
  Rx<Plant?> plantSelected = Rx(null);
  Rx<PlantType?> plantTypeSelected = Rx(null);
  Rx<PlantCondition?> plantConditionSelected = Rx(null);

  Rx<File?> image = Rx(null);
  TextEditingController controllerDescription = TextEditingController();

  // Future<void> _ready() async {
  //   bool pStorage = await PermissionAppService().requestPermissionStorage();
  //   bool pCamera = await PermissionAppService().requestPermissionCamera();
  //   if (!pStorage && !pCamera) {
  //     Fluttertoast.showToast(msg: "Vui lòng cấp quyền để sử dụng ứng dụng");
  //     Get.back();
  //   }
  // }

  Future<void> selectImage() async {
    List<DialogBottomMenuItem> menus = [];
    if (image.value != null) {
      menus.add(const DialogBottomMenuItem(
        icon: Icon(Icons.visibility_rounded),
        child: Text("Xem"),
        key: "view",
      ));
    }
    menus.add(const DialogBottomMenuItem(
      icon: Icon(Icons.camera_rounded),
      child: Text("Camera"),
      key: "camera",
    ));
    menus.add(const DialogBottomMenuItem(
      icon: Icon(Icons.image_rounded),
      child: Text("Thư viện"),
      key: "library",
    ));

    final ImagePicker picker = ImagePicker();
    DialogBottomMenuItem? item = await dialogBottomMenu("Menu", menus);

    if (item?.key == "view" && image.value != null) {
      Get.toNamed("/image-view", arguments: {"image": image.value});
    }

    XFile? photo;
    if (item?.key == "library") {
      photo = await picker.pickImage(source: ImageSource.gallery);
    }

    if (item?.key == "camera") {
      photo = await picker.pickImage(source: ImageSource.camera);
    }
    if (photo == null) return;

    File fileImage = File(photo.path);
    image.value = fileImage;
  }

  Future<void> addImage() async {
    if (image.value == null) {
      Fluttertoast.showToast(msg: "Vui lòng chọn hình ảnh");
      return;
    }

    if (formKey.currentState!.validate()) {
      String idImage = const Uuid().v4();
      Map<String, dynamic> data = {
        "id_plant": plantSelected.value!.id,
        "id_plant_type": plantTypeSelected.value!.id,
        "id_condition": plantConditionSelected.value!.id,
        "description": controllerDescription.text,
        "id_image": idImage,
        "created_at": DateTime.now().toIso8601String(),
      };
      bool result = await ImageService().addImageLocal(data, image.value!);
      if (result) {
        Fluttertoast.showToast(msg: "Đã lưu hình ảnh vào bộ nhớ cục bộ");
        await Get.find<ImageManagementController>().reload();
        Get.back();
      }
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
    loading.value = false;
  }

  @override
  void onInit() async {
    super.onInit();

    await _init();
  }
}
