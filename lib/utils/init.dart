import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> init() async {
  await GetStorage.init();
  await GetStorage().write(Config.apiKey, "api-DEFAULT");
  Directory dir = (await getExternalStorageDirectory())!;
  Hive.init(dir.path);
}

Dio dioAuthentication() {
  GetStorage box = GetStorage();
  return Dio(
    BaseOptions(
      headers: {
        "Cookie": box.read(Config.keyCookie),
        "Authorization": "Bearer ${box.read(Config.apiKey)}",
      },
    ),
  );
}
