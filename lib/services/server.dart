import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_farm/services/crud.dart';
// import 'package:smart_farm/services/crud.dart';
import 'package:smart_farm/services/local_storage.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/utils/init.dart';
import 'package:smart_farm/utils/tool.dart';

class ServerService {
  // Future<bool> checkInternet() async {
  //   bool result = false;
  //   List<ConnectivityResult> results = await Connectivity().checkConnectivity();
  //   if (results.contains(ConnectivityResult.mobile) ||
  //       results.contains(ConnectivityResult.wifi)) {
  //     result = true;
  //   }
  //   return result;
  // }

  Future<bool> ping() async {
    bool result = false;
    try {
      Dio dio = dioAuthentication();
      final res = await dio
          .get("${Config.urlAPI}/api/")
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        result = true;
      }
    } catch (e) {
      Tool.showError(e);
      log("$e", name: "checkStatus");
    }
    return result;
  }

  Future<bool> checkInitFirstData() async {
    bool result = false;
    try {
      result = GetStorage().read(Config.initKey) ?? false;
    } catch (e) {
      log("$e", name: "checkInitFirstData");
    }
    return result;
  }

  Future<bool> initFirstData() async {
    bool result = false;
    try {
      final box = GetStorage();
      List<Map<String, dynamic>> plantTypes =
          await CrudService().getDatas(Config.plantType);
      LocalStorage localStoragePlantType =
          await LocalStorage.init(Config.plantType);
      for (var e in plantTypes) {
        await localStoragePlantType.insert(e);
      }

      List<Map<String, dynamic>> plantConditions =
          await CrudService().getDatas(Config.plantCondition);
      LocalStorage localStoragePlantCondition =
          await LocalStorage.init(Config.plantCondition);
      for (var e in plantConditions) {
        await localStoragePlantCondition.insert(e);
      }

      List<Map<String, dynamic>> plants =
          await CrudService().getDatas(Config.plant);
      LocalStorage localStoragePlant = await LocalStorage.init(Config.plant);
      for (var e in plants) {
        await localStoragePlant.insert(e);
      }

      await box.write(Config.initKey, true);
      result = true;
    } catch (e) {
      // Tool.showError(e);
    }
    return result;
  }

  Future<List<dynamic>> getOfflineDatas(String name) async {
    List<dynamic> results = [];
    try {
      final box = GetStorage();
      results = box.read(name);
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi: $e");
      log("$e", name: "getOfflineDatas");
    }
    return results;
  }
}
