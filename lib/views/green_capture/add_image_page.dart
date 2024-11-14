import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/image_controller/add_image_controller.dart';
import 'package:smart_farm/objs/plant.dart';
import 'package:smart_farm/utils/tool.dart';
import 'package:smart_farm/widgets/progress.dart';

class AddImageScreen extends StatelessWidget {
  const AddImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddImageController addImageController = Get.put(AddImageController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm ảnh"),
        backgroundColor: Tool.appBar_bg,
        foregroundColor: Tool.appBar_title,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Tool.appBar_title,
        ),
      ),
      body: const _Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await addImageController.addImage(),
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.save_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    AddImageController addImageController = Get.find<AddImageController>();
    return Obx(() {
      bool loading = addImageController.loading.value;
      return loading
          ? const CircularProgress()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Form(
                  key: addImageController.formKey,
                  child: const Column(
                    children: [
                      _SelectImage(),
                      Divider(),
                      _SelectPlant(),
                      _SelectPlantType(),
                      _SelectPlantCondition(),
                      _EditDescription(),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}

class _SelectImage extends StatelessWidget {
  const _SelectImage();

  @override
  Widget build(BuildContext context) {
    AddImageController addImageController = Get.find<AddImageController>();
    return Obx(() {
      final file = addImageController.image.value;
      return ListTile(
        leading: file == null ? null : Image.file(file),
        title: file == null
            ? const Text("Nhấn để chọn hình ảnh")
            : const Text("Nhấn để thay đổi"),
        onTap: () async => await addImageController.selectImage(),
      );
    });
  }
}

class _SelectPlant extends StatelessWidget {
  const _SelectPlant();

  @override
  Widget build(BuildContext context) {
    AddImageController addImageController = Get.find<AddImageController>();
    List<Plant> items = addImageController.plantViews;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: DropdownButtonFormField(
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Giống"),
        ),
        autovalidateMode: AutovalidateMode.always,
        validator: (value) {
          if (value == null) {
            return "Không được để trống";
          }
          return null;
        },
        onChanged: (value) => addImageController.plantSelected.value = value,
      ),
    );
  }
}

class _SelectPlantType extends StatelessWidget {
  const _SelectPlantType();

  @override
  Widget build(BuildContext context) {
    AddImageController addImageController = Get.find<AddImageController>();
    List<PlantType> items = addImageController.plantTypeViews;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: DropdownButtonFormField(
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Loại hình ảnh"),
        ),
        autovalidateMode: AutovalidateMode.always,
        validator: (value) {
          if (value == null) {
            return "Không được để trống";
          }
          return null;
        },
        onChanged: (value) =>
            addImageController.plantTypeSelected.value = value,
      ),
    );
  }
}

class _SelectPlantCondition extends StatelessWidget {
  const _SelectPlantCondition();

  @override
  Widget build(BuildContext context) {
    AddImageController addImageController = Get.find<AddImageController>();
    List<PlantCondition> items = addImageController.plantConditionViews;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: DropdownButtonFormField(
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
            .toList(),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Sinh trưởng"),
        ),
        autovalidateMode: AutovalidateMode.always,
        validator: (value) {
          if (value == null) {
            return "Không được để trống";
          }
          return null;
        },
        onChanged: (value) =>
            addImageController.plantConditionSelected.value = value,
      ),
    );
  }
}

class _EditDescription extends StatelessWidget {
  const _EditDescription();

  @override
  Widget build(BuildContext context) {
    AddImageController addImageController = Get.find<AddImageController>();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: addImageController.controllerDescription,
        keyboardType: TextInputType.multiline,
        minLines: 10,
        maxLines: 15,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Mô tả hình ảnh (nếu có)"),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}
