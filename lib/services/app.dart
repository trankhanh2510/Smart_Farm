import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:smart_farm/objs/app_version.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/utils/init.dart';
import 'package:smart_farm/utils/tool.dart';
import 'package:smart_farm/widgets/dialog/dialog.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppService {
  Future<AppVersion?> hasNewVersion() async {
    AppVersion? result;
    // try {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // List<dynamic> datas = await CrudService().getDatas("app-version",
    //     filter: {
    //       "version_name": {"\$ne": packageInfo.version}
    //     },
    //     limit: 1,
    //     sort: {'created_at': 1});

    // if (datas.length == 1) {
    //   AppVersion appVersion =
    //       AppVersion.fromJson(jsonDecode(jsonEncode(datas[0])));
    //   if (packageInfo.version != appVersion.versionName) {
    //     result = appVersion;
    //   }
    // }
    // } catch (e) {
    //   Tool.showError(e);
    // }
    return result;
  }

  Future<dynamic> installApk(File file) async {
    // return await OpenFilex.open(file.path);
  }

  Future<void> deleteAPK() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      File apk = File("${directory.path}/smart_farm.apk");
      if (await apk.exists()) {
        unawaited(apk.delete());
      }
    }
  }

  Future<void> downloadAndInstall(AppVersion value) async {
    try {
      DownloadController downloadController = Get.find<DownloadController>();
      Dio dio = dioAuthentication();
      Directory? directory = await getExternalStorageDirectory();
      String url = "${Config.urlAPI}${value.urlDownloadFile}";
      File apk = File("${directory!.path}/smart_farm.apk");
      if (await apk.exists()) {
        await installApk(apk);
      } else {
        await dio.download(
          url,
          "${directory.path}/smart_farm.apk",
          onReceiveProgress: (count, total) async {
            downloadController.total.value = total;
            downloadController.receive.value = count;
          },
        );

        log("Đã tải xong, cập nhật ứng dụng",
            name: "AppService - downloadAndInstall");
        await installApk(apk);
      }
    } catch (e) {
      Tool.showError(e);
    }
  }
}
