import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;

final dio = Dio();

Future<Uint8List> getImageBytes(String imagePath) async {
  // Đọc tệp hình ảnh dưới dạng byte array
  File imageFile = File(imagePath);
  List<int> bytes = await imageFile.readAsBytes();
  Uint8List uint8List = Uint8List.fromList(bytes);
  return uint8List;
}

String imageFileToBase64(String imagePath) {
  // Đọc dữ liệu từ File
  List<int> imageBytes = File(imagePath).readAsBytesSync();
  // Chuyển đổi List<int> thành String base64
  return base64Encode(imageBytes);
}

// Hàm gửi ảnh lên server
Future<String> postImage(String imageBytes) async {
  // // Tạo yêu cầu multipart
  // var request = http.MultipartRequest(
  //     'POST', Uri.parse('http://10.0.54.251:5000/predict'));
  // // Thêm dữ liệu ảnh vào yêu cầu multipart từ bytes
  // request.files.add(http.MultipartFile.fromBytes(
  //   'image', // Tên trường của ảnh
  //   imageBytes, // Dữ liệu ảnh dưới dạng bytes
  //   filename:
  //       'image.jpg', // Tên tệp ảnh (có thể thay đổi), // Kiểu dữ liệu của ảnh (có thể thay đổi)
  // ));
  // var response = await request.send();
  // // Đọc phản hồi từ server
  // var responseData = await response.stream.bytesToString();

  var responseData = await dio.post('http://10.0.54.251:5000/predict', data: {
    'image': imageBytes,
  });
  return responseData.toString();
}


