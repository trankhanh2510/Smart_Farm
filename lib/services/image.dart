import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_farm/objs/image.dart';
import 'package:smart_farm/objs/image_local.dart';
import 'package:smart_farm/objs/upload_response.dart';
import 'package:smart_farm/services/local_storage.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/utils/init.dart';
import 'package:smart_farm/utils/tool.dart';
import 'package:path_provider/path_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart' as http_parser;

class ImageService {
  Future<List<ImageApp>> getDatas({int? limit, int? skip}) async {
    List<ImageApp> results = [];
    try {
      Dio dio = dioAuthentication();
      String url = "${Config.urlAPI}/api/file/image?";

      if (limit != null) {
        url += "limit=$limit&";
      }

      if (skip != null) {
        url += "skip=$skip&";
      }

      url += 'sort={"created_at": -1}';

      final res = await dio.get(url);
      dynamic datas = res.data['datas'];
      if (datas is List) {
        for (var e in datas) {
          ImageApp i = ImageApp.fromJson(jsonDecode(jsonEncode(e)));
          results.add(i);
        }
      }
    } catch (e) {
      Tool.showError(e);
    }
    return results;
  }

  Future<UploadResponse?> upload(
      ImageLocal value, Function(int, int) onSendProgress) async {
    UploadResponse? result;
    try {
      Dio dio = dioAuthentication();
      String url = "${Config.urlAPI}/api/file/image/upload";

      if (value.imageFile == null) return null;

      String fileName = value.imageFile!.path.split('/').last;
      String fileExt = value.imageFile!.path.split('.').last;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          value.imageFile!.path,
          filename: fileName,
          contentType: http_parser.MediaType("image", fileExt),
        ),
        'id_plant': value.idPlant,
        'id_plant_type': value.idPlantType,
        'id_condition': value.idCondition,
        'description': value.description,
      });

      final res = await dio.post(
        url,
        data: formData,
        onSendProgress: onSendProgress,
      );

      if (res.data['code'] == 200) {
        result = UploadResponse.fromJson(res.data['data']);
      }
    } catch (e) {
      log("$e", name: "upload");
      Tool.showError(e);
    }
    return result;
  }

  Future<bool> delete(ImageApp value) async {
    bool result = false;
    try {
      LocalStorage localStorage =
          await LocalStorage.init(Config.imageDetailLocal);
      Dio dio = dioAuthentication();

      String url = "${Config.urlAPI}/api/file/image";
      final res = await dio.delete(url, data: {
        "ids": [value.id]
      });

      if (res.data['code'] == 200) {
        ImageLocal? imageLocal = await getImageLocal(value.name);
        if (imageLocal != null && imageLocal.id != null) {
          imageLocal.uploaded = false;
          localStorage.update(imageLocal.id!, imageLocal.toJson());
        }
        result = true;
      }
    } catch (e) {
      Tool.showError(e);
    }
    return result;
  }

  Future<bool> saveFileLocal(String id, List<int> data) async {
    bool result = false;
    try {
      String path = (await getApplicationDocumentsDirectory()).path;

      Directory directory =
          await Directory("$path/images").create(recursive: true);
      await File("${directory.path}/$id.png").writeAsBytes(data);
      result = true;
    } catch (e) {
      log("$e", name: "saveFileLocal");
    }
    return result;
  }

  Future<bool> deleteFileLocal(String id) async {
    bool result = false;
    try {
      String path = (await getApplicationDocumentsDirectory()).path;
      await File("$path/images/$id.png").delete();
      result = true;
    } catch (e) {
      log("$e", name: "deleteFileLocal");
    }
    return result;
  }

  Future<bool> addImageLocal(Map<String, dynamic> data, File file) async {
    // print(data);
    bool result = false;
    try {
      LocalStorage localStorage =
          await LocalStorage.init(Config.imageDetailLocal);
      bool r = await saveFileLocal(data['id_image'], await file.readAsBytes());
      if (r) {
        await localStorage.insert(data);
        result = true;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi $e");
      log("$e", name: "addImageLocal");
    }
    return result;
  }

  Future<bool> deleteImageLocal(ImageLocal item) async {
    bool result = false;
    try {
      LocalStorage localStorage =
          await LocalStorage.init(Config.imageDetailLocal);
      await deleteFileLocal(item.idImage);
      await localStorage.delete(item.id);
      result = true;
    } catch (e) {
      log("$e", name: "deleteImageLocal");
    }
    return result;
  }

  Future<File?> getImage(String? id) async {
    File? file;
    try {
      String path = (await getApplicationDocumentsDirectory()).path;
      Directory directory = Directory("$path/images");
      file = File("${directory.path}/$id.png");
    } catch (e) {
      log("$e", name: "getImage");
    }
    return file;
  }

  Future<List<ImageLocal>> getImagesLocal() async {
    List<ImageLocal> results = [];
    try {
      LocalStorage localStorage =
          await LocalStorage.init(Config.imageDetailLocal);
      List<dynamic> datas = localStorage.read();
      for (var e in datas) {
        dynamic data = e;
        ImageLocal imageLocal =
            ImageLocal.fromJson(jsonDecode(jsonEncode(data)));
        File? image = await getImage(data['id_image']);
        imageLocal.imageFile = image;
        results.add(imageLocal);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi $e");
      log("$e", name: "getImagesLocal");
    }
    return results;
  }

  Future<ImageLocal?> getImageLocal(String name) async {
    ImageLocal? result;
    try {
      LocalStorage localStorage =
          await LocalStorage.init(Config.imageDetailLocal);
      List<dynamic> datas = localStorage.read();
      for (var e in datas) {
        dynamic data = e;
        ImageLocal imageLocal =
            ImageLocal.fromJson(jsonDecode(jsonEncode(data)));
        if (imageLocal.idImage == name) {
          File? image = await getImage(data['id_image']);
          imageLocal.imageFile = image;
          result = imageLocal;
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Lỗi $e");
      log("$e", name: "getImageLocal");
    }
    return result;
  }
}
