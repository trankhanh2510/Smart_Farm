import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class Tool {
  // ignore: non_constant_identifier_names
  static Color appBar_bg = Colors.green;
  // ignore: non_constant_identifier_names
  static Color appBar_title = Colors.white;

  static String removeDiacritics(String str) {
    const vietnamese = 'aAeEoOuUiIdDyY';
    final vietnameseRegex = <RegExp>[
      RegExp(r'à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ'),
      RegExp(r'À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ'),
      RegExp(r'è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ'),
      RegExp(r'È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ'),
      RegExp(r'ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ'),
      RegExp(r'Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ'),
      RegExp(r'ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ'),
      RegExp(r'Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ'),
      RegExp(r'ì|í|ị|ỉ|ĩ'),
      RegExp(r'Ì|Í|Ị|Ỉ|Ĩ'),
      RegExp(r'đ'),
      RegExp(r'Đ'),
      RegExp(r'ỳ|ý|ỵ|ỷ|ỹ'),
      RegExp(r'Ỳ|Ý|Ỵ|Ỷ|Ỹ')
    ];

    for (var i = 0; i < vietnamese.length; ++i) {
      str = str.replaceAll(vietnameseRegex[i], vietnamese[i]);
    }
    return str;
  }

  static final currencyFormat = NumberFormat("##,##0.0", "vi");

  static String formatCurrency(double currency) {
    String value = currencyFormat.format(currency);
    return value.substring(0, value.length - 2).replaceAll(".", ",");
  }

  static TextInputFormatter currencyInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String value = newValue.text.replaceAll(RegExp(r'[^\d\,]'), '');
      if (value == '') {
        value = '0';
      }
      final formatter = NumberFormat('#,###.##', 'vi_VN');
      String formattedValue = formatter.format(double.parse(value));
      formattedValue = formattedValue.replaceAll('.', ',');
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      ).copyWith(
        selection: TextSelection.collapsed(
          offset: formattedValue.isNotEmpty ? formattedValue.length : 0,
        ),
      );
    });
  }

  static void showError(dynamic e) {
    if (e is TimeoutException) {
      Fluttertoast.showToast(msg: "Không thể kết nối server");
    }
    if (e is DioException) {
      if (e.response?.statusCode == 400) {
        Fluttertoast.showToast(msg: "Yêu cầu không hợp lệ");
        return;
      }
      if (e.response?.statusCode == 401) {
        Fluttertoast.showToast(msg: "Không có xác thực");
        return;
      }
      if (e.response?.statusCode == 403) {
        Fluttertoast.showToast(msg: "Không được phép");
        return;
      }

      if (e.response?.statusCode == 404) {
        Fluttertoast.showToast(msg: "Chức năng không hợp lệ");
        return;
      }

      if (e.response?.statusCode == 405) {
        Fluttertoast.showToast(msg: "Phương thức yêu cầu không hợp lệ");
        return;
      }

      if (e.response?.statusCode == 500) {
        Fluttertoast.showToast(msg: "Lỗi server (500)");
        return;
      }
    } else {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }
}
