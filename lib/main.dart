// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<Uint8List> getImageBytes(String imagePath) async {
  // Đọc tệp hình ảnh dưới dạng byte array
  File imageFile = File(imagePath);
  List<int> bytes = await imageFile.readAsBytes();
  Uint8List uint8List = Uint8List.fromList(bytes);
  return uint8List;
}

// Hàm gửi ảnh lên server
Future<String> postImage(Uint8List imageBytes) async {
  // Tạo yêu cầu multipart
  var request = http.MultipartRequest(
      'POST', Uri.parse('http://10.0.54.74:5000/predict'));

  // Thêm file ảnh vào yêu cầu multipart
  // log("imageFile: $imageFile");
  // log("imageFile.path: ${imageFile.path}");
  // request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  // Thêm dữ liệu ảnh vào yêu cầu multipart từ bytes
  // log("message: $imageBytes");
  request.files.add(http.MultipartFile.fromBytes(
    'image', // Tên trường của ảnh
    imageBytes, // Dữ liệu ảnh dưới dạng bytes
    filename:
        'image.jpg', // Tên tệp ảnh (có thể thay đổi), // Kiểu dữ liệu của ảnh (có thể thay đổi)
  ));

  var response = await request.send();

  // Đọc phản hồi từ server
  var responseData = await response.stream.bytesToString();

  // Trả về dữ liệu phản hồi từ server
  return responseData;
}

// // Hàm gọi khi người dùng chụp ảnh hoặc chọn ảnh từ thư viện
// void captureOrSelectImage() async {
//   // Code để chụp ảnh hoặc chọn ảnh từ thư viện ở đây
//   // Sau khi có được ảnh, gọi hàm postImage và chờ kết quả từ server
//   File? imageFile =
//       await getImage(); // Hàm này để chụp ảnh hoặc chọn ảnh từ thư viện
//   if (imageFile != null) {
//     String result = await postImage(imageFile);
//     print(result); // In kết quả từ server
//   }
// }

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TakePictureScreen(),
                  ),
                );
              },
              child: const Text('Open Camera'),
            ),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);

                if (pickedImage != null) {
                  String result =
                      await postImage(await getImageBytes(pickedImage.path));
                  Map<String, dynamic> jsonResponse = jsonDecode(result);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Predicted Class'),
                        content: Text(jsonResponse['predicted_class']),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Open Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the camera controller
    _controller = CameraController(
      const CameraDescription(
        name: '0',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: -1,
      ),
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            log('Error taking picture: $e');
          }
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Lấy dữ liệu nhị phân của hình ảnh
                // String result = await postImage(File(imagePath));
                String result = await postImage(await getImageBytes(imagePath));
                // log("result: $result"); // In kết quả từ server // Back to the previous screen (TakePictureScreen)
                // Chuyển đổi chuỗi JSON thành một Map<String, dynamic>
                Map<String, dynamic> jsonResponse = jsonDecode(result);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Predicted Class'),
                      content: Text(jsonResponse['predicted_class']),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('POST'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Back to the previous screen (TakePictureScreen)
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
