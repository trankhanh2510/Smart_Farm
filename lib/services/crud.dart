import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:smart_farm/utils/config.dart';
import 'package:smart_farm/utils/init.dart';
import 'package:smart_farm/utils/tool.dart';

class CrudService {
  Future<List<Map<String, dynamic>>> getDatas(
    String name, {
    Map<String, dynamic>? filter,
    int? limit,
    int? skip,
    Map<String, dynamic>? sort,
    List<String>? populates,
  }) async {
    List<Map<String, dynamic>> results = [];
    try {
      Dio dio = dioAuthentication();

      String url = "${Config.urlAPI}/api/db/$name?";

      if (filter != null) {
        url += "filter=${jsonEncode(filter)}&";
      }

      if (limit != null) {
        url += "limit=$limit&";
      }

      if (skip != null) {
        url += "skip=$skip&";
      }

      if (sort != null) {
        url += 'sort=${jsonEncode(sort)}&';
      }

      if (populates != null) {
        url += 'populate=${populates.join(",")}&';
      }

      final res = await dio.get(url);
      dynamic datas = res.data['datas'];
      if (datas is List) {
        for (var e in datas) {
          results.add(e);
        }
      }
    } catch (e) {
      Tool.showError(e);
    }

    return results;
  }

  Future<bool> create(String name, Map<String, dynamic> data) async {
    bool result = false;
    try {
      Dio dio = dioAuthentication();
      final res = await dio.post("${Config.urlAPI}/api/db/$name", data: data);
      if (res.data['code'] == 200) {
        result = true;
      }
    } catch (e) {
      log("$e", name: "create");
      Tool.showError(e);
    }
    return result;
  }

  Future<bool> update(String name, List<Map<String, dynamic>> datas) async {
    bool result = false;
    try {
      Dio dio = dioAuthentication();
      final res = await dio.patch(
        "${Config.urlAPI}/api/db/$name",
        data: {"data": datas},
      );
      if (res.data['code'] == 200) {
        dynamic errors = res.data['errors'];
        if (errors is List && errors.isEmpty) {
          result = true;
        }
      }
    } catch (e) {
      log("$e", name: "update");
      Tool.showError(e);
    }
    return result;
  }
}
