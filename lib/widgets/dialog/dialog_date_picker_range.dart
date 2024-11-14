import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

Future<Map<String, DateTime?>> dialogDatePickerRange({
  DateTime? start,
  DateTime? end,
  required BuildContext context,
}) async {
  Map<String, DateTime?> values = {
    "start": null,
    "end": null,
  };

  // List<DateTime> init = [];
  // if (start != null) {
  //   init.add(start);
  // }
  // if (end != null) {
  //   init.add(end);
  // }
  DateTimeRange? dateTimeRange;
  if (start == null || end == null) {
    dateTimeRange = null;
  } else {
    dateTimeRange = DateTimeRange(start: start, end: end);
  }

  final DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 100, 1, 1),
    lastDate: DateTime(DateTime.now().year + 100, 1, 1),
    initialDateRange: dateTimeRange,
    builder: (context, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height * 0.75,
            width: Get.width * 0.9,
            child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.green, // Màu của tiêu đề
                    onPrimary: Colors.white, // Màu của văn bản tiêu đề
                    onSurface: Colors.green, // Màu của các ngày trong lịch
                    surface: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green, // Màu nút "Save"
                    ),
                  ),
                ),
                child: child!),
          )
        ],
      );
    },
  );
  if (picked != null) {
    values["start"] = picked.start;
    values["end"] = picked.end;
  }

  // await Get.bottomSheet(
  //   Container(
  //     height: 380,
  //     color: Get.theme.colorScheme.surface,
  //     child: ListView(
  //       children: [
  //         // SfDateRangePicker(
  //         //   initialSelectedDates: init,
  //         //   selectionMode: DateRangePickerSelectionMode.range,
  //         //   onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
  //         //     values["start"] =
  //         //         dateRangePickerSelectionChangedArgs.value.startDate;
  //         //     values["end"] = dateRangePickerSelectionChangedArgs.value.endDate;
  //         //   },
  //         // ),
  //         const SizedBox(height: 10),
  //         Center(
  //           child: TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: const Text("Đồng ý"),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  //   isScrollControlled: true,
  // );

  return values;
}
