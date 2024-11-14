import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_farm/controller/green_capture_controller.dart';
import 'package:smart_farm/objs/plant.dart';
// import 'package:smart_farm/widgets/dialog/dialog_date_picker_range.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:smart_farm/widgets/dialog/dialog_date_picker_range.dart';
import 'package:smart_farm/widgets/theme.dart';

dialogFilterImages() async {
  GreenCaptureController greenCaptureController =
      Get.find<GreenCaptureController>();
  return Get.bottomSheet(
    Container(
      color: Get.theme.colorScheme.surface,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    "Lọc hình ảnh",
                    style: ThemeApp.textStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () async =>
                          await greenCaptureController.deleteFilter(),
                      child: const Text("Xóa")),
                  TextButton(
                      onPressed: () async =>
                          await greenCaptureController.filter(),
                      child: const Text("Lọc")),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: const Column(
                  children: [
                    _SelectDate(),
                    _SelectPlant(),
                    _SelectPlantType(),
                    _SelectPlantCondition(),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    ),
    isScrollControlled: false,
  );
}

class _SelectDate extends StatelessWidget {
  const _SelectDate();

  @override
  Widget build(BuildContext context) {
    GreenCaptureController greenCaptureController =
        Get.find<GreenCaptureController>();
    return Column(
      children: [
        Obx(() {
          DateTime? start = greenCaptureController.dateStartFilter.value;
          DateTime? end = greenCaptureController.dateEndFilter.value;
          String date = "Ngày";
          if (start != null) {
            date += ": ${DateFormat("dd/MM/yyyy").format(start)}";
          }
          if (end != null) {
            date += " - ${DateFormat("dd/MM/yyyy").format(end)}";
          }
          return ListTile(
            title: Text(date),
            subtitle: const Text("Nhấn để chọn ngày"),
            onTap: () async {
              Map<String, DateTime?> data = await dialogDatePickerRange(
                context: context,
                start: start,
                end: end,
              );
              greenCaptureController.dateStartFilter.value = data["start"];
              greenCaptureController.dateEndFilter.value = data["end"];
            },
          );
        }),
      ],
    );
  }
}

class _SelectPlant extends StatelessWidget {
  const _SelectPlant();

  @override
  Widget build(BuildContext context) {
    GreenCaptureController greenCaptureController =
        Get.find<GreenCaptureController>();
    List<Plant> items = greenCaptureController.plantViews;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: DropdownButtonFormField(
        value: greenCaptureController.plantSelectedFilter.value,
        items: [
          const DropdownMenuItem(value: null, child: Text("Không")),
          ...items.map((e) => DropdownMenuItem(value: e, child: Text(e.name))),
        ],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Giống"),
        ),
        onChanged: (value) =>
            greenCaptureController.plantSelectedFilter.value = value,
      ),
    );
  }
}

class _SelectPlantType extends StatelessWidget {
  const _SelectPlantType();

  @override
  Widget build(BuildContext context) {
    GreenCaptureController greenCaptureController =
        Get.find<GreenCaptureController>();
    List<PlantType> items = greenCaptureController.plantTypeViews;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: DropdownButtonFormField(
        value: greenCaptureController.plantTypeSelectedFilter.value,
        items: [
          const DropdownMenuItem(value: null, child: Text("Không")),
          ...items.map((e) => DropdownMenuItem(value: e, child: Text(e.name))),
        ],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Loại hình ảnh"),
        ),
        onChanged: (value) =>
            greenCaptureController.plantTypeSelectedFilter.value = value,
      ),
    );
  }
}

class _SelectPlantCondition extends StatelessWidget {
  const _SelectPlantCondition();

  @override
  Widget build(BuildContext context) {
    GreenCaptureController greenCaptureController =
        Get.find<GreenCaptureController>();
    List<PlantCondition> items = greenCaptureController.plantConditionViews;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: DropdownButtonFormField(
        value: greenCaptureController.plantConditionSelectedFilter.value,
        items: [
          const DropdownMenuItem(value: null, child: Text("Không")),
          ...items.map((e) => DropdownMenuItem(value: e, child: Text(e.name))),
        ],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Sinh trưởng"),
        ),
        onChanged: (value) =>
            greenCaptureController.plantConditionSelectedFilter.value = value,
      ),
    );
  }
}
