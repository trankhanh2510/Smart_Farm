// import 'dart:developer';

// import 'package:permission_handler/permission_handler.dart';

// class PermissionAppService {
//   Future<bool> requestPermissionStorage() async {
//     bool result = false;
//     try {
//       if (await Permission.photos.request().isGranted &&
//               await Permission.audio.request().isGranted &&
//               await Permission.videos.request().isGranted ||
//           await Permission.manageExternalStorage.request().isGranted ||
//           await Permission.storage.request().isGranted) {
//         result = true;
//       }
//     } catch (e) {
//       log("$e", name: "requestPermissionStorage");
//     }
//     return result;
//   }

//   Future<bool> requestPermissionCamera() async {
//     bool result = false;
//     try {
//       if (await Permission.camera.request().isGranted) {
//         result = true;
//       }
//     } catch (e) {
//       log("$e", name: "requestPermissionCamera");
//     }
//     return result;
//   }
// }
